#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [string[]]$ComputerName = @("LON-SVR1", "LON-SVR2"),
    [int]$RestartTimeoutSeconds = 900
)

$ErrorActionPreference = "Stop"

function Write-LabSection {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host ""
    Write-Host "=== $Message ===" -ForegroundColor Cyan
}

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdministrator)) {
    throw "Run this script from an elevated Windows PowerShell session."
}

$ComputerName = @($ComputerName | Where-Object { $_ } | Select-Object -Unique)
if ($ComputerName.Count -eq 0) {
    throw "Specify at least one server name."
}

Write-LabSection "Checking PowerShell remoting"

$unreachableServers = New-Object System.Collections.Generic.List[string]
foreach ($server in $ComputerName) {
    Write-Host "Testing remoting to $server..."
    try {
        Test-WSMan -ComputerName $server -ErrorAction Stop | Out-Null
        Write-Host "Remoting is available on $server." -ForegroundColor Green
    }
    catch {
        Write-Warning "PowerShell remoting is not available on $server. $($_.Exception.Message)"
        $unreachableServers.Add($server)
    }
}

if ($unreachableServers.Count -gt 0) {
    throw "Resolve PowerShell remoting connectivity before installing Hyper-V. Unreachable server(s): $($unreachableServers -join ', ')"
}

Write-LabSection "Installing Hyper-V with management tools"

$installScript = {
    $ErrorActionPreference = "Stop"

    $feature = Get-WindowsFeature -Name Hyper-V
    if ($feature.Installed) {
        [pscustomobject]@{
            ComputerName = $env:COMPUTERNAME
            Status = "Already installed"
            Success = $true
            RestartNeeded = "No"
            Message = "Hyper-V is already installed."
        }
        return
    }

    $result = Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
    [pscustomobject]@{
        ComputerName = $env:COMPUTERNAME
        Status = if ($result.Success) { "Installed" } else { "Install failed" }
        Success = [bool]$result.Success
        RestartNeeded = [string]$result.RestartNeeded
        Message = if ($result.ExitCode) { [string]$result.ExitCode } else { "Install-WindowsFeature completed." }
    }
}

$job = Invoke-Command -ComputerName $ComputerName -ScriptBlock $installScript -AsJob
Wait-Job -Job $job | Out-Null
$installJobFailures = @(
    $job.ChildJobs |
        Where-Object { $_.State -ne "Completed" } |
        ForEach-Object {
            [pscustomobject]@{
                ComputerName = $_.Location
                State = $_.State
                Error = ($_.JobStateInfo.Reason.Message)
            }
        }
)
$installResults = Receive-Job -Job $job
Remove-Job -Job $job

if ($installJobFailures.Count -gt 0) {
    $installJobFailures | Format-Table ComputerName, State, Error -AutoSize
    throw "Hyper-V installation did not complete on: $($installJobFailures.ComputerName -join ', ')"
}

$missingInstallResults = @(
    $ComputerName |
        Where-Object { $installResults.ComputerName -notcontains $_ }
)
if ($missingInstallResults.Count -gt 0) {
    throw "No installation result was returned from: $($missingInstallResults -join ', ')"
}

$installResults |
    Sort-Object ComputerName |
    Format-Table ComputerName, Status, Success, RestartNeeded, Message -AutoSize

$failedInstalls = @($installResults | Where-Object { -not $_.Success })
if ($failedInstalls.Count -gt 0) {
    throw "Hyper-V installation failed on: $($failedInstalls.ComputerName -join ', ')"
}

$serversNeedingRestart = @(
    $installResults |
        Where-Object { $_.RestartNeeded -eq "Yes" } |
        Select-Object -ExpandProperty ComputerName
)

if ($serversNeedingRestart.Count -gt 0) {
    Write-LabSection "Restarting servers that require it"
    Write-Host "Restarting: $($serversNeedingRestart -join ', ')"
    Restart-Computer -ComputerName $serversNeedingRestart -Force -Wait -For PowerShell -Timeout $RestartTimeoutSeconds -Delay 15
    Write-Host "Restart complete." -ForegroundColor Green
}
else {
    Write-LabSection "Restart check"
    Write-Host "No restart is required." -ForegroundColor Green
}

Write-LabSection "Verifying Hyper-V installation"

$verificationScript = {
    $feature = Get-WindowsFeature -Name Hyper-V
    [pscustomobject]@{
        ComputerName = $env:COMPUTERNAME
        HyperVInstalled = [bool]$feature.Installed
        InstallState = [string]$feature.InstallState
    }
}

$verificationResults = Invoke-Command -ComputerName $ComputerName -ScriptBlock $verificationScript
$verificationResults |
    Sort-Object ComputerName |
    Format-Table ComputerName, HyperVInstalled, InstallState -AutoSize

$missingHyperV = @($verificationResults | Where-Object { -not $_.HyperVInstalled })
if ($missingHyperV.Count -gt 0) {
    throw "Hyper-V was not verified on: $($missingHyperV.ComputerName -join ', ')"
}

Write-Host ""
Write-Host "Hyper-V installation and verification completed for $($ComputerName -join ', ')." -ForegroundColor Green
