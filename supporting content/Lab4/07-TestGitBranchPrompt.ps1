param(
    [string]$OutputFolder = "C:\LabOutput"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is not available. Complete the Git lab or install Git before running this script."
}

$repoPath = Join-Path -Path $OutputFolder -ChildPath "PromptTestRepo"
New-Item -Path $repoPath -ItemType Directory -Force | Out-Null

Push-Location $repoPath
try {
    if (-not (Test-Path -Path ".git")) {
        git init | Out-Null
    }

    $branchExists = git branch --list "feature/lab4-prompt"
    if ($branchExists) {
        git checkout feature/lab4-prompt | Out-Null
    }
    else {
        git checkout -b feature/lab4-prompt | Out-Null
    }

    "Lab 4 prompt test" | Out-File -FilePath .\README.md -Encoding utf8
    git add .\README.md

    [pscustomobject]@{
        RepositoryPath = $repoPath
        CurrentBranch = git branch --show-current
        GitStatus = (git status --short) -join "; "
    }
}
finally {
    Pop-Location
}
