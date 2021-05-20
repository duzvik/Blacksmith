# iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/duzvik/Blacksmith/master/resources/scripts/powershell/duzvik/Set-NXLog.ps1"))

#install sysmon
Resolve-DnsName raw.githubusercontent.com
Resolve-DnsName nxlog.co

iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/OTRF/Blacksmith/ee0f5b8eecdb87092c4f36e30cce49db3063fef2/resources/scripts/powershell/endpoint-software/Install-Sysmon.ps1"))

#install nxlog
mkdir C:\snarelogs\

write-host "[+] Processing NXLoog Installation.."

$ConfigUrl = "https://raw.githubusercontent.com/duzvik/Blacksmith/master/resources/configs/duzvik/nxlog.conf"
$URL = "https://nxlog.co/system/files/products/files/348/nxlog-ce-2.10.2150.msi"


$OutputFile = Split-Path $Url -leaf
$File = "C:\ProgramData\$OutputFile"

# Download NXNLog
write-Host "[+] Downloading $OutputFile .."
$wc = new-object System.Net.WebClient
$wc.DownloadFile($Url, $File)
if (!(Test-Path $File)) { Write-Error "File $File does not exist" -ErrorAction Stop }
 
# Installing NXLog
write-Host "[+] Installing NXLog.."
&  msiexec /i $File /quiet
Start-Sleep -s 15

# Download nxlog Config
write-Host "waiting for nxlog folder to exist .."
while (!(Test-Path "C:\Program Files (x86)\nxlog")) { Start-Sleep 5 }

# Renaming File
write-Host "Renaming original nxlog config .."
while (!(Test-Path "C:\Program Files (x86)\nxlog\conf\nxlog.conf")) { Start-Sleep 5 }
Rename-Item "C:\Program Files (x86)\nxlog\conf\nxlog.conf" "C:\Program Files (x86)\nxlog\conf\nxlog.backup.conf" -Force

$shipperConfig = "C:\Program Files (x86)\nxlog\conf\nxlog.conf"

# Download shipper config
write-Host "Downloading shipper config.."
$wc.DownloadFile($ConfigUrl, $shipperConfig)
if (!(Test-Path $shipperConfig)){ Write-Error "File $shipperConfig does not exist" -ErrorAction Stop }

# Updating Config IP
#((Get-Content -path $shipperConfig -Raw) -replace 'IPADDRESS',$DestinationIP) | Set-Content -Path $shipperConfig


write-Host "[+] Restarting Log Services .."
$LogServices = @("nxlog")

# Restarting Log Services
foreach ($LogService in $LogServices)
{
    write-Host "[+] Restarting $LogService .."
    Restart-Service -Name $LogService -Force

    write-Host "  [*] Verifying if $LogService is running.."
    $s = Get-Service -Name $LogService
    while ($s.Status -ne 'Running') { Start-Service $LogService; Start-Sleep 3 }
    Start-Sleep 5
    write-Host "  [*] $LogService is running.."
} 
 
