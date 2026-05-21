$ErrorActionPreference = "Stop"

winget --version

winget install --id Microsoft.VisualStudioCode --exact --source winget --accept-package-agreements --accept-source-agreements

if (Get-Command code -ErrorAction SilentlyContinue) {
    code --install-extension ms-vscode.PowerShell
}
else {
    Write-Warning "The code command was not found. Close and reopen PowerShell, then run: code --install-extension ms-vscode.PowerShell"
}
