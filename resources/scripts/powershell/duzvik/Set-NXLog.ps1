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
<Input eventlog>
	Module im_msvistalog
# ReadFromLast True
#<Select Path="Microsoft-Windows-Sysmon/Operational">*</Select>
<QueryXML>
   <QueryList>                     
     <Query Id="0">  
        <Select Path="Security">*</Select>
     </Query>
    <Query Id="1">
		<Select Path="Microsoft-Windows-PowerShell/Operational">*</Select>
    </Query>
	<Query Id="2">
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
<Output out>
    Module  om_file
    File    "C:\snarelogs\out.log"
    Exec to_syslog_snare();
</Output>
<Route 1>
	Path eventlog => eventlog_transformer => out
</Route>
"@

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
 
