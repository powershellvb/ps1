


$ErrorActionPreference = "Stop"
gh Add-PSSnapin -full
Add-PSSnapin Microsoft.SharePoint.PowerShell -EA 0

function ConfigureSharePointSearch(
    [Microsoft.SharePoint.Administration.SPIisWebServiceApplicationPool] $appPool,
    [System.Management.Automation.PSCredential] $crawlCredentials,    
    [string] $serviceAppName = "Search Service Application",
    [string] $searchDatabaseName = "SearchService",
    [string] $searchServer = $env:COMPUTERNAME,
    [string] $adminServer = $env:COMPUTERNAME,
    [string] $crawlServer = $env:COMPUTERNAME,
    [string] $queryServer = $env:COMPUTERNAME)
{
    Write-Host "Configuring SharePoint Search..."

    Write-Debug "appPool: $appPool"
    Write-Debug "crawlCredentials: $($crawlCredentials.Username)"
    Write-Debug "serviceAppName: $serviceAppName"
    Write-Debug "searchDatabaseName: $searchDatabaseName"
    Write-Debug "searchServer: $searchServer"
    Write-Debug "adminServer: $adminServer"
    Write-Debug "crawlServer: $crawlServer"
    Write-Debug "queryServer: $queryServer"

    If ($appPool -eq $null)
    {
        Throw "The application pool must be specified."
    }
    ElseIf ($crawlCredentials -eq $null)
    {
        Throw "The crawl credentials must be specified."
    }

    Write-Host "Creating $serviceAppName..."
    
    $serviceAppName= "ESSAppName"
     $appPool= "search-apppool "
      $searchDatabaseName= "ESSAppDBName"
    st #3m30s
    $searchApp = New-SPEnterpriseSearchServiceApplication -Name $serviceAppName `
        -ApplicationPool $appPool -DatabaseName $searchDatabaseName 
        GET-SPEnterpriseSearchServiceApplication
    tt
    Write-Host ("Starting the SharePoint Search Service instance and Search Admin" `
       + " component...")
       
        
    $adminSearchInstance = Get-SPEnterpriseSearchServiceInstance -Debug:$false |
        Where { $_.Server -match $adminServer }
        $adminSearchInstance.Server
        
    $admin = $searchApp |Get-SPEnterpriseSearchAdministrationComponent -Debug:$false

    if($adminSearchInstance.Status -ne "Online")
    {
        Write-Host "Provisioning SharePoint Search Service instance..."
        $adminSearchInstance.Provision()
        Start-Sleep 10
    }

    $admin | Set-SPEnterpriseSearchAdministrationComponent -SearchServiceInstance $adminSearchInstance 

    $admin = ($searchApp | Get-SPEnterpriseSearchAdministrationComponent -Debug:$false)

    Write-Host -NoNewLine "Waiting for Search Admin component to initialize..."
   
    
    While (-not $admin.Initialized) 
    {
        Write-Host -NoNewLine "."
        Start-Sleep -Seconds 5
        $admin = $searchApp |Get-SPEnterpriseSearchAdministrationComponent -Debug:$false
    }
        
    Write-Host
    
    Write-Host "Setting the default content access account..."
    $searchApp | Set-SPEnterpriseSearchServiceApplication `
        -DefaultContentAccessAccountName $crawlCredentials.Username `
        -DefaultContentAccessAccountPassword $crawlCredentials.Password `
        -Debug:$false

    Start-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance $adminServer `
        -Debug:$falseservice

    # By default, a search application created in PowerShell has a crawl
    # topology but is missing the following:
    #
    #   - crawl component
    #   - query component
    #
    # You cannot add a crawl\query component to the default crawl\query topology
    # because it's set as active and the property is read only.  The easiest way
    # around this is creating a new crawl topology and new query topology. After
    # creating both, they will be set as inactive by default.  This allows for
    # both crawl components to be added to crawl topology and query component to
    # be added to newly created query topology. Finally, you can set this new
    # crawl topology to active.
    #
    # http://blogs.msdn.com/b/russmax/archive/2009/10/20/sharepoint-2010-configuring-search-service-application-using-powershell.aspx)

    # Save initial topologies so they can be removed later
    Write-Host "Getting initial topologies..."
    $initialCrawlTopology = $searchApp | Get-SPEnterpriseSearchCrawlTopology 
        
    $initialQueryTopology = $searchApp | Get-SPEnterpriseSearchQueryTopology 

    # Create new crawl topology
    Write-Host "Creating new crawl topology..."
    $crawlTopology = $searchApp | New-SPEnterpriseSearchCrawlTopology 
        
    $crawlDatabase = Get-SPEnterpriseSearchCrawlDatabase -SearchApplication $searchApp -Debug:$false

    # Populate new crawl topology
    Write-Host "Populating new crawl topology..."
    $crawlInstance = Get-SPEnterpriseSearchServiceInstance |Where { $_.Server -match $crawlServer }
        
    $crawlComponent = New-SPEnterpriseSearchCrawlComponent `
        -CrawlTopology $crawlTopology -CrawlDatabase $crawlDatabase `
        -SearchServiceInstance $crawlInstance -Debug:$false

    # Activate new crawl Topology
    Write-Host "Activating new crawl topology..."
    $crawlTopology | Set-SPEnterpriseSearchCrawlTopology -Active -Debug:$false

    $initialCrawlTopology.CancelActivate()
    
    Write-Host -NoNewLine "Waiting for initial crawl topology to be inactive..."
    
    Do
    {
        Start-Sleep 5
        Write-Host -NoNewLine "."
    } While ($initialCrawlTopology.State -ne "Inactive")
            
    Write-Host

    # Create new query topology
    Write-Host "Creating new query topology..."
    $queryTopology = $searchApp |
        New-SPEnterpriseSearchQueryTopology -Partitions 1 -Debug:$false

    # Create Property Store database
    Write-Host "Creating Property Store database..."
    $propertyDatabase = Get-SPEnterpriseSearchPropertyDatabase `
        -SearchApplication $searchApp -Debug:$false

    # Set index partition to use Property Store database
    Write-Host "Setting index partition to use Property Store database..."
    $indexPartition = Get-SPEnterpriseSearchIndexPartition `
        -QueryTopology $queryTopology -Debug:$false
        
    $indexPartition | Set-SPEnterpriseSearchIndexPartition `
        -PropertyDatabase $propertyDatabase -Debug:$false

    # Populate new query topology
    Write-Host "Populating new query topology...."
    $queryInstance = Get-SPEnterpriseSearchServiceInstance -Debug:$false |
        Where { $_.Server -match $queryServer }
        
    $queryComponent = New-SPEnterpriseSearchQueryComponent `
        -QueryTopology $queryTopology -IndexPartition $indexPartition `
        -SearchServiceInstance $queryInstance -Debug:$false

    # Activate new query topology
    Write-Host "Activating new query topology..."
    $QueryTopology | Set-SPEnterpriseSearchQueryTopology -Active -Debug:$false

    Write-Host -NoNewLine "Waiting for initial query topology to be inactive..."
    
    Do
    {
        Start-Sleep 5
        Write-Host -NoNewLine "."
    } While ($initialQueryTopology.State -ne "Inactive")

    Write-Host

    # Remove initial topologies
    Write-Host "Removing initial topologies..."
    $initialCrawlTopology | Remove-SPEnterpriseSearchCrawlTopology -Confirm:$false -Debug:$false
        
    $initialQueryTopology | Remove-SPEnterpriseSearchQueryTopology -Confirm:$false -Debug:$false

    # Create service application proxy and add to Default proxy group
    Write-Host "Creating service application proxy..."
    $searchProxy = New-SPEnterpriseSearchServiceApplicationProxy `
        -Name "$serviceAppName" -SearchApplication $searchApp -Debug:$false

    Write-Host -Fore Green "Successfully configured SharePoint Search."
}

function GetServiceAppsAppPool(
    [string] $appPoolName,
    [string] $appPoolUserName)
{
    Write-Debug "Trying to get existing service application pool ($appPoolName)..."
    $appPool = Get-SPServiceApplicationPool $appPoolName -Debug:$false -EA 0

    If ($appPool -ne $null)
    {
        Write-Debug "The service application pool ($appPoolName) already exists."
        return $appPool
    }
    
    Write-Host "Creating service application pool ($appPoolName)..."

    Write-Debug "Get service account for application pool ($appPoolUserName)..."
    $appPoolAccount = Get-SPManagedAccount -Identity $appPoolUserName `
        -Debug:$false -EA 0

    If($appPoolAccount -eq $null)
    {
        Write-Host "Registering managed account ($appPoolUserName)..."

        Write-Debug "Get credential ($appPoolUserName)..."
        $appPoolCredential = Get-Credential $appPoolUserName

        $appPoolAccount =
            New-SPManagedAccount -Credential $appPoolCredential -Debug:$false
    } 

    If ($appPoolAccount -eq $null)
    {
        Write-Host -Force Red ("Unable to find or create the managed account" `
            + " ($appPoolUserName).")

        Exit 1
    }

    $appPool = New-SPServiceApplicationPool -Name $appPoolName `
        -Account $appPoolAccount -Debug:$false

    Write-Host -Fore Green ("Successfully created service application pool" `
        + " ($appPoolName).")
    
    return $appPool
}

# http://powershell.com/cs/blogs/ebook/archive/2009/04/10/chapter-19-user-management.aspx#logging-on-under-other-user-names
function ValidateCredentials(
    $credentials)
{
    Write-Debug "Validating credentials ($($credentials.UserName))..."

    $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR(
            $credentials.Password))
    
    $currentDomain = "LDAP://" + ([ADSI]"").distinguishedName

    $domain = New-Object DirectoryServices.DirectoryEntry(
        $currentDomain,
        $credentials.UserName,
        $password)
    
    trap { $script:err = $_ ; continue } &{
        $domain.Bind($true); $script:err = $null }

    if ($err.Exception.ErrorCode -ne -2147352570)
    {
        Write-Host -Fore Red $err.Exception.Message
        Exit 1
    }
    
    Write-Debug "Successfully validated credentials ($($credentials.UserName))."
}

function Main()
{
    $searchServer = $env:COMPUTERNAME
    $adminServer = $searchServer
    $crawlServer = $searchServer
    $queryServer = $searchServer
    $serviceAppsAppPoolName = "SharePoint Service Applications"
    $serviceAppsAppPoolUserName = $env:USERDOMAIN + "\svc-spserviceapp"
    $serviceAppName = "Search Service Application"
    $searchDatabaseName = "SearchService"
    $crawlServiceAccount = $env:USERDOMAIN + "\svc-index"

    $webAppUrl = $env:FABRIKAM_DEMO_URL
    if ($webAppUrl -eq $null)
    {
        $webAppUrl = "http://www.fabrikam.com"
    }

    if (($webAppUrl -eq "http://www-local.fabrikam.com") -or
        ($webAppUrl -eq "http://www-dev.fabrikam.com"))
    {
        Write-Debug "Overriding variables for Development environment..."
        $serviceAppsAppPoolUserName = $env:USERDOMAIN + "\svc-spserviceapp-dev"
        $crawlServiceAccount = $env:USERDOMAIN + "\svc-index-dev"
    }
    elseif ($webAppUrl -eq "http://www-test.fabrikam.com")
    {
        Write-Debug "Overriding variables for Test environment..."
        $serviceAppsAppPoolUserName = $env:USERDOMAIN + "\svc-spserviceapp-test"
        $crawlServiceAccount = $env:USERDOMAIN + "\svc-index-test"
    }

    Write-Host ("Please enter the password for the default content access account" `
        + " ($crawlServiceAccount)...")
        
    $crawlCredentials = Get-Credential $crawlServiceAccount
    ValidateCredentials $crawlCredentials

    $appPool = GetServiceAppsAppPool $serviceAppsAppPoolName `
        $serviceAppsAppPoolUserName
        
    ConfigureSharePointSearch $appPool $crawlCredentials $serviceAppName `
        $searchDatabaseName $searchServer $adminServer $crawlServer $queryServer

}

Main