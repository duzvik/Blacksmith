# iex (New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/duzvik/Blacksmith/master/resources/scripts/powershell/duzvik/Set-NXLog.ps1"); Install-NXLog -DestinationIP 1.1.1.1 -DestinationPort 600 -Sysmon $true -ExecMarker 2021marker 


function Install-Set-HybridConnectionManager
{

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ConnectionString,
    )


    #install sysmon
    Resolve-DnsName raw.githubusercontent.com
    Resolve-DnsName storage1duzvik.blob.core.windows.net
    write-host "[+] Processing HybridConnectionManager Installation.."

    $ConfigUrl = "https://raw.githubusercontent.com/duzvik/Blacksmith/master/resources/configs/duzvik/Microsoft.HybridConnectionManager.Listener.exe.config"
    $URL = "https://storage1duzvik.blob.core.windows.net/hybridconnectionmanager/HybridConnectionManager.msi"

    $OutputFile = Split-Path $Url -leaf
    $File = "C:\ProgramData\$OutputFile"

    # Download HybridConnectionManager
    write-Host "[+] Downloading $OutputFile .."
    $wc = new-object System.Net.WebClient
    $wc.DownloadFile($Url, $File)
    if (!(Test-Path $File)) { Write-Error "File $File does not exist" -ErrorAction Stop }

    # Installing HybridConnectionManager
    write-Host "[+] Installing NXLog.."
    &  msiexec /i $File /quiet
    Start-Sleep -s 15

    # Download HybridConnectionManager Config
    write-Host "waiting for nxlog folder to exist .."
    while (!(Test-Path "C:\Program Files\Microsoft\HybridConnectionManager 0.7")) { Start-Sleep 5 }

    # Renaming HybridConnectionManager Config
    write-Host "Renaming original nxlog config .."
    while (!(Test-Path "C:\Program Files\Microsoft\HybridConnectionManager 0.7\Microsoft.HybridConnectionManager.Listener.exe.config")) { Start-Sleep 5 }
    Rename-Item "C:\Program Files\Microsoft\HybridConnectionManager 0.7\Microsoft.HybridConnectionManager.Listener.exe.config" "C:\Program Files\Microsoft\HybridConnectionManager 0.7\Microsoft.HybridConnectionManager.Listener.exe.config.backup" -Force

    $config = "C:\Program Files\Microsoft\HybridConnectionManager 0.7\Microsoft.HybridConnectionManager.Listener.exe.config"

    # Download HybridConnectionManager config
    write-Host "Downloading HybridConnectionManager config.."
    $wc.DownloadFile($ConfigUrl, $config)
    if (!(Test-Path $config)){ Write-Error "File $config does not exist" -ErrorAction Stop }

    # Updating CONNECTION_STRING
    ((Get-Content -path $config -Raw) -replace 'CONNECTION_STRING',$ConnectionString) | Set-Content -Path $config

    write-Host "[+] Restarting HybridConnectionManager Services .."
    $HybridConnectionManagerServices = @("HybridConnectionManager")

    # Restarting Log Services
    foreach ($s in $HybridConnectionManagerServices)
    {
        write-Host "[+] Restarting $s .."
        Restart-Service -Name $s -Force

        write-Host "  [*] Verifying if $s is running.."
        $s = Get-Service -Name $s
        while ($s.Status -ne 'Running') { Start-Service $s; Start-Sleep 3 }
        Start-Sleep 5
        write-Host "  [*] $s is running.."
    } 
}
