
function CreateBackupFile($xmlDoc, $path)
{
    $date = Get-Date    
    $dateString = $date.ToString("yyyy MM dd H mm")
    $backupPath = $path.Replace("web.config", "$dateString.web.config.bak")
    $xmlDoc.Save($backupPath)
}

function AddPeoplePickerWildcard($xmlDoc)
{    
    
    
    $newPeoplePickerNode = $xmlDoc.selectSingleNode("/configuration/SharePoint/PeoplePickerWildcards/add[@key='FBAMembership']");
    if(!$newPeoplePickerNode)
    {

        $peoplePickerNode = $xmlDoc.selectSingleNode("/configuration/SharePoint/PeoplePickerWildcards")
        $newPeoplePickerNode = $xmlDoc.CreateNode("element", "add", "")
        
        $peoplePickerKeyAttr = $xmlDoc.CreateAttribute("key");
        $peoplePickerKeyAttr.Value = "FBAMembership";
        $newPeoplePickerNode.Attributes.Append($peoplePickerKeyAttr)
        
        $peoplePickerValueAttr = $xmlDoc.CreateAttribute("value");
        $peoplePickerValueAttr.Value = "%"        
        $newPeoplePickerNode.Attributes.Append($peoplePickerValueAttr)
        
        $peoplePickerNode.AppendChild($newPeoplePickerNode)
    }
    
}

function AddConnectionString($xmlDoc, $connectionString)
{
    #Check to see if the node exists and we just need to update the value
    $connectionStringAddNode = $xmlDoc.selectSingleNode("/configuration/connectionStrings/add[@name='FBA']")
    if(!$connectionStringAddNode)
    {
        #It doesn't exist.  Check to see if "connectionStrings" exists, and if not, create it
        $connectionStringNode = $xmlDoc.selectSingleNode("/configuration/connectionStrings")
        if(!$connectionStringNode)
        {
            $connectionStringNode = $xmlDoc.CreateNode("element","connectionStrings","")
            $xmlDoc.selectSingleNode("/configuration").AppendChild($connectionStringNode)
        }    
        $connectionStringNode = $xmlDoc.selectSingleNode("/configuration/connectionStrings")
        $connectionStringAddNode = $xmlDoc.CreateNode("element","add", "");
        
        $nameAttr = $xmlDoc.CreateAttribute("name")
        $nameAttr.Value = "FBA"    
        $connectionStringAddNode.Attributes.Append($nameAttr);
        
        $providerAttr = $xmlDoc.CreateAttribute("providerName")
        $providerAttr.Value = "System.Data.SqlClient"    
        $connectionStringAddNode.Attributes.Append($providerAttr);            
        
        $connectionStringAddNode = $connectionStringNode.AppendChild($connectionStringAddNode);    
    }                    
    
    #Create or update the connectionString attribute    
    $connectionStringAttr = $xmlDoc.CreateAttribute("connectionString")
    $connectionStringAttr.Value = $connectionString    
    $connectionStringAddNode.Attributes.Append($connectionStringAttr);
}

function AddMembership($xmlDoc)
{
    $membershipAddNode = $xmlDoc.selectSingleNode("/configuration/system.web/membership/providers/add[@name='FBAMembership']")
    
    if(!$membershipAddNode)
    {
        #The membership node doesn't exist
        $membershipNode = $xmlDoc.selectSingleNode("/configuration/system.web/membership")
        $providerNode = $null
        
        if(!$membershipNode)
        {
            $membershipNode = $xmlDoc.CreateNode("element", "membership", "")        
            $providerNode = $xmlDoc.CreateNode("element","providers","")
            $membershipNode.AppendChild($providerNode)
            $xmlDoc.selectSingleNode("/configuration/system.web").AppendChild($membershipNode)                
        }
        
        $providerNode = $xmlDoc.selectSingleNode("/configuration/system.web/membership/providers")
        $membershipAddNode = $xmlDoc.CreateNode("element","add","")
        
        $membershipNameAttr = $xmlDoc.CreateAttribute("name")
        $membershipNameAttr.Value = "FBAMembership"
        $membershipAddNode.Attributes.Append($membershipNameAttr)
        
        $membershipTypeAttr = $xmlDoc.CreateAttribute("type")
        $membershipTypeAttr.Value = "System.Web.Security.SqlMembershipProvider, System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
        $membershipAddNode.Attributes.Append($membershipTypeAttr)
        
        $membershipAppNameAttr = $xmlDoc.CreateAttribute("applicationName")
        $membershipAppNameAttr.Value = "/"
        $membershipAddNode.Attributes.Append($membershipAppNameAttr)

        $membershipconnectionStringNameAttr = $xmlDoc.CreateAttribute("connectionStringName")
        $membershipconnectionStringNameAttr.Value = "FBA"
        $membershipAddNode.Attributes.Append($membershipconnectionStringNameAttr)
        
        $membershipenablePasswordResetAttr = $xmlDoc.CreateAttribute("enablePasswordReset")
        $membershipenablePasswordResetAttr.Value = "false"
        $membershipAddNode.Attributes.Append($membershipenablePasswordResetAttr)

        $membershipenablePasswordRetrieval = $xmlDoc.CreateAttribute("enablePasswordRetrieval")
        $membershipenablePasswordRetrieval.Value = "false"
        $membershipAddNode.Attributes.Append($membershipenablePasswordRetrieval)
        
        $membershippasswordFormat = $xmlDoc.CreateAttribute("passwordFormat")
        $membershippasswordFormat.Value = "Clear"
        $membershipAddNode.Attributes.Append($membershippasswordFormat)
        
        $membershiprequiresQuestionAndAnswer = $xmlDoc.CreateAttribute("requiresQuestionAndAnswer")
        $membershiprequiresQuestionAndAnswer.Value = "false"
        $membershipAddNode.Attributes.Append($membershiprequiresQuestionAndAnswer)
              
        $membershiprequiresUniqueEmail = $xmlDoc.CreateAttribute("requiresUniqueEmail")
        $membershiprequiresUniqueEmail.Value = "false"
        $membershipAddNode.Attributes.Append($membershiprequiresUniqueEmail)

        $providerNode.AppendChild($membershipAddNode)

    }
}

function AddRoles($xmlDoc)
{
    #Check to see if it was already created, and if not, create it
    $rolesAddNode = $xmlDoc.selectSingleNode("/configuration/system.web/roleManager/providers/add[@name='FBARoles']")
    if(!$rolesAddNode)
    {
        $rolesNode = $xmlDoc.selectSingleNode("/configuration/system.web/roleManager")
        $providerNode = $null
        
        if(!$rolesNode)
        {
            $rolesNode = $xmlDoc.CreateNode("element", "roleManager", "")        
            $providerNode = $xmlDoc.CreateNode("element","providers","")
            $rolesNode.AppendChild($providerNode)
            $xmlDoc.selectSingleNode("/configuration/system.web").AppendChild($rolesNode)                
        }
        $rolesNode = $xmlDoc.selectSingleNode("/configuration/system.web/roleManager")
        $rolesEnabledAttr = $xmlDoc.CreateAttribute("enabled");
        $rolesEnabledAttr.Value = "true";
        $rolesNode.Attributes.Append($rolesEnabledAttr)
        
        $providerNode = $xmlDoc.selectSingleNode("/configuration/system.web/roleManager/providers")
        $rolesAddNode = $xmlDoc.CreateNode("element","add","")
        
        $roleNameAttr = $xmlDoc.CreateAttribute("name")
        $roleNameAttr.Value = "FBARoles"
        $rolesAddNode.Attributes.Append($roleNameAttr)
        
        $roleTypeAttr = $xmlDoc.CreateAttribute("type")
        $roleTypeAttr.Value = "System.Web.Security.SqlRoleProvider, System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
        $rolesAddNode.Attributes.Append($roleTypeAttr)

        $rolesAppNameAttr = $xmlDoc.CreateAttribute("applicationName")
        $rolesAppNameAttr.Value = "/"
        $rolesAddNode.Attributes.Append($rolesAppNameAttr)

        $rolesConnectionStringNameAttr = $xmlDoc.CreateAttribute("connectionStringName")
        $rolesConnectionStringNameAttr.Value = "FBA"
        $rolesAddNode.Attributes.Append($rolesConnectionStringNameAttr)

        $providerNode.AppendChild($rolesAddNode)
    }
}

function ProcessCentralAdmin($path, $connectionString)
{

    $content = Get-Content -Path $path
    [System.Xml.XmlDocument] $xd = new-object System.Xml.XmlDocument
    $xd.LoadXml($content)

    CreateBackupFile $xd $path
    
    #Add connection string        
    AddConnectionString $xd $connectionString
    
    #Add People Picker Wildcard
    AddPeoplePickerWildcard $xd
    
    #Add Roles
    AddRoles $xd
    $roleNode = $xd.selectSingleNode("/configuration/system.web/roleManager")
    $defaultRoleProviderAttr = $xd.CreateAttribute("defaultProvider")
    $defaultRoleProviderAttr.Value = "AspNetWindowsTokenRoleProvider"
    $roleNode.Attributes.Append($defaultRoleProviderAttr)
            
    #Add Membership
    AddMembership $xd
    
    $membershipNode = $xd.selectSingleNode("/configuration/system.web/membership")
    $defaultMembershipProviderAttr = $xd.CreateAttribute("defaultProvider")
    $defaultMembershipProviderAttr.Value = "FBAMembership"
    $membershipNode.Attributes.Append($defaultMembershipProviderAttr)        
       
    $xd.Save($path)
}

function ProcessWebApplication($path, $connectionString)
{
    $content = Get-Content -Path $path
    [System.Xml.XmlDocument] $xd = new-object System.Xml.XmlDocument
    $xd.LoadXml($content)

    CreateBackupFile $xd $path

    #Add connection string        
    AddConnectionString $xd $connectionString
    
    #Add People Picker Wildcard
    AddPeoplePickerWildcard $xd
            
    #Add Membership
    AddMembership $xd
    
    #Add Roles
    AddRoles $xd
    
    $xd.Save($path)
}

function ProcessSTS($path, $connectionString)
{
    $content = Get-Content -Path $path
    [System.Xml.XmlDocument] $xd = new-object System.Xml.XmlDocument
    $xd.LoadXml($content)
    
    CreateBackupFile $xd $path
    
    #Add connection string        
    AddConnectionString $xd $connectionString
    
    #People picker wildcard is not necessary in STS config
            
    #Check to see if the system.web element exists, and if not, create it        
    $sysWebNode = $xd.SelectSingleNode("/configuration[system.web]")
    if(!$sysWebNode)
    {
        $config = $xd.SelectSingleNode("/configuration");
        $sysWebNode = $xd.CreateNode("element","system.web","")
        $config.AppendChild($sysWebNode)
    }
    
    #Add Membership
    AddMembership $xd
    
    #Set FBAMembership as default in STS
    $membershipNode = $xd.selectSingleNode("/configuration/system.web/membership")
    $defaultMembershipProviderAttr = $xd.CreateAttribute("defaultProvider")
    $defaultMembershipProviderAttr.Value = "FBAMembership"
    $membershipNode.Attributes.Append($defaultMembershipProviderAttr)        
    
    #Add Roles
    AddRoles $xd   
    
    #Set FBARoles as default in STS
    $roleNode = $xd.selectSingleNode("/configuration/system.web/roleManager")
    $defaultRoleProviderAttr = $xd.CreateAttribute("defaultProvider")
    $defaultRoleProviderAttr.Value = "FBARoles"
    $roleNode.Attributes.Append($defaultRoleProviderAttr)

    $xd.Save($path)
}

function Main($pathToWebApplicationConfig, $pathToCentralAdminConfig, $connectionString)
{
    $servers = Get-SPServer | ?{$_.Role -eq "Application"}
    foreach($server in $servers)
    {
        $name = $server.Name
                        
        $webAppConfigPath = $pathToWebApplicationConfig.Replace("c:\", "\\$name\c$\")           
        $centralAdminConfigPath = $pathToCentralAdminConfig.Replace("c:\", "\\$name\c$\")        
        $stsConfigPath = "\\$name\c$\Program Files\Common Files\Microsoft Shared\Web Server Extensions\14\WebServices\SecurityToken\web.config"
        

        ProcessWebApplication $webAppConfigPath $connectionString
        if(Test-Path $centralAdminConfigPath)
        {
            ProcessCentralAdmin $centralAdminConfigPath $connectionString
        }
        
        ProcessSTS $stsConfigPath $connectionString
    }
}

#Update with path to Central Administration web.config
$pathToCentralAdminConfig = "c:\inetpub\wwwroot\wss\virtualdirectories\36164\web.config"
#Update with path to web application's web.config
$pathToWebApplicationConfig = "c:\inetpub\wwwroot\wss\VirtualDirectories\SAMLClaims.SharePoint.com443\web.config"
#Update with correct connection string
$connectionString = "data source=SQL; Integrated Security=SSPI; Initial Catalog=aspnetdb;"


Main $pathToWebApplicationConfig $pathToCentralAdminConfig $connectionString