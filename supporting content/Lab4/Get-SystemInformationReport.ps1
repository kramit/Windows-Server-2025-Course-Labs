param(
    [string]$OutputPath = "C:\LabOutput\SystemInformationReport.html"
)

$ErrorActionPreference = "Stop"

$outputFolder = Split-Path -Path $OutputPath -Parent
if (-not (Test-Path -Path $outputFolder)) {
    New-Item -Path $outputFolder -ItemType Directory -Force | Out-Null
}

$computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
$operatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem
$processor = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1
$bios = Get-CimInstance -ClassName Win32_BIOS

$computerSummary = [pscustomobject]@{
    ComputerName = $env:COMPUTERNAME
    Domain = $computerSystem.Domain
    Manufacturer = $computerSystem.Manufacturer
    Model = $computerSystem.Model
    Processor = $processor.Name
    TotalMemoryGB = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
    BIOSSerialNumber = $bios.SerialNumber
}

$osSummary = [pscustomobject]@{
    Caption = $operatingSystem.Caption
    Version = $operatingSystem.Version
    BuildNumber = $operatingSystem.BuildNumber
    InstallDate = $operatingSystem.InstallDate
    LastBootUpTime = $operatingSystem.LastBootUpTime
    FreePhysicalMemoryGB = [math]::Round($operatingSystem.FreePhysicalMemory / 1MB, 2)
}

$networkConfiguration = Get-NetIPConfiguration |
    Select-Object InterfaceAlias,
        @{Name = "IPv4Address"; Expression = { ($_.IPv4Address.IPAddress -join ", ") }},
        @{Name = "IPv4DefaultGateway"; Expression = { ($_.IPv4DefaultGateway.NextHop -join ", ") }},
        @{Name = "DNSServer"; Expression = { ($_.DNSServer.ServerAddresses -join ", ") }}

$diskVolumes = Get-Volume |
    Where-Object { $_.DriveLetter } |
    Select-Object DriveLetter, FileSystemLabel, FileSystem, HealthStatus,
        @{Name = "SizeGB"; Expression = { [math]::Round($_.Size / 1GB, 2) }},
        @{Name = "SizeRemainingGB"; Expression = { [math]::Round($_.SizeRemaining / 1GB, 2) }}

$runningServices = Get-Service -ErrorAction SilentlyContinue |
    Where-Object { $_.Status -eq "Running" } |
    Select-Object -First 20 Name, DisplayName, Status

$recentHotfixes = Get-HotFix |
    Sort-Object InstalledOn -Descending |
    Select-Object -First 10 HotFixID, Description, InstalledOn

$style = @"
<style>
body {
    font-family: Segoe UI, Arial, sans-serif;
    margin: 32px;
    color: #1f2933;
}
h1 {
    color: #0f4c81;
}
h2 {
    border-bottom: 2px solid #d8dee9;
    padding-bottom: 4px;
}
table {
    border-collapse: collapse;
    width: 100%;
    margin-bottom: 24px;
}
th, td {
    border: 1px solid #c8d1dc;
    padding: 8px;
    text-align: left;
}
th {
    background-color: #e8f1fb;
}
</style>
"@

$sections = @()
$sections += "<h1>System Information Report - $env:COMPUTERNAME</h1>"
$sections += "<p>Generated: $(Get-Date)</p>"
$sections += $computerSummary | ConvertTo-Html -Fragment -PreContent "<h2>Computer Summary</h2>"
$sections += $osSummary | ConvertTo-Html -Fragment -PreContent "<h2>Operating System</h2>"
$sections += $networkConfiguration | ConvertTo-Html -Fragment -PreContent "<h2>Network Configuration</h2>"
$sections += $diskVolumes | ConvertTo-Html -Fragment -PreContent "<h2>Disk Volumes</h2>"
$sections += $runningServices | ConvertTo-Html -Fragment -PreContent "<h2>Running Services</h2>"
$sections += $recentHotfixes | ConvertTo-Html -Fragment -PreContent "<h2>Recent Hotfixes</h2>"

ConvertTo-Html -Title "System Information Report" -Head $style -Body ($sections -join "`n") |
    Out-File -FilePath $OutputPath -Encoding utf8

Write-Host "System information report created at $OutputPath"
