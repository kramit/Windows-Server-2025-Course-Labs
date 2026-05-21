param(
    [string]$OutputFolder = "C:\LabOutput",
    [switch]$Preview
)

$ErrorActionPreference = "Stop"

$packageId = "JanDeDobbeleer.OhMyPosh"
$themeSource = Join-Path -Path $PSScriptRoot -ChildPath "Lab4-GitBranch.omp.json"
$themeDestination = Join-Path -Path $OutputFolder -ChildPath "Lab4-GitBranch.omp.json"
$profileLine = "oh-my-posh init pwsh --config '$themeDestination' | Invoke-Expression"

if ($Preview) {
    [pscustomobject]@{
        PackageId = $packageId
        ThemeSource = $themeSource
        ThemeDestination = $themeDestination
        ProfilePath = $PROFILE
        ProfileLine = $profileLine
    }
    return
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget is not available. Ask your instructor for the approved Oh My Posh installer."
}

if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    winget install $packageId --source winget --accept-package-agreements --accept-source-agreements
}

New-Item -Path $OutputFolder -ItemType Directory -Force | Out-Null

$themeSourceFullPath = [System.IO.Path]::GetFullPath($themeSource)
$themeDestinationFullPath = [System.IO.Path]::GetFullPath($themeDestination)
if ($themeSourceFullPath -ne $themeDestinationFullPath) {
    Copy-Item -Path $themeSource -Destination $themeDestination -Force
}

if (-not (Test-Path -Path $PROFILE)) {
    New-Item -Path $PROFILE -ItemType File -Force | Out-Null
}

$profileContent = Get-Content -Path $PROFILE -Raw -ErrorAction SilentlyContinue
if ($profileContent -notlike "*$profileLine*") {
    Add-Content -Path $PROFILE -Value ""
    Add-Content -Path $PROFILE -Value "# Lab 4 Oh My Posh prompt"
    Add-Content -Path $PROFILE -Value $profileLine
}

Write-Host "Oh My Posh profile configuration was added to $PROFILE"
Write-Host "Open a new PowerShell tab or run: . `$PROFILE"
