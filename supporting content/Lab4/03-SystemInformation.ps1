Get-ComputerInfo -Property CsComputerName, CsDomain, OsVersion, OsProductType

Get-CimInstance Win32_OperatingSystem |
    Select-Object Caption, Version, BuildNumber, InstallDate

Get-HotFix |
    Sort-Object InstalledOn -Descending |
    Select-Object -First 10 HotFixID, Description, InstalledOn |
    Format-Table -AutoSize

Get-NetIPAddress -AddressFamily IPv4 |
    Select-Object InterfaceAlias, IPAddress, PrefixLength |
    Format-Table -AutoSize
