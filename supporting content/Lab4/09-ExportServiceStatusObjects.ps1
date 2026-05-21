param(
    [string]$OutputFolder = "C:\LabOutput"
)

$ErrorActionPreference = "Stop"

New-Item -Path $OutputFolder -ItemType Directory -Force | Out-Null

$serviceStatus = Get-Service -ErrorAction SilentlyContinue |
    Select-Object Name, DisplayName, Status, StartType

$csvPath = Join-Path -Path $OutputFolder -ChildPath "ServiceStatus.csv"
$xmlPath = Join-Path -Path $OutputFolder -ChildPath "ServiceStatus.xml"
$jsonPath = Join-Path -Path $OutputFolder -ChildPath "ServiceStatus.json"
$htmlPath = Join-Path -Path $OutputFolder -ChildPath "ServiceStatus.html"

$serviceStatus | Export-Csv -Path $csvPath -NoTypeInformation
$serviceStatus | Export-Clixml -Path $xmlPath
$serviceStatus | ConvertTo-Json -Depth 3 | Out-File -FilePath $jsonPath -Encoding utf8
$serviceStatus | ConvertTo-Html -Title "Service Status" -PreContent "<h1>Service Status</h1>" |
    Out-File -FilePath $htmlPath -Encoding utf8

[pscustomobject]@{
    Csv = $csvPath
    Xml = $xmlPath
    Json = $jsonPath
    Html = $htmlPath
}
