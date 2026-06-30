#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [string[]]$ComputerName = @("LON-SVR1", "LON-SVR2"),
    [int]$RestartTimeoutSeconds = 900,
    [System.Management.Automation.PSCredential]$Credential
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

function Get-ShortComputerName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    ($Name.Split(".")[0]).ToUpperInvariant()
}

function Set-LabConstrainedDelegation {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$HyperVHosts
    )

    Import-Module ActiveDirectory -ErrorAction Stop

    $domain = Get-ADDomain
    $trustedToAuthForDelegation = 0x1000000
    $delegationResults = foreach ($sourceHost in $HyperVHosts) {
        $sourceShortName = Get-ShortComputerName -Name $sourceHost
        $sourceComputer = Get-ADComputer -Identity $sourceShortName -Properties msDS-AllowedToDelegateTo, userAccountControl

        $targetSpnList = [System.Collections.Generic.List[string]]::new()
        foreach ($targetHost in $HyperVHosts) {
            $targetShortName = Get-ShortComputerName -Name $targetHost
            if ($targetShortName -eq $sourceShortName) {
                continue
            }

            $targetFqdn = "$($targetShortName.ToLowerInvariant()).$($domain.DNSRoot)"
            $targetSpnList.Add("cifs/$targetShortName")
            $targetSpnList.Add("cifs/$targetFqdn")
            $targetSpnList.Add("Microsoft Virtual System Migration Service/$targetShortName")
            $targetSpnList.Add("Microsoft Virtual System Migration Service/$targetFqdn")
        }

        $allSpns = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($existingSpn in @($sourceComputer.'msDS-AllowedToDelegateTo')) {
            if ($existingSpn) {
                $null = $allSpns.Add([string]$existingSpn)
            }
        }

        $missingSpnList = [System.Collections.Generic.List[string]]::new()
        foreach ($targetSpn in $targetSpnList) {
            if (-not $allSpns.Contains($targetSpn)) {
                $missingSpnList.Add($targetSpn)
                $null = $allSpns.Add($targetSpn)
            }
        }

        $targetSpnList = [System.Collections.Generic.List[string]]::new()
        foreach ($spn in ($allSpns | Sort-Object)) {
            $targetSpnList.Add([string]$spn)
        }

        $targetSpns = [string[]]$targetSpnList.ToArray()
        $missingSpns = [string[]]$missingSpnList.ToArray()

        if ($missingSpns.Count -gt 0) {
            Set-ADObject -Identity $sourceComputer.DistinguishedName -Replace @{ "msDS-AllowedToDelegateTo" = $targetSpns }
        }

        if (($sourceComputer.userAccountControl -band $trustedToAuthForDelegation) -eq 0) {
            Set-ADAccountControl -Identity $sourceComputer.DistinguishedName -TrustedToAuthForDelegation $true
        }

        [pscustomobject]@{
            ComputerName = $sourceShortName
            AddedDelegationEntries = $missingSpns.Count
            DelegationEntries = ($targetSpns -join "; ")
            ProtocolTransitionEnabled = $true
        }
    }

    $delegationResults
}

if (-not (Test-IsAdministrator)) {
    throw "Run this script from an elevated Windows PowerShell session."
}

$ComputerName = @($ComputerName | Where-Object { $_ } | Select-Object -Unique)
if ($ComputerName.Count -eq 0) {
    throw "Specify at least one server name."
}

if (-not $Credential) {
    # Lab-only credential used so remote role installation runs with the intended domain administrator account.
    $labPassword = ConvertTo-SecureString "Pa55w.rd" -AsPlainText -Force
    $Credential = [System.Management.Automation.PSCredential]::new("CONTOSO\Administrator", $labPassword)
}

Write-LabSection "Configuring Kerberos constrained delegation"

$delegationResults = Set-LabConstrainedDelegation -HyperVHosts $ComputerName
$delegationResults |
    Sort-Object ComputerName |
    Format-Table ComputerName, AddedDelegationEntries, ProtocolTransitionEnabled, DelegationEntries -AutoSize

Write-LabSection "Checking PowerShell remoting"

$unreachableServers = New-Object System.Collections.Generic.List[string]
$remoteCommandFailures = New-Object System.Collections.Generic.List[string]
$localComputerName = Get-ShortComputerName -Name $env:COMPUTERNAME
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

Write-LabSection "Checking command access"

$sessionOptions = @{
    ErrorAction = "Stop"
}
if ($Credential) {
    $sessionOptions.Credential = $Credential
}

$remoteSessions = @{}
foreach ($server in $ComputerName) {
    $session = $null
    $shortServerName = Get-ShortComputerName -Name $server
    if ($shortServerName -eq $localComputerName) {
        Write-Host "$server is the local computer. The install will run locally instead of through remoting."
        continue
    }

    Write-Host "Creating a remote session to $server..."
    try {
        $session = New-PSSession -ComputerName $server @sessionOptions
        $accessCheck = Invoke-Command -Session $session -ScriptBlock {
            $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
            $principal = [Security.Principal.WindowsPrincipal]::new($identity)
            [pscustomobject]@{
                ComputerName = $env:COMPUTERNAME
                UserName = $identity.Name
                IsAdministrator = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
            }
        } -ErrorAction Stop

        if (-not $accessCheck.IsAdministrator) {
            throw "The remote session is running as $($accessCheck.UserName), but that account is not an administrator on $server."
        }

        $remoteSessions[$server] = $session
        Write-Host "Remote command access is available on $server as $($accessCheck.UserName)." -ForegroundColor Green
    }
    catch {
        Write-Warning "Remote command access failed on $server. $($_.Exception.Message)"
        if ($session) {
            Remove-PSSession -Session $session -ErrorAction SilentlyContinue
        }
        $remoteCommandFailures.Add($server)
    }
}

if ($remoteCommandFailures.Count -gt 0) {
    throw "Resolve remote command access before installing Hyper-V. Failed server(s): $($remoteCommandFailures -join ', ')"
}

Write-LabSection "Checking current Hyper-V status"

$hyperVStatusScript = {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TargetComputerName
    )

    $feature = Get-WindowsFeature -Name Hyper-V
    [pscustomobject]@{
        ComputerName = $TargetComputerName
        ActualComputerName = $env:COMPUTERNAME
        HyperVInstalled = [bool]$feature.Installed
        InstallState = [string]$feature.InstallState
    }
}

$preInstallHyperVStatus = foreach ($server in $ComputerName) {
    $shortServerName = Get-ShortComputerName -Name $server
    if ($shortServerName -eq $localComputerName) {
        & $hyperVStatusScript -TargetComputerName $server
    }
    else {
        Invoke-Command -Session $remoteSessions[$server] -ScriptBlock $hyperVStatusScript -ArgumentList $server -ErrorAction Stop
    }
}

$preInstallHyperVStatus |
    Sort-Object ComputerName |
    Format-Table ComputerName, ActualComputerName, HyperVInstalled, InstallState -AutoSize

Write-LabSection "Installing Hyper-V with management tools"

$installScript = {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TargetComputerName
    )

    $ErrorActionPreference = "Stop"

    $feature = Get-WindowsFeature -Name Hyper-V
    if ($feature.Installed) {
        [pscustomobject]@{
            ComputerName = $TargetComputerName
            ActualComputerName = $env:COMPUTERNAME
            Status = "Already installed"
            Success = $true
            RestartNeeded = "No"
            Message = "Hyper-V is already installed."
        }
        return
    }

    $result = Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
    [pscustomobject]@{
        ComputerName = $TargetComputerName
        ActualComputerName = $env:COMPUTERNAME
        Status = if ($result.Success) { "Installed" } else { "Install failed" }
        Success = [bool]$result.Success
        RestartNeeded = [string]$result.RestartNeeded
        Message = if ($result.ExitCode) { [string]$result.ExitCode } else { "Install-WindowsFeature completed." }
    }
}

$installResults = foreach ($server in $ComputerName) {
    Write-Host "Installing Hyper-V on $server..."
    $shortServerName = Get-ShortComputerName -Name $server
    if ($shortServerName -eq $localComputerName) {
        & $installScript -TargetComputerName $server
    }
    else {
        try {
            Invoke-Command -Session $remoteSessions[$server] -ScriptBlock $installScript -ArgumentList $server -ErrorAction Stop
        }
        catch {
            [pscustomobject]@{
                ComputerName = $server
                ActualComputerName = $null
                Status = "Install failed"
                Success = $false
                RestartNeeded = "Unknown"
                Message = $_.Exception.Message
            }
        }
    }
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
    Format-Table ComputerName, ActualComputerName, Status, Success, RestartNeeded, Message -AutoSize

$failedInstalls = @($installResults | Where-Object { -not $_.Success })
if ($failedInstalls.Count -gt 0) {
    throw "Hyper-V installation failed on: $($failedInstalls.ComputerName -join ', '). Review the Message column for the remote error."
}

$serversNeedingRestart = @(
    $installResults |
        Where-Object { $_.RestartNeeded -eq "Yes" } |
        Select-Object -ExpandProperty ComputerName
)

if ($serversNeedingRestart.Count -gt 0) {
    Write-LabSection "Restarting servers that require it"
    Write-Host "Restarting: $($serversNeedingRestart -join ', ')"
    if ($remoteSessions.Count -gt 0) {
        $remoteSessions.Values | Remove-PSSession -ErrorAction SilentlyContinue
        $remoteSessions.Clear()
    }
    $restartOptions = @{
        ComputerName = $serversNeedingRestart
        Force = $true
        Wait = $true
        For = "PowerShell"
        Timeout = $RestartTimeoutSeconds
        Delay = 15
    }
    if ($Credential) {
        $restartOptions.Credential = $Credential
    }
    Restart-Computer @restartOptions
    Write-Host "Restart complete." -ForegroundColor Green
}
else {
    Write-LabSection "Restart check"
    Write-Host "No restart is required." -ForegroundColor Green
}

Write-LabSection "Verifying Hyper-V installation"

$verificationScript = {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TargetComputerName
    )

    $feature = Get-WindowsFeature -Name Hyper-V
    [pscustomobject]@{
        ComputerName = $TargetComputerName
        ActualComputerName = $env:COMPUTERNAME
        HyperVInstalled = [bool]$feature.Installed
        InstallState = [string]$feature.InstallState
    }
}

$verificationResults = foreach ($server in $ComputerName) {
    $shortServerName = Get-ShortComputerName -Name $server
    if ($shortServerName -eq $localComputerName) {
        & $verificationScript -TargetComputerName $server
    }
    else {
        Invoke-Command -ComputerName $server @sessionOptions -ScriptBlock $verificationScript -ArgumentList $server
    }
}
$verificationResults |
    Sort-Object ComputerName |
    Format-Table ComputerName, ActualComputerName, HyperVInstalled, InstallState -AutoSize

$missingHyperV = @($verificationResults | Where-Object { -not $_.HyperVInstalled })
if ($missingHyperV.Count -gt 0) {
    throw "Hyper-V was not verified on: $($missingHyperV.ComputerName -join ', ')"
}

Write-Host ""
Write-Host "Hyper-V installation and verification completed for $($ComputerName -join ', ')." -ForegroundColor Green

if ($remoteSessions.Count -gt 0) {
    $remoteSessions.Values | Remove-PSSession
}
