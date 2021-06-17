 configuration Install-BadBlood {
    param 
    ( 
        [string]$BadBloodUrl = "https://github.com/duzvik/Blacksmith/raw/master/resources/configs/duzvik/STR-BadBlood.zip"
    )

    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    Node localhost
    {
        LocalConfigurationManager
        {           
            ConfigurationMode   = 'ApplyOnly'
            RebootNodeIfNeeded  = $true
        }

        # ***** Download BadBlood Installer *****
        xRemoteFile DownloadBadBloodInstaller
        {
            DestinationPath = "C:\ProgramData\BadBlood.zip"
            Uri = $BadBloodUrl 
        }

        # ***** Unzip BadBlood Installer *****
        xArchive UnzipBadBloodInstaller
        {
            Path = "C:\ProgramData\BadBlood.zip"
            Destination = "C:\ProgramData\BadBlood"
            Ensure = "Present"
            DependsOn = "[xRemoteFile]DownloadBadBloodInstaller"
        }
 
        xScript InstallBadBlood
        {
            SetScript =
            {
                # Installing BadBlood
                #start-process -FilePath "powershell.exe" -ArgumentList @('-i','C:\ProgramData\sysmon.xml','-accepteula') -PassThru -NoNewWindow -ErrorAction Stop | Wait-Process
                start-process -FilePath "powershell.exe" -ArgumentList @('-ExecutionPolicy','Bypass','C:\ProgramData\BadBlood\STR-BadBlood\Invoke-BadBlood.ps1') -PassThru -NoNewWindow -ErrorAction Stop | Wait-Process
            }
            GetScript =  
            {
                # This block must return a hashtable. The hashtable must only contain one key Result and the value must be of type String.
                return @{ "Result" = "false" }
            }
            TestScript = 
            {
                # If it returns $false, the SetScript block will run. If it returns $true, the SetScript block will not run.
                return $false
            }
            DependsOn = '[xArchive]UnzipBadBloodInstaller'
        }
    }
}