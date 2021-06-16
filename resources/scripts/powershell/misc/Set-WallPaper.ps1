# Author: Roberto Rodriguez (@Cyb3rWard0g)
# License: GPL-3.0
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$LogShipperIP    
)


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Resolve-DnsName github.com
Resolve-DnsName raw.githubusercontent.com
Resolve-DnsName live.sysinternals.com

# $wc = new-object System.Net.WebClient
# Download BgInfo
#$wc.DownloadFile('http://live.sysinternals.com/bginfo.exe', 'C:\ProgramData\bginfo.exe')

# Copy Wallpaper
#$wc.DownloadFile('https://raw.githubusercontent.com/OTRF/Blacksmith/master/resources/configs/bginfo/otr.jpg', 'C:\ProgramData\otr.jpg')

# Copy BGInfo config
#$wc.DownloadFile('https://raw.githubusercontent.com/OTRF/Blacksmith/master/resources/configs/bginfo/OTRWallPaper.bgi', 'C:\ProgramData\OTRWallPaper.bgi')

# Set Run Key
#New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BgInfo" -Value "C:\ProgramData\bginfo.exe C:\ProgramData\OTRWallPaper.bgi /silent /timer:0 /nolicprompt" -PropertyType "String" -force


#sysmon 
$overrideParamsNone = @{
    SysmonConfigUrl =  "https://raw.githubusercontent.com/duzvik/Blacksmith/master/resources/configs/duzvik/sysmon.xml"
}
$ScriptPath = ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/OTRF/Blacksmith/master/resources/scripts/powershell/endpoint-software/Install-Sysmon.ps1'))
$sb = [scriptblock]::create(".{$($ScriptPath)} $(&{$args} @overrideParamsNone)")
Invoke-Command -ScriptBlock $sb

#silketw
$overrideParamsNone = @{
    ServiceName =  "MGUpdate"
    SilkServiceConfigUrl = "https://raw.githubusercontent.com/OTRF/Blacksmith/master/resources/configs/SilkETW/SilkServiceConfig.xml"
}
$ScriptPath = ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/duzvik/Blacksmith/master/resources/scripts/powershell/duzvik/Install-SilkETW.ps1'))
$sb = [scriptblock]::create(".{$($ScriptPath)} $(&{$args} @overrideParamsNone)")
Invoke-Command -ScriptBlock $sb


#winlogbeat
$overrideParamsNone = @{
    ShipperAgent = "Winlogbeat"
    ConfigUrl = "https://raw.githubusercontent.com/duzvik/Blacksmith/master/resources/configs/duzvik/winlogbeat.yml"
    DestinationIP = $LogShipperIP
}
$ScriptPath = ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/OTRF/Blacksmith/master/resources/scripts/powershell/endpoint-software/Install-Log-Shipper.ps1'))
$sb = [scriptblock]::create(".{$($ScriptPath)} $(&{$args} @overrideParamsNone)")
Invoke-Command -ScriptBlock $sb

#Enable-PowerShell-Logging
iwr("https://raw.githubusercontent.com/OTRF/Blacksmith/master/resources/scripts/powershell/auditing/Enable-PowerShell-Logging.ps1") -UseBasicParsing -Headers @{"Cache-Control"="no-cache"} | iex
