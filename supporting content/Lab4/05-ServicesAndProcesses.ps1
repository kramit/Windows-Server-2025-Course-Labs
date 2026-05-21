Get-Service -ErrorAction SilentlyContinue |
    Where-Object { $_.Status -eq "Stopped" } |
    Select-Object Name, DisplayName, StartType |
    Format-Table -AutoSize

Get-Process |
    Select-Object -First 15 Name, Id, Handles, CPU, WorkingSet |
    Format-Table -AutoSize

Get-Process |
    Where-Object { $_.Name -like "*powershell*" -or $_.Name -like "*pwsh*" -or $_.Name -like "*terminal*" } |
    Select-Object Name, Id, StartTime
