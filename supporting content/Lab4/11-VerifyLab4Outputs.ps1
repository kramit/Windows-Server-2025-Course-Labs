param(
    [string]$OutputFolder = "C:\LabOutput"
)

$checks = @(
    [pscustomobject]@{
        Name = "Running services CSV"
        Path = Join-Path -Path $OutputFolder -ChildPath "RunningServices.csv"
    },
    [pscustomobject]@{
        Name = "System information HTML report"
        Path = Join-Path -Path $OutputFolder -ChildPath "SystemInformationReport.html"
    },
    [pscustomobject]@{
        Name = "Service status CSV"
        Path = Join-Path -Path $OutputFolder -ChildPath "ServiceStatus.csv"
    },
    [pscustomobject]@{
        Name = "Service status XML"
        Path = Join-Path -Path $OutputFolder -ChildPath "ServiceStatus.xml"
    },
    [pscustomobject]@{
        Name = "Service status JSON"
        Path = Join-Path -Path $OutputFolder -ChildPath "ServiceStatus.json"
    },
    [pscustomobject]@{
        Name = "Service status HTML"
        Path = Join-Path -Path $OutputFolder -ChildPath "ServiceStatus.html"
    }
)

$checks |
    Select-Object Name, Path, @{Name = "Exists"; Expression = { Test-Path -Path $_.Path }}

$repoPath = Join-Path -Path $OutputFolder -ChildPath "PromptTestRepo"
if (Test-Path -Path $repoPath) {
    Push-Location $repoPath
    try {
        [pscustomobject]@{
            RepositoryPath = $repoPath
            CurrentBranch = git branch --show-current
        }
    }
    finally {
        Pop-Location
    }
}
