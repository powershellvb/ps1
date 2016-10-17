﻿

C:\Users\administrator.CSD\SkyDrive\download\ps1\Sqlps11_alert.ps1
PowerShell | Windows PowerShell ISE.
(2). Import the SQLPS module and create a new SMO Server object, as follows:
#import SQL Server module
Import-Module SQLPS -DisableNameChecking
#replace this with your instance name
$instanceName = "KERRIGAN"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
#this is similar to an sp_configure TSQL command
$server.Configuration.DatabaseMailEnabled.ConfigValue = 1
$server.Configuration.Alter()
$server.Refresh()
$accountName = "DBMail"
$accountDescription = "QUERYWORKS Database Mail"
$displayName = "QUERYWORKS mail"
$emailAddress = "dbmail@queryworks.local"
$replyToAddress = "dbmail@queryworks.local"
$mailServerAddress = "mail.queryworks.local"
$account = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Mail.MailAccount -ArgumentList $server.Mail, $accountName,
$accountDescription, $displayName, $emailAddress
$account.ReplyToAddress = $replyToAddress
$account.Create()
1. Open SQL Server Management Studio.
2. Expand the Management node.
3. Right-click on Database Mail and choose Configure Database Mail.
#was the server name, we need to change this to the
#appropriate mail server
$mailserver = $account.MailServers[$instanceName]
$mailserver.Rename($mailServerAddress)
$mailserver.Alter()
#default SMTP authentication is Anonymous Authentication
#set propert authentication
$mailserver.SetAccount("dbmail@queryworks.local", "some password")
$mailserver.Port = 25
$mailserver.Alter()
#create a profile
$profileName = "DB Mail Profile"
$profileDescription= "DB Mail Description"
if($mailProfile)
{
$mailProfile.Drop()
}
$profileName, $profileDescription
$mailProfile.Create()
$mailProfile.Refresh()
2. Visually check the Manage Existing Profile page. Notice that, apart from the name and description, the window is still fairly empty.
#add account to the profile
$mailProfile.AddAccount($accountName, 0)
$mailProfile.AddPrincipal('public', 1)
$mailProfile.Alter()
1. Go back to the Manage Profiles and Accounts window, but this time selectView, change, or delete an existing profile.
2. Visually check the Manage Profile Security page. Notice the default profile that has been saved.
(15). Add the following script and run:
#link this mail profile to SQL Server Agent
$server.JobServer.AgentMailType = 'DatabaseMail'
$server.JobServer.DatabaseMailProfile = $profileName
$server.JobServer.Alter()
#restart SQL Server Agent
$managedComputer = New-Object 'Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer' $instanceName
$servicename = "SQLSERVERAGENT"
$service = $managedComputer.Services[$servicename]
$service.Stop()
$service.Start()
(16). Check settings from Management Studio:
1. Right-click on SQL Server Agent and go to Properties.
2. Click on Alert System from the left-hand pane.
Test E-mail, as shown in the following screenshot:
##--adding
(1. Open the PowerShell console by going to Start | Accessories | Windows
PowerShell | Windows PowerShell ISE.

(2. Import the SQLPS module and create a new SMO Server object, as follows: 
#import SQL Server module
Import-Module SQLPS -DisableNameChecking


#replace this with your instance name
$instanceName = "sp2013"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

(3. Add the following script and run:
$jobserver = $server.JobServer

#for purposes of our exercise, we will drop this
#alert if it already exists
$alertname = "Test Alert"
$alert = $jobserver.Alerts[$alertname]
{
$alert.Drop()
}
#accepts a JobServer and an alert name
$alert = New-Object Microsoft.SqlServer.Management.Smo.Agent.Alert $jobserver, "Test Alert"
$alert.Severity = 10
$alert.EventDescriptionKeyword = "failed"
#Set notification message
$alert.NotificationMessage = "This is a test alert, dont worry"
$alert.Create()
or thresholds reached by the instances. 
If you navigate to SQL Server Agent and expand Alerts, you should see all the alerts set up in your instance' 
$jobserver = $server.JobServer
$jobname ="Test Job"
$job = $jobserver.Jobs[$jobname]
$job.Start()
#sleep to wait for job to finish
#check last run date
Start-Sleep-s1
$job.Refresh()
$job.LastRunDate
物件
此物件為要監視的效能區域。
計數器
計數器是要監視之區域的屬性。
執行個體
SQL Server 執行個體可為要監視的屬性定義特定的執行個體 (如果有的話)。
如果是計數器和值則發出警示
警示的臨界值和產生警示的行為。 臨界值是一個數值。 此行為是下列其中一項：低於、變成等於 或 高於在 [值] 中指定的數值。 [值] 是一個描述效能行況計數器的數值。 例如，若要設定警示在效能物件 SQLServer:Locks 的 Lock Wait Time 超過 30 分鐘時產生，您就必須選擇 [高於]，並指定 30 為[值]。
至於另一個範例，您可以指定效能物件 SQLServer:Transactions 在 tempdb 中的可用空間低於 1000 KB 時發出警示。 若要進行此設定，您必須選擇計數器 Free space in tempdb (KB)、低於，並在 [值] 中指定 1000。