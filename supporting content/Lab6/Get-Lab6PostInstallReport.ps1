param(
    [string]$OutputFolder = "C:\LabOutput",
    [string]$ReportPath
)

$ErrorActionPreference = "Continue"

$expectedComputerName = "LON-SVR1"
$expectedDomain = "contoso.com"
$reportTime = Get-Date

if (-not $ReportPath) {
    $timestamp = $reportTime.ToString("yyyyMMdd-HHmmss")
    $ReportPath = Join-Path -Path $OutputFolder -ChildPath "Lab6-PostInstall-Report-$timestamp.html"
}

function Invoke-LabCheck {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$ScriptBlock,

        [string]$FallbackMessage = "The check could not be completed."
    )

    try {
        & $ScriptBlock
    }
    catch {
        [pscustomobject]@{
            Check = "Error"
            Status = "Review"
            Details = "$FallbackMessage $($_.Exception.Message)"
        }
    }
}

function ConvertTo-ReportFragment {
    param(
        [string]$Title,
        [object]$InputObject,
        [string]$PreformattedText
    )

    $html = New-Object System.Collections.Generic.List[string]
    $html.Add("<section>")
    $html.Add("<h2>$Title</h2>")

    if ($PreformattedText) {
        $encoded = [System.Net.WebUtility]::HtmlEncode($PreformattedText)
        $html.Add("<pre>$encoded</pre>")
    }
    elseif ($null -ne $InputObject) {
        $fragment = $InputObject | ConvertTo-Html -Fragment
        $html.Add(($fragment -join [Environment]::NewLine))
    }
    else {
        $html.Add("<p>No data was returned for this section.</p>")
    }

    $html.Add("</section>")
    $html -join [Environment]::NewLine
}

function Get-Status {
    param(
        [bool]$Passed,
        [string]$PassText = "Pass",
        [string]$ReviewText = "Review"
    )

    if ($Passed) {
        $PassText
    }
    else {
        $ReviewText
    }
}

New-Item -Path (Split-Path -Path $ReportPath -Parent) -ItemType Directory -Force | Out-Null

$computerInfo = Invoke-LabCheck -FallbackMessage "Unable to read computer information." -ScriptBlock {
    Get-ComputerInfo | Select-Object CsName, CsDomain, WindowsProductName, OsName, OsVersion, OsHardwareAbstractionLayer
}

$explorerProcess = Get-Process explorer -ErrorAction SilentlyContinue
$identityChecks = @(
    [pscustomobject]@{
        Check = "Computer name"
        Expected = $expectedComputerName
        Actual = $computerInfo.CsName
        Status = Get-Status -Passed ($computerInfo.CsName -eq $expectedComputerName)
        Notes = "Confirms the learner is running the report on the correct server."
    }
    [pscustomobject]@{
        Check = "Domain membership"
        Expected = $expectedDomain
        Actual = $computerInfo.CsDomain
        Status = Get-Status -Passed ($computerInfo.CsDomain -eq $expectedDomain)
        Notes = "Confirms the server is joined to the lab domain."
    }
    [pscustomobject]@{
        Check = "Operating system"
        Expected = "Windows Server 2025"
        Actual = $computerInfo.WindowsProductName
        Status = Get-Status -Passed ($computerInfo.WindowsProductName -like "*Windows Server 2025*")
        Notes = "Confirms the Windows Server version used in the lab."
    }
    [pscustomobject]@{
        Check = "Desktop Experience shell"
        Expected = "explorer.exe running"
        Actual = if ($explorerProcess) { "explorer.exe running" } else { "explorer.exe not detected" }
        Status = Get-Status -Passed ([bool]$explorerProcess)
        Notes = "A running Explorer shell indicates the local Desktop Experience is active."
    }
)

$networkConfig = Invoke-LabCheck -FallbackMessage "Unable to read network configuration." -ScriptBlock {
    Get-NetIPConfiguration |
        Where-Object { $_.IPv4Address } |
        Select-Object InterfaceAlias,
            @{Name = "IPv4Address"; Expression = { ($_.IPv4Address.IPAddress -join ", ") }},
            @{Name = "DefaultGateway"; Expression = { ($_.IPv4DefaultGateway.NextHop -join ", ") }},
            @{Name = "DNSServer"; Expression = { ($_.DNSServer.ServerAddresses -join ", ") }}
}

$dnsDc1 = Invoke-LabCheck -FallbackMessage "Unable to resolve LON-DC1." -ScriptBlock {
    Resolve-DnsName LON-DC1.contoso.com -ErrorAction Stop |
        Where-Object { $_.IPAddress } |
        Select-Object Name, Type, IPAddress
}

$dnsSrv2 = Invoke-LabCheck -FallbackMessage "Unable to resolve LON-SVR2." -ScriptBlock {
    Resolve-DnsName LON-SVR2.contoso.com -ErrorAction Stop |
        Where-Object { $_.IPAddress } |
        Select-Object Name, Type, IPAddress
}

$connectionChecks = @(
    Invoke-LabCheck -FallbackMessage "Unable to test ICMP connectivity to LON-DC1." -ScriptBlock {
        [pscustomobject]@{
            Check = "Ping LON-DC1"
            Target = "LON-DC1"
            Status = Get-Status -Passed (Test-Connection LON-DC1 -Count 2 -Quiet)
            Details = "Tests basic network connectivity to the domain controller."
        }
    }
    Invoke-LabCheck -FallbackMessage "Unable to test WinRM connectivity to LON-SVR1." -ScriptBlock {
        $result = Test-NetConnection LON-SVR1 -Port 5985 -WarningAction SilentlyContinue
        [pscustomobject]@{
            Check = "WinRM port on LON-SVR1"
            Target = "LON-SVR1:5985"
            Status = Get-Status -Passed ([bool]$result.TcpTestSucceeded)
            Details = "Tests whether the WinRM listener is reachable on this server."
        }
    }
    Invoke-LabCheck -FallbackMessage "Unable to test WinRM connectivity to LON-SVR2." -ScriptBlock {
        $result = Test-NetConnection LON-SVR2 -Port 5985 -WarningAction SilentlyContinue
        [pscustomobject]@{
            Check = "WinRM port on LON-SVR2"
            Target = "LON-SVR2:5985"
            Status = Get-Status -Passed ([bool]$result.TcpTestSucceeded)
            Details = "Tests whether the second lab server is reachable for remote management."
        }
    }
)

$w32tmStatusText = Invoke-LabCheck -FallbackMessage "Unable to query time status." -ScriptBlock {
    (w32tm /query /status) -join [Environment]::NewLine
}

$w32tmConfigText = Invoke-LabCheck -FallbackMessage "Unable to query time configuration." -ScriptBlock {
    (w32tm /query /configuration) -join [Environment]::NewLine
}

$timeZone = Invoke-LabCheck -FallbackMessage "Unable to read time zone." -ScriptBlock {
    Get-TimeZone | Select-Object Id, DisplayName, StandardName
}

$hotFixes = Invoke-LabCheck -FallbackMessage "Unable to read installed hotfixes." -ScriptBlock {
    Get-HotFix |
        Sort-Object InstalledOn -Descending |
        Select-Object -First 10 HotFixID, Description, InstalledOn
}

$winRmService = Invoke-LabCheck -FallbackMessage "Unable to read WinRM service state." -ScriptBlock {
    Get-Service WinRM | Select-Object Name, DisplayName, Status, StartType
}

$winRmRules = Invoke-LabCheck -FallbackMessage "Unable to read WinRM firewall rules." -ScriptBlock {
    Get-NetFirewallRule -DisplayGroup "Windows Remote Management" |
        Select-Object DisplayName, Enabled, Direction, Action, Profile
}

$firewallProfiles = Invoke-LabCheck -FallbackMessage "Unable to read firewall profiles." -ScriptBlock {
    Get-NetFirewallProfile -PolicyStore ActiveStore |
        Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction
}

$installedFeatures = Invoke-LabCheck -FallbackMessage "Unable to read installed Windows features." -ScriptBlock {
    Get-WindowsFeature |
        Where-Object Installed |
        Select-Object Name, DisplayName, InstallState
}

$webServerFeature = Invoke-LabCheck -FallbackMessage "Unable to read Web Server feature state." -ScriptBlock {
    Get-WindowsFeature -Name Web-Server | Select-Object Name, DisplayName, InstallState
}

$remoteRegistry = Invoke-LabCheck -FallbackMessage "Unable to read Remote Registry service state." -ScriptBlock {
    Get-Service RemoteRegistry | Select-Object Name, DisplayName, Status, StartType
}

$netAccountsText = Invoke-LabCheck -FallbackMessage "Unable to read account policy with net accounts." -ScriptBlock {
    (net accounts) -join [Environment]::NewLine
}

$gpResultText = Invoke-LabCheck -FallbackMessage "Unable to read computer Group Policy result." -ScriptBlock {
    (gpresult /scope computer /r) -join [Environment]::NewLine
}

$tpmInfo = Invoke-LabCheck -FallbackMessage "Unable to read TPM state." -ScriptBlock {
    Get-Tpm | Select-Object TpmPresent, TpmReady, TpmEnabled, TpmActivated, ManufacturerIdTxt, ManagedAuthLevel
}

$secureBootInfo = Invoke-LabCheck -FallbackMessage "Unable to read Secure Boot state." -ScriptBlock {
    try {
        [pscustomobject]@{
            Check = "Secure Boot"
            Status = if (Confirm-SecureBootUEFI -ErrorAction Stop) { "Enabled" } else { "Disabled" }
            Details = "Result returned by Confirm-SecureBootUEFI."
        }
    }
    catch {
        [pscustomobject]@{
            Check = "Secure Boot"
            Status = "Review"
            Details = $_.Exception.Message
        }
    }
}

$deviceGuardInfo = Invoke-LabCheck -FallbackMessage "Unable to read Device Guard or VBS state." -ScriptBlock {
    Get-CimInstance -Namespace root\Microsoft\Windows\DeviceGuard -ClassName Win32_DeviceGuard |
        Select-Object VirtualizationBasedSecurityStatus, SecurityServicesConfigured, SecurityServicesRunning
}

$recentSystemEvents = Invoke-LabCheck -FallbackMessage "Unable to read recent System events." -ScriptBlock {
    Get-WinEvent -LogName System -MaxEvents 20 |
        Select-Object TimeCreated, ProviderName, Id, LevelDisplayName
}

$recentSecurityEvents = Invoke-LabCheck -FallbackMessage "Unable to read recent Security events." -ScriptBlock {
    Get-WinEvent -LogName Security -MaxEvents 20 |
        Select-Object TimeCreated, ProviderName, Id, LevelDisplayName
}

$summaryChecks = @(
    [pscustomobject]@{
        Area = "Server identity"
        Status = Get-Status -Passed ($computerInfo.CsName -eq $expectedComputerName -and $computerInfo.CsDomain -eq $expectedDomain)
        Evidence = "$($computerInfo.CsName).$($computerInfo.CsDomain)"
    }
    [pscustomobject]@{
        Area = "Network configuration"
        Status = Get-Status -Passed ([bool]$networkConfig)
        Evidence = "IPv4 and DNS settings were collected."
    }
    [pscustomobject]@{
        Area = "DNS resolution"
        Status = Get-Status -Passed ([bool]$dnsDc1)
        Evidence = "LON-DC1.contoso.com resolution was attempted."
    }
    [pscustomobject]@{
        Area = "Firewall profiles"
        Status = Get-Status -Passed (-not ($firewallProfiles | Where-Object { $_.Enabled -ne $true }))
        Evidence = "Domain, Private, and Public profile states were collected."
    }
    [pscustomobject]@{
        Area = "WinRM"
        Status = Get-Status -Passed ($winRmService.Status -eq "Running")
        Evidence = "WinRM service and firewall rules were collected."
    }
    [pscustomobject]@{
        Area = "Remote Registry"
        Status = Get-Status -Passed ($remoteRegistry.StartType -eq "Disabled")
        Evidence = "Remote Registry StartType is $($remoteRegistry.StartType)."
    }
    [pscustomobject]@{
        Area = "Web Server role"
        Status = Get-Status -Passed ($webServerFeature.InstallState -eq "Installed")
        Evidence = "Web-Server InstallState is $($webServerFeature.InstallState)."
    }
    [pscustomobject]@{
        Area = "Platform protection"
        Status = "Review"
        Evidence = "TPM, Secure Boot, and VBS evidence was collected for interpretation."
    }
)

$style = @"
<style>
body {
    background: #f6f8fb;
    color: #172033;
    font-family: "Segoe UI", Arial, sans-serif;
    margin: 0;
    padding: 0 0 40px 0;
}
header {
    background: #17324d;
    color: #ffffff;
    padding: 28px 36px;
}
h1 {
    margin: 0 0 6px 0;
    font-size: 28px;
    font-weight: 600;
}
h2 {
    color: #17324d;
    font-size: 20px;
    margin: 0 0 14px 0;
}
p {
    margin: 4px 0;
}
section {
    background: #ffffff;
    border: 1px solid #d8e0ea;
    border-radius: 6px;
    margin: 22px 36px;
    padding: 20px;
}
table {
    border-collapse: collapse;
    width: 100%;
    font-size: 13px;
}
th {
    background: #e9eef5;
    color: #172033;
    text-align: left;
}
th, td {
    border: 1px solid #d8e0ea;
    padding: 8px 10px;
    vertical-align: top;
}
tr:nth-child(even) {
    background: #f9fbfd;
}
pre {
    background: #0f1724;
    color: #e6edf5;
    overflow-x: auto;
    padding: 14px;
    border-radius: 6px;
    font-size: 12px;
}
.meta {
    color: #dce8f4;
}
</style>
"@

$body = New-Object System.Collections.Generic.List[string]
$body.Add("<header>")
$body.Add("<h1>Lab 6 Post-Installation Validation Report</h1>")
$body.Add("<p class='meta'>Computer: $env:COMPUTERNAME</p>")
$body.Add("<p class='meta'>Generated: $($reportTime.ToString("yyyy-MM-dd HH:mm:ss"))</p>")
$body.Add("</header>")
$body.Add((ConvertTo-ReportFragment -Title "Summary" -InputObject $summaryChecks))
$body.Add((ConvertTo-ReportFragment -Title "Server Identity and Installation Option" -InputObject $identityChecks))
$body.Add((ConvertTo-ReportFragment -Title "Computer Information" -InputObject $computerInfo))
$body.Add((ConvertTo-ReportFragment -Title "Network Configuration" -InputObject $networkConfig))
$body.Add((ConvertTo-ReportFragment -Title "DNS: LON-DC1" -InputObject $dnsDc1))
$body.Add((ConvertTo-ReportFragment -Title "DNS: LON-SVR2" -InputObject $dnsSrv2))
$body.Add((ConvertTo-ReportFragment -Title "Connectivity Checks" -InputObject $connectionChecks))
$body.Add((ConvertTo-ReportFragment -Title "Time Zone" -InputObject $timeZone))
$body.Add((ConvertTo-ReportFragment -Title "Time Synchronization Status" -PreformattedText $w32tmStatusText))
$body.Add((ConvertTo-ReportFragment -Title "Time Synchronization Configuration" -PreformattedText $w32tmConfigText))
$body.Add((ConvertTo-ReportFragment -Title "Recent Installed Updates" -InputObject $hotFixes))
$body.Add((ConvertTo-ReportFragment -Title "WinRM Service" -InputObject $winRmService))
$body.Add((ConvertTo-ReportFragment -Title "WinRM Firewall Rules" -InputObject $winRmRules))
$body.Add((ConvertTo-ReportFragment -Title "Firewall Profiles" -InputObject $firewallProfiles))
$body.Add((ConvertTo-ReportFragment -Title "Web Server Feature" -InputObject $webServerFeature))
$body.Add((ConvertTo-ReportFragment -Title "Installed Roles and Features" -InputObject $installedFeatures))
$body.Add((ConvertTo-ReportFragment -Title "Remote Registry Service" -InputObject $remoteRegistry))
$body.Add((ConvertTo-ReportFragment -Title "Account Policy" -PreformattedText $netAccountsText))
$body.Add((ConvertTo-ReportFragment -Title "Computer Group Policy Result" -PreformattedText $gpResultText))
$body.Add((ConvertTo-ReportFragment -Title "TPM State" -InputObject $tpmInfo))
$body.Add((ConvertTo-ReportFragment -Title "Secure Boot State" -InputObject $secureBootInfo))
$body.Add((ConvertTo-ReportFragment -Title "Virtualization-Based Security" -InputObject $deviceGuardInfo))
$body.Add((ConvertTo-ReportFragment -Title "Recent System Events" -InputObject $recentSystemEvents))
$body.Add((ConvertTo-ReportFragment -Title "Recent Security Events" -InputObject $recentSecurityEvents))

$reportHtml = ConvertTo-Html -Title "Lab 6 Post-Installation Validation Report" -Head $style -Body ($body -join [Environment]::NewLine)
Set-Content -Path $ReportPath -Value $reportHtml -Encoding UTF8

Write-Host "Lab 6 validation report created:"
Write-Host $ReportPath
