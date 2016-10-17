﻿<#
. c:\powershellscripts\Connect-SPOnline.ps1 
EXAMPLE 1 
    
    This example will connect a user to SharePoint Online and will use a stored password for the credential 
   Connect-SPOnline -User "craig@mysponlinesite.com" -Url "https://mysponlinesite-admin.sharepoint.com" -UseStoredCredentials 
EXAMPLE 3 
 
           $SPOnlineParameters = @{ 
                UseStoredCredentials = $true   
            Connect-SPOnline @SPOnlineParameters
        [Parameter(Position=0, Mandatory=$true)]

        if ($hostMajorVersion -lt 3){#p.18
 Write-Error "The Connect-SPOnline function requires PowerShell Version 3. You are running PowerShell Version $hostMajorVersion. Exiting function."
}#p.18
        else{#p.18
    Write-Verbose "Current PowerShell Version is $hostMajorVersion"
}#p.18

        Write-Verbose "Determine the 'bitness' of the current PowerShell Process"
    $bitness = "64" 
}#p.29 
        else{#p.29 
    $bitness = "32"
}#p.29 
        Write-Verbose "The current PowerShell process is $bitness-bit"
 $ModuleName = "Microsoft.Online.SharePoint.PowerShell"
        try{ #p.40
            if (-not(Get-Module -name $name)) { #47
                    Write-Verbose "Load the SharePoint Online Module"
            }#47
            else {#47
                    Write-Verbose "The SharePoint Online Module was already loaded in this PowerShell session prior to executing this function."
            }#47
} #p.40
        catch {#p.40
            Write-Error "There was an error while attempting to load the SharePoint Online Module. Exiting function. Please note that the current PowerShell process is $bitness-bit. There are two versions of the SharePoint Online Management Shell which includes the $ModuleName module - a 32-bit version and 64-bit version. Please ensure that you have the correct version installed to run this function within this $bitness-bit PowerShell process. The SharePoint Online Management Shell is available for download at http://www.microsoft.com/en-us/download/details.aspx?id=35588."
         
}#p.40
        Write-Verbose "Leaving Begin Block: Connect-SPOnline"
Process { #p.63
Write-Verbose "The stored password for will be used to connect to SharePoint Online for the $User user credential." 
Write-Verbose "Constructing path to stored credentials for user $User"
$fileName = "$StoredCredentialPath\$User-Connect-SPOnline-Credentials.txt"
             Write-Verbose "Check if stored credentials exist"
if(!(Test-Path $StoredCredentialPath)) { #p.79
 Write-Verbose "Stored Credentials exist"
            
            $password = $null
            try {#117
            }  #117
            catch {#117
                Write-Error "An error occurred while retrieving your stored secure credentials. Exiting function."
                Write-Error $_
                Exit
            }#117
            try {#128
                Write-Verbose "Creating credential object for $User with stored password to send to SharePoint Online"
                #
                #$user="csd\administrator"
               # $password="p@ssw0rd"
                $credential = New-Object System.Management.Automation.PSCredential $User, $password
                Write-Verbose "Connecting to SharePoint Online"
                Connect-SPOService -Url $Url -Credential $credential
                Write-Verbose "Connected to SharePoint Online"
            }#128
            catch {#128
                Write-Error "An error occurred while attempting to connect to SharePoint Online. Exiting function. Your issue is either with your Internet connection, the SharePoint Online Administration site URL you specified is incorrect, the credentials for the SharePoint Online Administration site you specified are incorrect or the SharePoint Online system itself is experiencing a problem. Please read the error message below carefully for clues on how to resolve your issue."
                Write-Error $_
                Exit
        } #p.66
        else {#p.66
            Write-Verbose "User elected to be prompted for credential password." 
            try {  #142
                Write-Warning "Provide a credential password for $User for site $URL. It is requried to connect to SharePoint Online."
                $credential = Get-Credential $User 
                Write-Verbose "Connected to SharePoint Online"
            }#142
            catch {#142
                Write-Error "An error occurred while attempting to connect to SharePoint Online. Exiting function. Your issue is either with your Internet connection, the SharePoint Online Administration site URL you specified is incorrect, the credentials for the SharePoint Online Administration site you specified are incorrect or the SharePoint Online system itself is experiencing a problem. Please read the error message below carefully for clues on how to resolve your issue."
                Write-Error $_
                Exit
            }#142
        }#p.66
        Write-Verbose "Leaving Process Block: Connect-SPOnline"
    }#p.63
}#P1