configuration Install-BadBlood {
    param 
    ( 
        
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
 
        xScript CleanUp
        {
            SetScript =
            {
                # Installing BadBlood
                start-process -FilePath "powershell.exe" -ArgumentList @('-ExecutionPolicy','Bypass','C:\ProgramData\BadBlood\STR-BadBlood\Invoke-BadBlood.ps1') -PassThru -NoNewWindow -ErrorAction Stop | Wait-Process
                Remove-Item "C:\ProgramData\BadBlood" -Force  -Recurse -ErrorAction SilentlyContinue 
                Remove-Item "C:\ProgramData\BadBlood.zip" -Force  -Recurse -ErrorAction SilentlyContinue 
                Remove-Item "C:\ProgramData\SilkETW_SilkService_v8.zip" -Force  -Recurse -ErrorAction SilentlyContinue 
                Remove-Item "C:\ProgramData\sysmon.xml" -Force  -Recurse -ErrorAction SilentlyContinue 
                Remove-Item "C:\ProgramData\Sysmon.zip" -Force  -Recurse -ErrorAction SilentlyContinue 
                Remove-Item "C:\ProgramData\winlogbeat-7.4.0-windows-x86_64.zip" -Force  -Recurse -ErrorAction SilentlyContinue 
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
        }
    }
}


