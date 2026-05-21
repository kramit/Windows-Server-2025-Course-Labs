#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [string]$VirtualDiskFolder = "C:\Lab8-iSCSI",
    [string]$TargetName = "Lab8-StoragePool-Target",
    [string]$InitiatorDnsName = "LON-SRV1.contoso.com",
    [int]$DiskCount = 3,
    [uint64]$DiskSizeBytes = 20GB
)

$ErrorActionPreference = "Stop"

if ($env:COMPUTERNAME -ne "LON-SRV2") {
    Write-Warning "This script is intended to run on LON-SRV2. Current computer: $env:COMPUTERNAME"
}

Write-Host "Installing the iSCSI Target Server role service if required..."
$targetFeature = Get-WindowsFeature -Name FS-iSCSITarget-Server
if (-not $targetFeature.Installed) {
    Install-WindowsFeature -Name FS-iSCSITarget-Server -IncludeManagementTools | Out-Null
}

Write-Host "Creating the virtual disk folder at $VirtualDiskFolder..."
New-Item -Path $VirtualDiskFolder -ItemType Directory -Force | Out-Null

$initiatorIds = New-Object System.Collections.Generic.List[string]
$initiatorIds.Add("DNSName:$InitiatorDnsName")
$initiatorIds.Add("DNSName:LON-SRV1")

try {
    Resolve-DnsName -Name $InitiatorDnsName -Type A |
        Where-Object { $_.IPAddress } |
        ForEach-Object { $initiatorIds.Add("IPAddress:$($_.IPAddress)") }
}
catch {
    Write-Warning "Could not resolve $InitiatorDnsName to an IPv4 address. The target will use DNS initiator IDs only."
}

$initiatorIds = @($initiatorIds | Select-Object -Unique)

Write-Host "Creating or updating the iSCSI target $TargetName for LON-SRV1..."
$target = Get-IscsiServerTarget -TargetName $TargetName -ErrorAction SilentlyContinue
if ($null -eq $target) {
    New-IscsiServerTarget -TargetName $TargetName -InitiatorId $initiatorIds | Out-Null
}
else {
    Set-IscsiServerTarget -TargetName $TargetName -InitiatorId $initiatorIds -Enable $true | Out-Null
}

for ($diskNumber = 1; $diskNumber -le $DiskCount; $diskNumber++) {
    $diskName = "Lab8Disk{0:D2}.vhdx" -f $diskNumber
    $diskPath = Join-Path -Path $VirtualDiskFolder -ChildPath $diskName

    $virtualDisk = Get-IscsiVirtualDisk -Path $diskPath -ErrorAction SilentlyContinue
    if ($null -eq $virtualDisk) {
        Write-Host "Creating dynamic iSCSI virtual disk $diskPath..."
        New-IscsiVirtualDisk -Path $diskPath -Size $DiskSizeBytes | Out-Null
    }
    else {
        Write-Host "Virtual disk already exists: $diskPath"
    }

    $mappedPaths = @(
        Get-IscsiVirtualDisk -TargetName $TargetName -ErrorAction SilentlyContinue |
            Select-Object -ExpandProperty Path
    )

    if ($mappedPaths -notcontains $diskPath) {
        Write-Host "Mapping $diskPath to $TargetName..."
        Add-IscsiVirtualDiskTargetMapping -TargetName $TargetName -Path $diskPath | Out-Null
    }
    else {
        Write-Host "Virtual disk is already mapped to ${TargetName}: $diskPath"
    }
}

Write-Host ""
Write-Host "iSCSI target preparation complete."
Write-Host "Target name: $TargetName"
Write-Host "Allowed initiators:"
$initiatorIds | ForEach-Object { Write-Host " - $_" }
Write-Host ""
Get-IscsiVirtualDisk -TargetName $TargetName |
    Select-Object Path,
        @{Name = "SizeGB"; Expression = { [math]::Round($_.Size / 1GB, 2) }},
        Description |
    Format-Table -AutoSize
