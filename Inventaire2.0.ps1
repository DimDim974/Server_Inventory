$SRV = read-host "Enter the server, please"
$user = read-host "Enter the user, please"
$doamin = read-host "Enter the domain, please"
$USER_Domain=$doamin+"\"+$user

$s = New-PSSession -ComputerName $SRV -Credential $USER_Domain

# Enter-PSSession -Session $s

Invoke-Command -Session $s {

$Folder = [System.Net.Dns]::GetHostName()
;$UserBest = "C:\Users\"+ $env:username +"\Desktop\"
;$Folder = $UserBest+"\"+$Folder
;mkdir $Folder
;$Emplacement = $Folder+"\"
;$EmplaceShare = $Emplacement+ "Share.csv"
;$EmplacementApp = $Emplacement+"App.csv"
;$EmplacementService= $Emplacement+"Services.csv"
;$EmplacementIP= $Emplacement+"IPAddresse.txt"
;$EmplacementFonctionnalite = $Emplacement+ "Fonctionnalites.txt"
;$EmplacementServicesAll = $Emplacement+ "Services_All.csv"
;$EmplacementGPO = $Emplacement+"GPO.csv"
;$EmplacementFW = $Emplacement+"fw-rules.wfw"
;$IPHost=[System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName())
;$EmplacementRegistre = $Emplacement+"Export.reg"
}

Invoke-Command -Session $s -ScriptBlock {$IPHost[0].IPAddressToString}
Invoke-Command -Session $s -ScriptBlock {$IPHost[1].IPAddressToString | Out-File $EmplacementIP}
Invoke-Command -Session $s -ScriptBlock {Get-WmiObject -Class Win32_Product -Property * | Select-Object Name, Vendor, Version | Export-Csv -Path $EmplacementApp -Delimiter ";" -Encoding UTF8}
Invoke-Command -Session $s -ScriptBlock {Get-WmiObject Win32_Share | select-object Caption, Name, Path | Export-Csv -Path $EmplaceShare -Delimiter ";" -Encoding UTF8}
Invoke-Command -Session $s -ScriptBlock {Get-Service | Where-Object {$_.Status -eq "Running"}  | Select-Object Name, DisplayName | Export-Csv -Path $EmplacementService -Delimiter ";" -Encoding UTF8}
Invoke-Command -Session $s -ScriptBlock {Get-Service | Export-Csv -Path $EmplacementServicesAll -Delimiter ";" -Encoding UTF8}
Invoke-Command -Session $s -ScriptBlock {ServerManagerCmd.exe -query | Out-File $EmplacementFonctionnalite}
Invoke-Command -Session $s -ScriptBlock {GPResult /R | Out-File $EmplacementGPO}
Invoke-Command -Session $s -ScriptBlock {netsh advfirewall export $EmplacementFW}
Invoke-Command -Session $s -ScriptBlock {Reg export "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Shares" $EmplacementRegistre}

exit