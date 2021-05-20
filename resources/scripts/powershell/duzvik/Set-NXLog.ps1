# iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/duzvik/Blacksmith/master/resources/scripts/powershell/duzvik/Set-NXLog.ps1"))

Resolve-DnsName raw.githubusercontent.com
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/OTRF/Blacksmith/ee0f5b8eecdb87092c4f36e30cce49db3063fef2/resources/scripts/powershell/endpoint-software/Install-Sysmon.ps1"))

mkdir C:\snarelogs\

write-host "[+] Processing NXLoog Installation.."

$URL = "https://nxlog.co/system/files/products/files/348/nxlog-ce-2.10.2150.msi"
Resolve-DnsName nxlog.co

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

write-Host "[+] Write NXLog  config file.."
$conf = @"
Panic Soft
#NoFreeOnExit TRUE

define ROOT     C:\Program Files (x86)\nxlog
define CERTDIR  %ROOT%\cert
define CONFDIR  %ROOT%\conf
define LOGDIR   %ROOT%\data
define LOGFILE  %LOGDIR%\nxlog.log
LogFile %LOGFILE%

Moduledir %ROOT%\modules
CacheDir  %ROOT%\data
Pidfile   %ROOT%\data\nxlog.pid
SpoolDir  %ROOT%\data

<Extension syslog>
    Module      xm_syslog
</Extension>
<Extension _charconv>
    Module xm_charconv
    AutodetectCharsets iso8859-2, utf-8, utf-16, utf-32
</Extension>
<Extension _exec>
    Module      xm_exec
</Extension>

<Processor eventlog_transformer>
	Module pm_transformer
	Exec `$Hostname = hostname(); 
	OutputFormat syslog_snare
</Processor>

########################INPUTS##########################
<Input eventlog_security>
	Module im_msvistalog
    # ReadFromLast True
    #<Select Path="Microsoft-Windows-Sysmon/Operational">*</Select>
    <QueryXML>
        <QueryList>                     
            <Query Id="0">  
                <Select Path="Security">*</Select>
            </Query>
        </QueryList>
    </QueryXML>
</Input>
<Input eventlog_powershell>
	Module im_msvistalog
    <QueryXML>
        <QueryList>                     
            <Query Id="0">
                <Select Path="Microsoft-Windows-PowerShell/Operational">*</Select>
            </Query>
        </QueryList>
    </QueryXML>
</Input>
<Input eventlog_sysmon>
	Module im_msvistalog
    <QueryXML>
        <QueryList>                     
            <Query Id="0">
                <Select Path="Microsoft-Windows-Sysmon/Operational">*</Select>
            </Query>
        </QueryList>
    </QueryXML>
</Input>

<Processor eventlog_transformer>
	Module pm_transformer
    # OutputFormat syslog_rfc5424
</Processor>
<Processor buffer>
    Module  pm_buffer
    # 100 MB disk buffer
    MaxSize 102400
    Type    disk
</Processor>
########################OUTPUTS##########################
<Output out_security>
    Module  om_file
    File    "C:\snarelogs\security.log"
    Exec to_syslog_snare();
</Output>
<Output out_powershell>
    Module  om_file
    File    "C:\snarelogs\powershell.log"
    Exec to_syslog_snare();
</Output>
<Output out_sysmon>
    Module  om_file
    File    "C:\snarelogs\sysmon.log"
    Exec to_syslog_snare();
</Output>
<Output syslogout> 
 Module om_tcp 
 Host 165.232.135.17
 Port 514
 Exec to_syslog_snare(); 
</Output> 

<Route 1>
	Path eventlog_security => eventlog_transformer => syslogout
</Route>
<Route 2>
	Path eventlog_powershell => eventlog_transformer => syslogout
</Route>
<Route 3>
	Path eventlog_sysmon => eventlog_transformer => syslogout
</Route>
"@
# https://community.graylog.org/t/multiple-nxlog-inputs-and-outputs/5158
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines("C:\Program Files (x86)\nxlog\conf\nxlog.conf", $conf, $Utf8NoBomEncoding)


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
 
