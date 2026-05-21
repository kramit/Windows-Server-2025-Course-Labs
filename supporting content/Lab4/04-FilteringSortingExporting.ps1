param(
    [string]$OutputFolder = "C:\LabOutput"
)

New-Item -Path $OutputFolder -ItemType Directory -Force | Out-Null

Get-Service -ErrorAction SilentlyContinue |
    Where-Object { $_.Status -eq "Running" } |
    Select-Object Name, DisplayName, Status |
    Format-Table -AutoSize

Get-Service -Name Dnscache -ErrorAction SilentlyContinue |
    Select-Object Name, DisplayName, Status, StartType

Get-Process |
    Sort-Object WorkingSet -Descending |
    Select-Object -First 5 Name, Id, @{Name = "MemoryMB"; Expression = { [math]::Round($_.WorkingSet / 1MB, 2) }} |
    Format-Table -AutoSize

$runningServicesPath = Join-Path -Path $OutputFolder -ChildPath "RunningServices.csv"

Get-Service -ErrorAction SilentlyContinue |
    Where-Object { $_.Status -eq "Running" } |
    Select-Object Name, DisplayName, Status |
    Export-Csv -Path $runningServicesPath -NoTypeInformation

Test-Path $runningServicesPath
