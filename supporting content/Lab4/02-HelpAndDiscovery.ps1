Get-Help Get-ChildItem

Get-Help Get-ChildItem -Examples

Get-Command -Verb Get |
    Select-Object -First 20 Name, Source

Get-Command -Noun Service

Get-Alias |
    Select-Object Name, Definition |
    Sort-Object Name |
    Format-Table -AutoSize
