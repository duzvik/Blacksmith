# iex (New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/duzvik/Blacksmith/master/resources/scripts/powershell/duzvik/Set-NXLog.ps1"); Install-NXLog -DestinationIP 1.1.1.1 -DestinationPort 600 -Sysmon $true -ExecMarker 2021marker 
#iwr("https://raw.githubusercontent.com/duzvik/Blacksmith/master/resources/scripts/powershell/duzvik/Set-NXLog.ps1") -UseBasicParsing -Headers @{"Cache-Control"="no-cache"} | iex; Install-NXLog -DestinationIP 165.232.135.17 -DestinationPort 600 -Sysmon $true -ExecMarker default_marker

function Install-NXLog
{

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$DestinationIP,

        [Parameter(Mandatory=$false)]
        [string]$DestinationPort,

        [Parameter(Mandatory=$false)]
        [bool]$Sysmon = $true,

        [Parameter(Mandatory=$false)]
        [string]$ExecMarker = "marker"
    )


    #install sysmon
    Resolve-DnsName raw.githubusercontent.com
    Resolve-DnsName nxlog.co

    if($Sysmon) {
     #iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/OTRF/Blacksmith/ee0f5b8eecdb87092c4f36e30cce49db3063fef2/resources/scripts/powershell/endpoint-software/Install-Sysmon.ps1")) -SysmonConfigUrl "https://raw.githubusercontent.com/duzvik/Blacksmith/master/resources/configs/duzvik/sysmon.xml"
        $overrideParamsNone = @{
            SysmonConfigUrl =  "https://raw.githubusercontent.com/duzvik/Blacksmith/master/resources/configs/duzvik/sysmon.xml"
        }
        $ScriptPath = ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/OTRF/Blacksmith/ee0f5b8eecdb87092c4f36e30cce49db3063fef2/resources/scripts/powershell/endpoint-software/Install-Sysmon.ps1'))
        $sb = [scriptblock]::create(".{$($ScriptPath)} $(&{$args} @overrideParamsNone)")
        Invoke-Command -ScriptBlock $sb
    }

    ## revert Sysmon Channel Access permissions
    #write-Host "[+] Setting up Channel Access permissions for Microsoft-Windows-Sysmon/Operational "
    #wevtutil set-log Microsoft-Windows-Sysmon/Operational /ca:'O:BAG:SYD:(A;;0xf0005;;;SY)(A;;0x5;;;BA)(A;;0x1;;;S-1-5-32-573)'



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

    # Updating RIN IP
    ((Get-Content -path $shipperConfig -Raw) -replace 'REPLACE_IPADDRESS',$DestinationIP) | Set-Content -Path $shipperConfig
    # Updating RIN IP
    ((Get-Content -path $shipperConfig -Raw) -replace 'REPLACE_PORT',$DestinationPort) | Set-Content -Path $shipperConfig
    # Updating RIN Marker
    ((Get-Content -path $shipperConfig -Raw) -replace 'REPLACE_MARKER',$ExecMarker) | Set-Content -Path $shipperConfig

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
}
