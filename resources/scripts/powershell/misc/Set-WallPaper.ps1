# Author: Roberto Rodriguez (@Cyb3rWard0g)
# License: GPL-3.0

# [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

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


#winlogbeat
$overrideParamsNone = @{
    ShipperAgent = "Winlogbeat"
    ConfigUrl = "https://gist.githubusercontent.com/duzvik/61337e46e56112d5ee463405eae71e33/raw/d13a71ef244a88336bf0dab2cd484200d388b54f/winlogbeat.yml"
    DestinationIP = "18.207.99.1"
}
$ScriptPath = ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/OTRF/Blacksmith/ee0f5b8eecdb87092c4f36e30cce49db3063fef2/resources/scripts/powershell/endpoint-software/Install-Log-Shipper.ps1'))
$sb = [scriptblock]::create(".{$($ScriptPath)} $(&{$args} @overrideParamsNone)")
Invoke-Command -ScriptBlock $sb

#Enable-PowerShell-Logging
iwr("https://raw.githubusercontent.com/OTRF/Blacksmith/ee0f5b8eecdb87092c4f36e30cce49db3063fef2/resources/scripts/powershell/auditing/Enable-PowerShell-Logging.ps1") -UseBasicParsing -Headers @{"Cache-Control"="no-cache"} | iex

