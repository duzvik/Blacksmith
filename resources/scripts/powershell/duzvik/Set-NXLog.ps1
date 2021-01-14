Invoke-WebRequest -Uri "https://nxlog.co/system/files/products/files/348/nxlog-ce-2.10.2150.msi" -OutFile "nxlog.msi"
msiexec /i nxlog.msi /quiet

mkdir C:\snarelogs\
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

Stop-Service -Name nxlog
Start-Service -Name nxlog 
