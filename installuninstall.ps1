#Q1. Write a parameterized PowerShell script to install and uninstall this test software (https://notepad-plus-plus.org) from a given network location. Install only if a newer version is available.

$useraction = Read-Host -Prompt 'Install Notepad - Enter I or Uninstall Notepad - Enter U'

#Get application version in the local computer 
function Get-FileVersionInfo {   
    [CmdletBinding()]         
    param(            
        [Parameter(Mandatory = $true)]            
        [string]$FileName)            

    if (!(test-path $filename)) {            
        Write-Error "File not found"
    }            
    Write-Output ([System.Diagnostics.FileVersionInfo]::GetVersionInfo($FileName))
}

#Install or Uninstall software based on user action
if ($useraction.ToString().ToLower() -eq "i") {
    Write-Host $currversion.FileVersion
    $Path = $env:TEMP; 
    $Installer = "notepad++.exe";
    $version = "7.8.4"
    $source = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v" + $version + "/npp." + $version + ".Installer.exe"

    #Check if the software is installed in the system
    if (Test-Path "C:\Program Files (x86)\Notepad++\notepad++.exe") {
        write-host "Software already installed! Checking for correct version is In Progress..." 
        #get current version of the software
        $currversion = Get-FileVersionInfo -FileName "C:\Program Files (x86)\Notepad++\notepad++.exe"
        #verify the local version is greaterthan or equal to version
        if ($currversion.FileVersion.Split('.') -ge $version.Split('.')) {
            write-host "Software already installed with correct version" 
        }
        else {
            #Install latest verdsion
            write-host "Software version is outdated new version installation is In Progress..." 
            Invoke-WebRequest $source -OutFile $Path\$Installer; 
            Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait; Remove-Item $Path\$Installer
            write-host "Software installation is completed - new version " $version " has been published." 
            Exit
        }
        Exit
    }
    else {
        #Install software
        write-host "Software is not available installation is In Progress..." 
        Invoke-WebRequest $source -OutFile $Path\$Installer; 
        Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait; Remove-Item $Path\$Installer
        write-host "Software installation is completed - new version " $version " has been published." 
        Exit
    }
}
#Uninstall software based on user action
if ($useraction.ToString().ToLower() -eq "u") {
    Start-Process -FilePath "C:\Program Files (x86)\Notepad++\uninstall.exe" -Args "/silent /install" -Verb RunAs -Wait;
}

