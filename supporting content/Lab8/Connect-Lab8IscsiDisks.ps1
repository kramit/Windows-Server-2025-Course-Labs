#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [string]$TargetPortalAddress = "LON-SRV2.contoso.com",
    [string]$TargetNameHint = "Lab8-StoragePool-Target"
)

$ErrorActionPreference = "Stop"

if ($env:COMPUTERNAME -ne "LON-SRV1") {
    Write-Warning "This script is intended to run on LON-SRV1. Current computer: $env:COMPUTERNAME"
}

Write-Host "Starting and configuring the Microsoft iSCSI Initiator Service..."
Set-Service -Name MSiSCSI -StartupType Automatic
Start-Service -Name MSiSCSI

$existingPortal = Get-IscsiTargetPortal -ErrorAction SilentlyContinue |
    Where-Object { $_.TargetPortalAddress -eq $TargetPortalAddress }

if ($null -eq $existingPortal) {
    Write-Host "Adding iSCSI target portal $TargetPortalAddress..."
    New-IscsiTargetPortal -TargetPortalAddress $TargetPortalAddress | Out-Null
}
else {
    Write-Host "iSCSI target portal already exists: $TargetPortalAddress"
}

Start-Sleep -Seconds 2

$targets = @(
    Get-IscsiTarget |
        Where-Object { $_.NodeAddress -like "*$TargetNameHint*" }
)

if ($targets.Count -eq 0) {
    $targets = @(
        Get-IscsiTarget |
            Where-Object { -not $_.IsConnected }
    )
}

if ($targets.Count -eq 0) {
    throw "No available iSCSI targets were discovered from $TargetPortalAddress. Confirm that the target script completed on LON-SRV2."
}

foreach ($target in $targets) {
    if (-not $target.IsConnected) {
        Write-Host "Connecting to $($target.NodeAddress)..."
        Connect-IscsiTarget -NodeAddress $target.NodeAddress -IsPersistent $true | Out-Null
    }
    else {
        Write-Host "Already connected to $($target.NodeAddress)"
    }
}

Update-HostStorageCache

Write-Host ""
Write-Host "Connected iSCSI targets:"
Get-IscsiTarget | Select-Object IsConnected, NodeAddress | Format-Table -AutoSize

Write-Host ""
Write-Host "iSCSI disks visible to Windows:"
Get-Disk |
    Where-Object { $_.BusType -eq "iSCSI" } |
    Select-Object Number,
        FriendlyName,
        BusType,
        @{Name = "SizeGB"; Expression = { [math]::Round($_.Size / 1GB, 2) }},
        OperationalStatus,
        PartitionStyle,
        IsOffline |
    Format-Table -AutoSize
