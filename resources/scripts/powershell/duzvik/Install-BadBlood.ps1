[CmdletBinding()]
param (
    [Parameter(Mandatory=$false, Position = 1)]
    [string]$ServiceName = "MGUpdate",
    
    [Parameter(Mandatory=$false, Position = 2)]
    [string]$Url = "https://github.com/duzvik/Blacksmith/raw/master/resources/configs/duzvik/STR-BadBlood.zip",

    [Parameter(Mandatory = $false, Position = 3)]
    [Int32]$UserCount = 2000,

    [Parameter(Mandatory = $false, Position = 4)]
    [int32]$GroupCount = 500,
   
    [Parameter(Mandatory = $false, Position = 5)]
    [int32]$ComputerCount = 250,

    [Parameter(Mandatory = $false, Position = 6)]
    [switch]$SkipOuCreation,
   
    [Parameter(Mandatory = $false,Position = 7)]
    [switch]$SkipLapsIn
)

write-host "[+] Processing BadBlood Installation.."

Resolve-DnsName github.com
Resolve-DnsName raw.githubusercontent.com

$OutputFile = Split-Path $Url -leaf
$File = "C:\ProgramData\$OutputFile"

# Download File
write-Host "[+] Downloading $OutputFile .."
$wc = new-object System.Net.WebClient
$wc.DownloadFile($Url, $File)
if (!(Test-Path $File)) { Write-Error "File $File does not exist" -ErrorAction Stop }

# Unzip file
write-Host "[+] Decompressing $OutputFile .."
$FileName = (Get-Item $File).Basename
Write-Host "expand-archive -path $File -DestinationPath 'C:\ProgramData\$FileName'"
expand-archive -path $File -DestinationPath "C:\ProgramData\$FileName"
if (!(Test-Path "C:\ProgramData\$FileName")) { Write-Error "$File was not decompressed successfully" -ErrorAction Stop }

#run it
powershell.exe -ExecutionPolicy Bypass "C:\ProgramData\$FileName\$FileName\Invoke-BadBlood.ps1 -UserCount $UserCount -GroupCount $GroupCount -ComputerCount $ComputerCount"

#clean-up
Remove-Item "C:\ProgramData\$FileName" -Force 