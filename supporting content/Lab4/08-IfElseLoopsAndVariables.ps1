param(
    [int]$DiskWarningPercent = 20
)

$serverName = $env:COMPUTERNAME
$maxServicesToShow = 5
$minimumFreePercent = [double]$DiskWarningPercent
$includeStoppedServices = $true
$today = Get-Date
$serviceNames = @("Dnscache", "EventLog", "Winmgmt")
$serviceFriendlyNames = @{
    Dnscache = "DNS Client"
    EventLog = "Windows Event Log"
    Winmgmt = "Windows Management Instrumentation"
}

$labSummary = [pscustomobject]@{
    ComputerName = $serverName
    Date = $today
    MinimumFreeDiskPercent = $minimumFreePercent
    IncludeStoppedServices = $includeStoppedServices
}

"Variable examples"
$labSummary

"If, elseif, and else example"
$systemDrive = Get-Volume -DriveLetter C -ErrorAction SilentlyContinue
if ($null -eq $systemDrive) {
    "The C drive was not found."
}
elseif ($systemDrive.SizeRemaining -lt 1GB) {
    "The C drive has less than 1 GB free."
}
else {
    $freePercent = [math]::Round(($systemDrive.SizeRemaining / $systemDrive.Size) * 100, 2)
    "The C drive has $freePercent percent free."
}

"foreach loop example"
foreach ($serviceName in $serviceNames) {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service) {
        [pscustomobject]@{
            Name = $service.Name
            DisplayName = $serviceFriendlyNames[$service.Name]
            Status = $service.Status
        }
    }
}

"for loop example"
for ($counter = 1; $counter -le $maxServicesToShow; $counter++) {
    "Service row $counter"
}

"while loop example"
$attempt = 1
while ($attempt -le 3) {
    "Health check attempt $attempt"
    $attempt++
}

"do while loop example"
$number = 1
do {
    "Processing item $number"
    $number++
} while ($number -le 3)
