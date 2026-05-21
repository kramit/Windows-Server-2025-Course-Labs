param(
    [switch]$NoShow
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Lab 4 Service Status Viewer"
$form.StartPosition = "CenterScreen"
$form.Size = New-Object System.Drawing.Size(720, 460)

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Service Status Viewer"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point(16, 16)
$form.Controls.Add($titleLabel)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Select Get Services to load the first 20 services."
$statusLabel.AutoSize = $true
$statusLabel.Location = New-Object System.Drawing.Point(18, 55)
$form.Controls.Add($statusLabel)

$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.ReadOnly = $true
$outputBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$outputBox.Location = New-Object System.Drawing.Point(20, 90)
$outputBox.Size = New-Object System.Drawing.Size(660, 260)
$form.Controls.Add($outputBox)

$getServicesButton = New-Object System.Windows.Forms.Button
$getServicesButton.Text = "Get Services"
$getServicesButton.Location = New-Object System.Drawing.Point(20, 365)
$getServicesButton.Size = New-Object System.Drawing.Size(120, 32)
$form.Controls.Add($getServicesButton)

$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "Close"
$closeButton.Location = New-Object System.Drawing.Point(560, 365)
$closeButton.Size = New-Object System.Drawing.Size(120, 32)
$form.Controls.Add($closeButton)

$getServicesButton.Add_Click({
    $services = Get-Service -ErrorAction SilentlyContinue |
        Select-Object -First 20 Name, DisplayName, Status |
        Format-Table -AutoSize |
        Out-String

    $outputBox.Text = $services
    $statusLabel.Text = "Loaded service status at $(Get-Date -Format T)."
})

$closeButton.Add_Click({
    $form.Close()
})

if ($NoShow) {
    [pscustomobject]@{
        FormTitle = $form.Text
        ControlCount = $form.Controls.Count
        Width = $form.Width
        Height = $form.Height
    }
}
else {
    [void]$form.ShowDialog()
}
