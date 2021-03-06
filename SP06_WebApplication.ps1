<#
SP06_WebApplication

\\172.16.220.29\c$\Users\administrator.CSD\OneDrive\download\PS1\SP06_WebApplication.ps1


$ps1fS=gi C:\Users\administrator.CSD\OneDrive\download\ps1\SP06_WebApplication.ps1

foreach ($ps1f in $ps1fS)
{
    start-sleep 1
    $ps1fname         =$ps1fS.name
    $ps1fFullname     =$ps1fS.FullName 
    $ps1flastwritetime=$ps1fS.LastWriteTime
    $getdagte         = get-date -format yyyyMMdd
    $ps1length        =$ps1fS.Length

    Send-MailMessage -SmtpServer  '172.16.200.27'  -To "a0921887912@gmail.com","abcd12@gmail.com" -from 'a0921887912@gmail.com' `
    -attachment $ps1fFullname  `
    -Subject "ps1source  -- $getdagte      --        $ps1fname       --   $ps1flastwritetime -- $ps1length " `
    -Body "  ps1source from:me $ps1fname   " 
}

from 01SPWebApplication
# gh   Get-SPManagedAccount  -full  所有受管理帳戶。
# gh   New-SPManagedAccount  -full

# gh   Get-SPServiceApplicationPool  -full  應用程式集區
# gh   Remove-SPServiceApplicationPool  -full

# gh   Get-SPWebApplication  -full  傳回所有Web 應用程式
# cls;gh   set-SPWebApplication  -full
# gh   Get-SPManagedAccount  -full

#    New
#    remove  whoami
#    Set
# create by Ming.  Mar.25.2013 for  GPWB
#Add-PsSnapIn Microsoft.SharePoint.PowerShell 
#param(
#[string]$WebAppName,
#[string]$WebAppPort,
#[string]$WebAppHostHeader,
#[string]$Url,
#[string]$WebAppAppPool = "NTLM",
#[string]$WebAppAppPoolAccount,
#[string]$WebAppDatabaseName,
#[string]$WebAppDatabaseServer
#>
    
    
##   51 伺服器陣列中所有的服務應用程式集區
##   64  Get-SPWebTemplate
##  188  SPWebApplication 
##   526 upload  +  download + delete  file to sharepoint 



   
ASNP Microsoft.SharePoint.Powershell  
      
#-----------------------------------
## 51 伺服器陣列中所有的服務應用程式集區  SPServiceApplicationPool
#-----------------------------------
get-SPServiceApplicationPool


Remove-SPServiceApplicationPool "SharePoint Hosted Services"  -Confirm:$false


$cred = Get-Credential CSD\SPFarmAdmin
New-SPManagedAccount  -Credential   $cred  
#Get-SPManagedAccount  CSD\SPFarmAdmin
$WebAppName = "SP2"
$WebAppPort =  80
$WebAppHostHeader = "sp2.csd.syscom"
$Url =  "http://sp2.csd.syscom"
$WebAppAppPool = "sp2AppPool"
$WebAppAppPoolAccount =  "CSD\SPFarmAdmin"
$WebAppDatabaseName =  "content_sp2_80"
$WebAppDatabaseServer= "2013Bi"



#-----------------------------------
##    64  Get-SPWebTemplate
#-----------------------------------

##   SharePoint 2013 Site Templates Codes for PowerShell
{Get-SPWebTemplate
'
Name                 Title                                    LocaleId   CompatibilityLevel   Custom    
----                 -----                                    --------   ------------------   ------    
GLOBAL#0             Global template                          1033       15                   False     
STS#0                Team Site                                1033       15                   False     
STS#1                Blank Site                               1033       15                   False     
STS#2                Document Workspace                       1033       15                   False     
MPS#0                Basic Meeting Workspace                  1033       15                   False     
MPS#1                Blank Meeting Workspace                  1033       15                   False     
MPS#2                Decision Meeting Workspace               1033       15                   False     
MPS#3                Social Meeting Workspace                 1033       15                   False     
MPS#4                Multipage Meeting Workspace              1033       15                   False     
CENTRALADMIN#0       Central Admin Site                       1033       15                   False     
WIKI#0               Wiki Site                                1033       15                   False     
BLOG#0               Blog                                     1033       15                   False     
SGS#0                Group Work Site                          1033       15                   False     
TENANTADMIN#0        Tenant Admin Site                        1033       15                   False     
APP#0                App Template                             1033       15                   False     
APPCATALOG#0         App Catalog Site                         1033       15                   False     
ACCSRV#0             Access Services Site                     1033       15                   False     
ACCSVC#0             Access Services Site Internal            1033       15                   False     
ACCSVC#1             Access Services Site                     1033       15                   False     
BDR#0                Document Center                          1033       15                   False     
DEV#0                Developer Site                           1033       15                   False     
DOCMARKETPLACESITE#0 Academic Library                         1033       15                   False     
EDISC#0              eDiscovery Center                        1033       15                   False     
EDISC#1              eDiscovery Case                          1033       15                   False     
OFFILE#0             (obsolete) Records Center                1033       15                   False     
OFFILE#1             Records Center                           1033       15                   False     
OSRV#0               Shared Services Administration Site      1033       15                   False     
PPSMASite#0          PerformancePoint                         1033       15                   False     
BICenterSite#0       Business Intelligence Center             1033       15                   False     
SPS#0                SharePoint Portal Server Site            1033       15                   False     
SPSPERS#0            SharePoint Portal Server Personal Space  1033       15                   False     
SPSPERS#2            Storage And Social SharePoint Portal ... 1033       15                   False     
SPSPERS#3            Storage Only SharePoint Portal Server... 1033       15                   False     
SPSPERS#4            Social Only SharePoint Portal Server ... 1033       15                   False     
SPSPERS#5            Empty SharePoint Portal Server Person... 1033       15                   False     
SPSMSITE#0           Personalization Site                     1033       15                   False     
SPSTOC#0             Contents area Template                   1033       15                   False     
SPSTOPIC#0           Topic area template                      1033       15                   False     
SPSNEWS#0            News Site                                1033       15                   False     
CMSPUBLISHING#0      Publishing Site                          1033       15                   False     
BLANKINTERNET#0      Publishing Site                          1033       15                   False     
BLANKINTERNET#1      Press Releases Site                      1033       15                   False     
BLANKINTERNET#2      Publishing Site with Workflow            1033       15                   False     
SPSNHOME#0           News Site                                1033       15                   False     
SPSSITES#0           Site Directory                           1033       15                   False     
SPSCOMMU#0           Community area template                  1033       15                   False     
SPSREPORTCENTER#0    Report Center                            1033       15                   False     
SPSPORTAL#0          Collaboration Portal                     1033       15                   False     
SRCHCEN#0            Enterprise Search Center                 1033       15                   False     
PROFILES#0           Profiles                                 1033       15                   False     
BLANKINTERNETCONT... Publishing Portal                        1033       15                   False     
SPSMSITEHOST#0       My Site Host                             1033       15                   False     
ENTERWIKI#0          Enterprise Wiki                          1033       15                   False     
PROJECTSITE#0        Project Site                             1033       15                   False     
PRODUCTCATALOG#0     Product Catalog                          1033       15                   False     
COMMUNITY#0          Community Site                           1033       15                   False     
COMMUNITYPORTAL#0    Community Portal                         1033       15                   False     
SRCHCENTERLITE#0     Basic Search Center                      1033       15                   False     
SRCHCENTERLITE#1     Basic Search Center                      1033       15                   False     
visprus#0            Visio Process Repository                 1033       15                   False     
GLOBAL#0             Global template                          1033       14                   False     
STS#0                Team Site                                1033       14                   False     
STS#1                Blank Site                               1033       14                   False     
STS#2                Document Workspace                       1033       14                   False     
MPS#0                Basic Meeting Workspace                  1033       14                   False     
MPS#1                Blank Meeting Workspace                  1033       14                   False     
MPS#2                Decision Meeting Workspace               1033       14                   False     
MPS#3                Social Meeting Workspace                 1033       14                   False     
MPS#4                Multipage Meeting Workspace              1033       14                   False     
CENTRALADMIN#0       Central Admin Site                       1033       14                   False     
WIKI#0               Wiki Site                                1033       14                   False     
BLOG#0               Blog                                     1033       14                   False     
SGS#0                Group Work Site                          1033       14                   False     
TENANTADMIN#0        Tenant Admin Site                        1033       14                   False     
ACCSRV#0             Access Services Site                     1033       14                   False     
ACCSRV#1             Assets Web Database                      1033       14                   False     
ACCSRV#3             Charitable Contributions Web Database    1033       14                   False     
ACCSRV#4             Contacts Web Database                    1033       14                   False     
ACCSRV#6             Issues Web Database                      1033       14                   False     
ACCSRV#5             Projects Web Database                    1033       14                   False     
BDR#0                Document Center                          1033       14                   False     
OFFILE#0             (obsolete) Records Center                1033       14                   False     
OFFILE#1             Records Center                           1033       14                   False     
OSRV#0               Shared Services Administration Site      1033       14                   False     
PPSMASite#0          PerformancePoint                         1033       14                   False     
BICenterSite#0       Business Intelligence Center             1033       14                   False     
SPS#0                SharePoint Portal Server Site            1033       14                   False     
SPSPERS#0            SharePoint Portal Server Personal Space  1033       14                   False     
SPSMSITE#0           Personalization Site                     1033       14                   False     
SPSTOC#0             Contents area Template                   1033       14                   False     
SPSTOPIC#0           Topic area template                      1033       14                   False     
SPSNEWS#0            News Site                                1033       14                   False     
CMSPUBLISHING#0      Publishing Site                          1033       14                   False     
BLANKINTERNET#0      Publishing Site                          1033       14                   False     
BLANKINTERNET#1      Press Releases Site                      1033       14                   False     
BLANKINTERNET#2      Publishing Site with Workflow            1033       14                   False     
SPSNHOME#0           News Site                                1033       14                   False     
SPSSITES#0           Site Directory                           1033       14                   False     
SPSCOMMU#0           Community area template                  1033       14                   False     
SPSREPORTCENTER#0    Report Center                            1033       14                   False     
SPSPORTAL#0          Collaboration Portal                     1033       14                   False     
SRCHCEN#0            Enterprise Search Center                 1033       14                   False     
PROFILES#0           Profiles                                 1033       14                   False     
BLANKINTERNETCONT... Publishing Portal                        1033       14                   False     
SPSMSITEHOST#0       My Site Host                             1033       14                   False     
ENTERWIKI#0          Enterprise Wiki                          1033       14                   False     
SRCHCENTERLITE#0     Basic Search Center                      1033       14                   False     
SRCHCENTERLITE#1     Basic Search Center                      1033       14                   False     
SRCHCENTERFAST#0     FAST Search Center                       1033       14                   False     
visprus#0            Visio Process Repository                 1033       14                   False 
'
}
#-------------

#-----------------------------------
##  188  SPWebApplication 
#-----------------------------------

#  Get
#cls;get-help Get-SPWebApplication -full

$Url =  "http://bi29.csd.syscom"
$WPSP=Get-SPWebApplication $Url ; $WPSP |select *
'PS C:\Windows\system32> Get-SPWebApplication -Identity PowerPivot- 80 |select *


Url                                                  : http://pp.tempcsd.syscom/
SiteDataServers                                      : {}
IisSettings                                          : {[Default, Microsoft.SharePoint.Administration.SPIisSettings]}
ApplicationPool                                      : SPApplicationPool Name=BIApplicationPool
WebService                                           : SPWebService
AlternateUrls                                        : {Microsoft.SharePoint.Administration.SPAlternateUrl}
AlwaysProcessDocuments                               : False
DefaultServerComment                                 : SharePoint
WebConfigModifications                               : {SafeControl[@Assembly=Microsoft.Office.DocMarketplace, Version=15.0.0.0, Culture=neutral, Pu
                                                       blicKeyToken=71e9bce111e9429c][@Namespace=''Microsoft.Office.DocMarketplace''][@TypeName=''*''][@
                                                       Safe=''True''][@AllowRemoteDesigner=''True''][@SafeAgainstScript=''True'']}
TypeName                                             : Web 應用程式
ContentDatabases                                     : {PowerPivotWebApplicationDB}
SelfServiceSiteCreationEnabled                       : False
ShowStartASiteMenuItem                               : False
SelfServiceSiteCustomFormUrl                         : 
SelfServiceCreateIndividualSite                      : False
SelfServiceCreationParentSiteUrl                     : 
SelfServiceCreationQuotaTemplate                     : 
IsPaired                                             : False
CanMigrate                                           : False
Features                                             : {0ea1c3b6-6ac0-44aa-9f3f-05e8dbe6d70b, 14173c38-5e2d-4887-8134-60f9df889bad, 1dbf6063-d809-45e
                                                       a-9203-d3ba4a64f86d, 20477d83-8bdb-414e-964b-080637f7d99b...}
EventLogRetentionPeriod                              : 14.00:00:00
ChangeLogRetentionPeriod                             : 60.00:00:00
DocumentLibraryCalloutOfficeWebAppPreviewersDisabled : False
ChangeLogExpirationEnabled                           : True
AlertsEnabled                                        : True
AlertsLimited                                        : True
AlertsMaximum                                        : 500
UseExternalUrlZoneForAlerts                          : True
MaxSizePerCellStorageOperation                       : 0
MaxItemsPerThrottledOperation                        : 5000
MaxItemsPerThrottledOperationWarningLevel            : 3000
MaxItemsPerThrottledOperationOverride                : 20000
AllowOMCodeOverrideThrottleSettings                  : True
UnthrottledPrivilegedOperationWindowEnabled          : False
MaxQueryLookupFields                                 : 12
MaxListItemRowStorage                                : 1
MaxUniquePermScopesPerList                           : 50000
DailyStartUnthrottledPrivilegedOperationsHour        : 22
DailyStartUnthrottledPrivilegedOperationsMinute      : 0
DailyUnthrottledPrivilegedOperationsDuration         : 0
CascadeDeleteTimeoutMultiplier                       : 120
CascadeDeleteMaximumItemLimit                        : 1000
AlertsMaximumQuerySet                                : 1000
AlertsEventBatchSize                                 : 0
AlertFlags                                           : 0
DefaultQuotaTemplate                                 : 
SendUnusedSiteCollectionNotifications                : False
AutomaticallyDeleteUnusedSiteCollections             : False
UnusedSiteNotificationPeriod                         : 90.00:00:00
UnusedSiteNotificationsBeforeDeletion                : 4
FormDigestSettings                                   : Microsoft.SharePoint.Administration.SPFormDigestSettings
RequireContactForSelfServiceSiteCreation             : False
StorageMetricsProcessingDuration                     : 30
EventHandlersEnabled                                 : False
SendLoginCredentialsByEmail                          : True
RightsMask                                           : FullMask
ApplicationPrincipalMaxRights                        : ViewListItems, AddListItems, EditListItems, DeleteListItems, ApproveItems, OpenItems, ViewVers
                                                       ions, DeleteVersions, CancelCheckout, Open, ViewPages, BrowseUserInfo, UseRemoteAPIs
Sites                                                : {}
DataRetrievalProvider                                : Microsoft.SharePoint.Administration.SPDataRetrievalProvider
PresenceEnabled                                      : True
PublicFolderRootUrl                                  : 
AllowContributorsToEditScriptableParts               : False
AllowPartToPartCommunication                         : True
AllowAccessToWebPartCatalog                          : True
AllowedInlineDownloadedMimeTypes                     : {application/directx, application/envoy, application/fractals, application/internet-property-s
                                                       tream...}
MimeMappings                                         : {InfoPath.Document, InfoPath.Document.2, InfoPath.Document.3, InfoPath.Document.4}
BlockedFileExtensions                                : {ade, adp, asa, ashx...}
WebFileExtensions                                    : {ascx, asmx, aspx, jar...}
BrowserFileHandling                                  : Strict
DaysToShowNewIndicator                               : 2
MaximumFileSize                                      : 250
MaximumFileSizePerExtension                          : {[one, 1024]}
OutboundMailServiceInstance                          : 
OutboundMailSenderAddress                            : 
OutboundMailReplyToAddress                           : 
OutboundMailCodePage                                 : 0
OutboundMmsServiceAccount                            : 
OutboundSmsServiceAccount                            : 
IncomingEmailServerAddress                           : 
ExternalUrlZone                                      : 
Policies                                             : {NT AUTHORITY\LOCAL SERVICE}
PolicyRoles                                          : {完全控制, 完整讀取, 拒絕寫入, 拒絕全部}
DefaultTimeZone                                      : -1
InheritDataRetrievalSettings                         : True
RecycleBinEnabled                                    : True
RecycleBinCleanupEnabled                             : True
RecycleBinRetentionPeriod                            : 30
SecondStageRecycleBinQuota                           : 50
OfficialFileUrl                                      : 
OfficialFileName                                     : 
OfficialFileHosts                                    : {}
ScopeExternalConnectionsToSiteSubscriptions          : False
DocumentConversionsEnabled                           : False
DocumentConversionsLoadBalancerUrl                   : 
DocumentConversionsSchedule                          : every 1 minutes between 0 and 59
DocumentConversionsLoadBalancerServerId              : 00000000-0000-0000-0000-000000000000
DocumentConverters                                   : {從 InfoPath 表單轉換成網頁, 從 Word 文件轉換到網頁, 從 XML 轉換成網頁, 從含有巨集的 Word 文件轉換成網頁}
Prefixes                                             : {, sites}
SyndicationEnabled                                   : True
UserDefinedWorkflowsEnabled                          : True
EmailToNoPermissionWorkflowParticipantsEnabled       : True
ExternalWorkflowParticipantsEnabled                  : False
UserDefinedWorkflowMaximumComplexity                 : 7000
AllowDesigner                                        : True
AllowRevertFromTemplate                              : True
AllowMasterPageEditing                               : True
ShowURLStructure                                     : True
RequiredDesignerVersion                              : 15.0.0.0
DesignerDownloadUrl                                  : http://go.microsoft.com/fwlink/?LinkId=328584
AllowCreateDeclarativeWorkflow                       : True
AllowSavePublishDeclarativeWorkflow                  : True
AllowSaveDeclarativeWorkflowAsTemplate               : True
JobDefinitions                                       : {job-workflow-failover, ExpirationProcessing, job-delete-upgrade-eval-sites, SchedulingUnpubli
                                                       sh...}
RunningJobs                                          : {}
JobHistoryEntries                                    : {PowerPivot- 80, PowerPivot- 80, PowerPivot- 80, PowerPivot- 80...}
ForceseekEnabled                                     : True
CrossDomainPhotosEnabled                             : False
UserPhotoImportEnabled                               : False
UserPhotoOnlineImportEnabled                         : False
UserPhotoExpiration                                  : 72
UserPhotoErrorExpiration                             : 6
FileNotFoundPage                                     : 
IsAdministrationWebApplication                       : False
PeoplePickerSettings                                 : Microsoft.SharePoint.Administration.SPPeoplePickerSettings
MetaWeblogEnabled                                    : True
MetaWeblogAuthenticationEnabled                      : False
MasterPageReferenceEnabled                           : True
ClientCallableSettings                               : Microsoft.SharePoint.Administration.SPClientCallableSettings
SiteUpgradeThrottleSettings                          : SPSiteUpgradeThrottleSettings
HttpThrottleSettings                                 : SPHttpThrottleSettings
RequestManagementSettings                            : SPRequestManagementSettings
ServiceApplicationProxyGroup                         : SPServiceApplicationProxyGroup
UseClaimsAuthentication                              : True
EnabledClaimProviders                                : 
DisplayName                                          : PowerPivot- 80
AllowSilverlightPrompt                               : True
BrowserCEIPEnabled                                   : False
AllowAnalyticsCookieForAnonymousUsers                : False
CellStorageWebServiceEnabled                         : True
SiteSubscriptions                                    : {}
DisableCoauthoring                                   : False
RenderingFromMetainfoEnabled                         : True
AllowHighCharacterListFolderNames                    : False
CompatibilityRange                                   : Microsoft.SharePoint.SPCompatibilityRange
AllowSelfServiceUpgradeEvaluation                    : True
UpgradeReminderDelay                                 : 30
UpgradeMaintenanceLink                               : 
ReadOnlyMaintenanceLink                              : 
UserSettingsProvider                                 : Microsoft.SharePoint.Portal.UserProfiles.UserProfileUserSettingsProvider
CellStorageDataCleanupExcludedDocTypes               : 
CellStorageUserDataDeleteIncludedDocTypes            : 
CellStorageUserDataDeleteSizeThreshold               : -1
UpgradeEvalSitesRetentionDays                        : 31
MaxSizeForSelfServiceEvalSiteCreationMB              : 102400
SendSiteUpgradeEmails                                : True
CustomAppErrorLimit                                  : 5000
UserResourceTrackingSettings                         : Microsoft.SharePoint.Administration.SPUserResourceTrackingSettings
UserResourceTrackingSettings2                        : Microsoft.SharePoint.Administration.SPUserResourceTrackingSettings2
AppResourceTrackingSettings                          : Microsoft.SharePoint.Administration.SPAppResourceTrackingSettings
SuiteBarBrandingElementHtml                          : <div class="ms-core-brandingText">SharePoint</div>
DiskSizeRequired                                     : 0
CanSelectForBackup                                   : True
CanSelectForRestore                                  : True
CanRenameOnRestore                                   : True
CanUpgrade                                           : True
IsBackwardsCompatible                                : True
NeedsUpgradeIncludeChildren                          : False
NeedsUpgrade                                         : False
UpgradeContext                                       : Microsoft.SharePoint.Upgrade.SPUpgradeContext
Name                                                 : PowerPivot- 80
Id                                                   : 0dc21731-bfc1-4c51-86aa-80b6bedfb39a
Status                                               : Online
Parent                                               : SPWebService
Version                                              : 11718
Properties                                           : {}
Farm                                                 : SPFarm Name=WIN-2S026UBRQFO_ConfigDB
UpgradedPersistedProperties                          : {}




PS C:\Windows\system32> '


Get-SPWebApplication

#   Create   指定 HostHeader 主機標頭 
$ap = New-SPAuthenticationProvider
$WebAppName = "SPbi29"
$WebAppPort =  80
$WebAppHostHeader = "bi29.csd.syscom"
$Url =  "http://bi29.csd.syscom"
$WebAppAppPool = "biAppPool"
$WebAppAppPoolAccount =  "CSD\spfarmadmin"
$WebAppDatabaseName =  "SPcontent_bi29"
$WebAppDatabaseServer= "2013Bi"
New-SPWebApplication -Name $WebAppName -Port $WebAppPort  -URL $Url -HostHeader  $WebAppHostHeader `
-ApplicationPool $WebAppAppPool -ApplicationPoolAccount (Get-SPManagedAccount $WebAppAppPoolAccount) `
-DatabaseName $WebAppDatabaseName -DatabaseServer $WebAppDatabaseServer

#   mar.14.2016
$ap = New-SPAuthenticationProvider
$WebAppName = "aa_mysite"
$WebAppPort =  '80'
$WebAppHostHeader = "aa.pmocsd.syscom.com"
$Url =  "http://aa.pmocsd.syscom.com"
$WebAppAppPool = "MySitePool"
$WebAppAppPoolAccount =  "PMOCSD\infra1"
$WebAppDatabaseServer= "SPFarmSQL"
$WebAppDatabaseName =  "aaWADB"

$t1=get-date; 
New-SPWebApplication -Name $WebAppName -Port $WebAppPort  -URL $Url -HostHeader  $WebAppHostHeader `
-ApplicationPool $WebAppAppPool -ApplicationPoolAccount (Get-SPManagedAccount $WebAppAppPoolAccount) -AuthenticationProvider $ap `
-DatabaseName $WebAppDatabaseName -DatabaseServer $WebAppDatabaseServer
$t2=get-date; ($t2-$t1)

II

$name      ='aa_mysite'
$url       ='http://aa.pmocsd.syscom.com'
$appPool   ='MySitePool'
$appAccount='PMOCSD\infra1'
$appAccountPassword ='p@ssw0rd'
$dbServer  ='SPFarmSQL'
$dbName    ='aaWADB'

$appPoolManagedAccount = Get-SPManagedAccount $appAccount -ErrorAction:SilentlyContinue

$ap = New-SPAuthenticationProvider
$t1=get-date
New-SPWebApplication -Name $name -ApplicationPool $appPool -ApplicationPoolAccount $appPoolManagedAccount `
-URL $url -DatabaseServer $dbServer -DatabaseName $dbName -AuthenticationProvider $ap
$t2=get-date; ($t2-$t1)


mar.14.2016  end 
New-SPWebApplication -Name "Contoso Internet Site" -Port 443 -HostHeader sharepoint.contoso.com 
-URL "https://www.contoso.com" 
-ApplicationPool "ContosoAppPool" -ApplicationPoolAccount (Get-SPManagedAccount "DOMAIN\jdoe") -AuthenticationProvider $ap 
-SecureSocketsLayer



# create II  第一組

$name      ='OneDriveForBusiness'
$url       ='http://pp.tempcsd.syscom'
$url       ='http://pp.pmocsd.syscom.com'

$appPool   ='BIApplicationPool'
$appAccount='PMOCSD\spService'
$appAccount='TempCSD\spService'
$appAccountPassword ='p@ssw0rd'
$dbServer  ='SPFarmSQL'
$dbName    ='OneDriveWADB'

$appPoolManagedAccount = Get-SPManagedAccount $appAccount -ErrorAction:SilentlyContinue
#$appPoolManagedAccount = Get-SPManagedAccount 'ttttee' -ErrorAction:SilentlyContinue

    if($appPoolManagedAccount -eq $null)
    {
        $appPoolAccount = New-Object System.Management.Automation.PSCredential ($appAccount, $appAccountPassword)
        $appPoolManagedAccount = New-SPManagedAccount $appPoolAccount
    }

Get-SPWebApplication;'Null'

$ap = New-SPAuthenticationProvider
$t1=get-date
New-SPWebApplication -Name $name -ApplicationPool $appPool -ApplicationPoolAccount $appPoolManagedAccount `
-URL $url -DatabaseServer $dbServer -DatabaseName $dbName -AuthenticationProvider $ap
$t2=get-date
($t2-$t1)

iisreset

UI:  網站集合清單   http://localhost:2013/_admin/SiteCollections.aspx?ReturnSelectionPage=/applications.aspx
IE:  此時本機仍不行連入

# use cmd - regedit  if spfarm , infra  can not into http://pp.tempcsd.syscom
解決方法
1. Click Start, click Run, type regedit, and then click OK.
2. In Registry Editor, locate and then click the following registry key:    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa
3. Right-click Lsa, point to New, and then click DWORD Value.
4. Type DisableLoopbackCheck, and then press ENTER.
5. Right-click DisableLoopbackCheck, and then click Modify.
6. In the Value data box, type 1, and then click OK.
7. Quit Registry Editor, and then restart your computer.


New-SPSite -Url $url  -OwnerEmail 'infra1@pmocsd.syscom.com' -OwnerAlias 'pmoCSD\spadmin' `
-SecondaryOwnerAlias 'pmoCSD\infra1' -Template 'SPS#0' -Name  ' onedriveforubusiness create by Mar.11.2018'



'
DisplayName                    Url                                               
-----------                    ---                                               
SPbi29                         http://bi29.csd.syscom/  

inetmgr  =>  applicationPool : biAppPool , web site : SPbi29
'

# Drop 

$urlaa='http://aa.pmocsd.syscom.com/'
$urlpp='http://pp.pmocsd.syscom.com/'

$t1=get-date
Remove-SPWebApplication $urlaa -Confirm:$false -DeleteIISSite -RemoveContentDatabases
$t2=get-date
($t2-$t1).TotalMinutes  #3mins


Get-SPServiceApplicationPool

#-----------------------------------
## 526 upload  +  download + delete  file to sharepoint 
#-----------------------------------
Scenario 1: Uploading Files to SharePoint on the SharePoint Server

Here’s a quick example of how to upload a document on a SharePoint server using the SharePoint PowerShell module which uses the SharePoint Object Model.

# Set the variables 
$WebURL = “http://portal.contoso.com/sites/stuff” 
$DocLibName = “Docs” 
$FilePath = “C:\Docs\stuff\Secret Sauce.docx” 

# Get a variable that points to the folder 
$Web = Get-SPWeb $WebURL 
$List = $Web.GetFolder($DocLibName) 
$Files = $List.Files

# Get just the name of the file from the whole path 
$FileName = $FilePath.Substring($FilePath.LastIndexOf("\")+1)

# Load the file into a variable 
$File= Get-ChildItem $FilePath

# Upload it to SharePoint 
$Files.Add($DocLibName +"/" + $FileName,$File.OpenRead(),$false) 
$web.Dispose()

In the case we use the Add member of the SPFileCollection class. It has a few overloads, so check them out, there might be one that better fits what you’re trying to do. 

Scenario 2: Uploading Files to SharePoint from a Remote Machine

Since we can’t use the object model to upload files remotely we have to go about it a different way. I use the WebClient object, though there might be other ways. Here’s an example:

$destination = "http://odsp.pmocsd.syscom.com/personal/infra2” 
$securePasssword = ConvertTo-SecureString "p@ssw0rd" -AsPlainText -Force 
$credentials = New-Object System.Management.Automation.PSCredential ("PMOCSD\infra2", $securePasssword)


$webclient = New-Object System.Net.WebClient 
$webclient.Credentials = $credentials 
$webclient.UploadFile($destination + "/" + $fileN.Name, "PUT", $fileN.FullName)

ssms
$webclient |gm 
$webclient.UploadFile('http://odsp.pmocsd.syscom.com/personal/infra2/Documents/1M.txt', "PUT", 'H:\temp\1M.txt')
$webclient.UploadFile('http://odsp.pmocsd.syscom.com/personal/infra2/Documents/4k.txt', "PUT", 'H:\temp\4k.txt')



$WebClient.DownloadFile( 'http://odsp.pmocsd.syscom.com/personal/infra2/Documents/4k.txt', 'c:\temp\K4T.txt' )



#  Delete sharepoint file 


 $url='http://odsp.pmocsd.syscom.com/personal/administrator'
 $url='http://odsp.pmocsd.syscom.com/personal/infra2'

  $sweb=get-spweb $url
  #$sweb.Lists |select title
  $slists = $sweb.Lists["文件"]; #$slists
  $sf= $slists.Items | ? name  -like '4*.txt'  # $slists.Items |select name  
  #$sf |select name
  $sf.Delete()



# Set the variables 
$destination = "http://portal.contoso.com/sites/stuff/Docs” 
$File = get-childitem “C:\Docs\stuff\Secret Sauce.docx”

# Since we’re doing this remotely, we need to authenticate 
$securePasssword = ConvertTo-SecureString "pass@word1" -AsPlainText -Force 
$credentials = New-Object System.Management.Automation.PSCredential ("contoso\johnsmith", $securePasssword)

# Upload the file 
$webclient = New-Object System.Net.WebClient 
$webclient.Credentials = $credentials 
$webclient.UploadFile($destination + "/" + $File.Name, "PUT", $File.FullName)




#--------------------------------------------------------
#     定義管理的路徑  SPManagedPath
#--------------------------------------------------------

傳回符合所提供之 Web 應用程式、網站集合或所有 HostHeader 網站集合之身分識別的 SharePoint 受管理路徑

get-spwebapplication
Get-SPManagedPath  -WebApplication   http://pp.pmocsd.syscom.com/

 "SP"
New-SPManagedPath "Teams" -WebApplication "http://somesite"



#--------------------------------------------------------
#    Site Collection
#--------------------------------------------------------
get-command *spsite*
Get-SPWebTemplate


{


##  
Get-SPSite
$url="http://bi29.csd.syscom/"
get-spsite | ? url -EQ  $url  |select * 


##  create 


$name = "BICenterSite#0  商務智慧中心"
$Url =  "http://pp.pmocsd.syscom.com"

#$Language  = "1033"
$template= "BICenterSite#0"
$Description ="bi29.csd.syscom  Sep.11.2014  BICenterSite 商務智慧中心 "
#$SecondaryOwnerAlias = "CSD\SPFarmAdmin"


New-SPSite -Url $url -OwnerEmail 'infra1@pmocsd.syscom.com' -OwnerAlias 'PMOCSD\infra1' `
-SecondaryOwnerAlias 'PMOCSD\infra2' -Template 'SPS#0' -Name  ' onedriveforubusiness create by Mar.11.2018'


New-SPSite -Url $url -OwnerEmail 'infra1@pmocsd.syscom.com' -OwnerAlias 'PMOCSD\infra1' `
-SecondaryOwnerAlias 'PMOCSD\infra2' -Template 'SPSMSITEHOST#0' -Name  ' SPSMSITEHOST#0 create by Mar.14.2018'




New-SPWeb –url $Url -name $name  -template $template –AddToTopNav –AddToQuickLaunch -UseParentTopNav -Description $Description
#New-SPWeb –url http://sp.csd.syscom/sites/SPSMSITE -name "SPSMSITE Site" -template SPSMSITE#0 –AddToTopNav –UniquePermissions -UseParentTopNav

## remove
Remove-SPSite -Identity $url -GradualDelete -Confirm:$False



}



'
PS C:\Windows\system32> get-spsite $url |select *

ApplicationRightsMask                           : FullMask
HasAppPrincipalContext                          : False
ID                                              : 20188211-6306-43db-a8c4-ab41bae2afd0
SystemAccount                                   : SHAREPOINT\system
Owner                                           : i:0#.w|tempcsd\spfarm
SecondaryContact                                : i:0#.w|tempcsd\infra1
GlobalPermMask                                  : FullMask
FileNotFoundUrl                                 : 
IISAllowsAnonymous                              : False
Protocol                                        : http:
HostHeaderIsSiteName                            : False
HostName                                        : pp.tempcsd.syscom
Port                                            : 80
ServerRelativeUrl                               : /
UpgradeRedirectUri                              : http://pp.tempcsd.syscom/
Zone                                            : Default
Url                                             : http://pp.tempcsd.syscom
PrimaryUri                                      : http://pp.tempcsd.syscom/
UserCodeEnabled                                 : False
Impersonating                                   : False
Audit                                           : Microsoft.SharePoint.SPAudit
TrimAuditLog                                    : False
AuditLogTrimmingCallout                         : 
AuditLogTrimmingRetention                       : 0
ScriptSafeDomains                               : {youtube.com, youtube-nocookie.com, player.vimeo.com, bing.com...}
ScriptSafePages                                 : {WopiFrame.aspx}
AllowExternalEmbedding                          : AllowedDomains
AllWebs                                         : {PowerPivot Site 1140}
Features                                        : {695b6570-a48b-4a8e-8ea5-26ea7fc1d162, 10f73b29-5779-46b3-85a8-4817a6e9a6c2, ca7bd552-1
                                                  0b1-4563-85b9-5ed1d39c962a, fde5d850-671e-4143-950a-87b473922dc7...}
UserCustomActions                               : {}
PortalUrl                                       : 
PortalName                                      : 
LastContentModifiedDate                         : 2015/9/8 上午 02:34:30
LastSecurityModifiedDate                        : 2015/9/8 上午 02:15:54
Upgrading                                       : False
UpgradeReminderDate                             : 1899/12/30 上午 12:00:00
AllowSelfServiceUpgrade                         : True
InheritAllowSelfServiceUpgradeSetting           : True
AllowSelfServiceUpgradeEvaluation               : True
InheritAllowSelfServiceUpgradeEvaluationSetting : True
MaintenanceMode                                 : False
Archived                                        : False
UserIsSiteAdminInSystem                         : True
HideSystemStatusBar                             : False
UpgradeInfo                                     : 
SchemaVersion                                   : 15.0.35.0
CompatibilityLevel                              : 15
IsEvalSite                                      : False
EvalSiteId                                      : 00000000-0000-0000-0000-000000000000
SourceSiteId                                    : 00000000-0000-0000-0000-000000000000
ExpirationDate                                  : 9999/12/31 下午 11:59:59
CurrentResourceUsage                            : 0
AverageResourceUsage                            : 0
Cache                                           : Microsoft.SharePoint.Administration.SPSiteCollectionPropertyCache
BrowserDocumentsEnabled                         : True
CatchAccessDeniedException                      : False
AllowUnsafeUpdates                              : True
UserToken                                       : Microsoft.SharePoint.SPUserToken
IsPaired                                        : False
SearchServiceInstance                           : 
WebApplication                                  : SPWebApplication Name=PowerPivot- 80
SiteSubscription                                : 
ContentDatabase                                 : SPContentDatabase Name=PowerPivotWebApplicationDB
Quota                                           : Microsoft.SharePoint.Administration.SPQuota
RootWeb                                         : PowerPivot Site 1140
LockIssue                                       : 
Usage                                           : Microsoft.SharePoint.SPSite+UsageInfo
UIVersionConfigurationEnabled                   : False
ReadLocked                                      : False
IsReadLocked                                    : False
WriteLocked                                     : False
ReadOnly                                        : False
ShareByLinkEnabled                              : False
ShareByEmailEnabled                             : False
ResourceQuotaWarningNotificationSent            : False
ResourceQuotaExceededNotificationSent           : False
ResourceQuotaExceeded                           : False
WarningNotificationSent                         : False
UserAccountDirectoryPath                        : 
SyndicationEnabled                              : True
AllowRssFeeds                                   : True
DenyPermissionsMask                             : EmptyMask
CertificationDate                               : 2015/9/8 上午 01:59:27
DeadWebNotificationCount                        : 0
RecycleBin                                      : {}
CurrentChangeToken                              : 1;1;20188211-6306-43db-a8c4-ab41bae2afd0;635772764694170000;784
WorkflowManager                                 : Microsoft.SharePoint.Workflow.SPWorkflowManager
FeatureDefinitions                              : {}
Solutions                                       : {}
EventReceivers                                  : {AddedEventHandler, UpdatedEventHandler, }
AdministrationSiteType                          : None
AllowDesigner                                   : True
AllowRevertFromTemplate                         : False
AllowMasterPageEditing                          : False
ShowURLStructure                                : False
RequiredDesignerVersion                         : 15.0.0.0
AllowCreateDeclarativeWorkflow                  : True
AllowSavePublishDeclarativeWorkflow             : True
AllowSaveDeclarativeWorkflowAsTemplate          : True
OutgoingEmailAddress                            : 
UserDefinedWorkflowsEnabled                     : True
CanUpgrade                                      : True
NeedsUpgrade                                    : False
UpgradeContext                                  : Microsoft.SharePoint.Upgrade.SPUpgradeContext
'




#--------------------------------------------------------
# spWeb
#--------------------------------------------------------

$name = "BICenterSite#0  商務智慧中心"
$Url =  "http://sp.csd.syscom/BICenterSite-0"
$template= "BICenterSite#0"
$Description ="sp   BICenterSite#0  商務智慧中心   May.31.2013"
New-SPWeb –url $Url -name $name  -template $template –AddToTopNav –AddToQuickLaunch -UseParentTopNav -Description $Description
#Remove-SPWeb $Url -Confirm:$False






#-----------------------------------
##   sets the HostHeader URL for the Extranet zone and 啟用匿名存取.  cls;gh Set-SPWebApplication -full
#-----------------------------------

Get-SPWebApplication $Url  | Set-SPWebApplication –Zone "Extranet" –HostHeader "http://ming.csd.syscom" - AllowAnonymousAccess

#-----------------------------------
##   $WPSS2=Get-SPWebApplication  $WPSS2 |gm
#-----------------------------------
 $url="http://ss2.csd.syscom/"
 $WPSS2=Get-SPWebApplication   $url ;

#-----------------------------------
##   reconfigure Maximum upload Size for Default Web application
#-----------------------------------
$Url =  "http://ss2.csd.syscom"
$webapplication=Get-SPWebApplication $Url
$webapplication.MaximumFileSize=2047
$webapplication.Update()
#-----------------------------------
##  reconfigure .DefaultTimeZone
#-----------------------------------
$Url =  "http://sp.csd.syscom"
$WPSp=Get-SPWebApplication $Url
$WPSp.DefaultTimeZone;=75;DefaultTimeZone   : -1 ,75(Taipei) , 10(US and Canada)
$WPSp.Update()
$Timezone=$WPSp.DefaultTimeZone;$Timezone |gm
#-----------------------------------
##  AllowedInlineDownloadedMimeTypes   : PDF
#-----------------------------------
$Url ="http://ss2.csd.syscom"
$wa= Get-SPWebApplication $Url
If ($wa.AllowedInlineDownloadedMimeTypes -notcontains "application/pdf")
{
  Write-Host -ForegroundColor White "Adding PDF MIME Type..."
  $wa.AllowedInlineDownloadedMimeTypes.Add("application/pdf")
  $wa.Update()
  Write-Host -ForegroundColor White "Added and saved."
} Else {
  Write-Host -ForegroundColor White "PDF MIME type is already added."
}

##
$wa.AllowedInlineDownloadedMimeTypes.remove("application/pdf")
$wa.Update()


#-----------------------------------
##  FAQ
#-----------------------------------
Get-SPSite : 位於 http://localhost:32843/SecurityTokenServiceApplication/securitytoken.svc 的 HTTP 
服務無法使用。這可能是因為服務過於忙碌，或是在接聽指定的位址時未找到端點。請確認位址是正確的，並稍後再次嘗試存取服務。
solution :
inetmgr > applicaitonPool  >  SecurityTokenServiceApplication  > advance Setup > identify >new user/ restart ()



