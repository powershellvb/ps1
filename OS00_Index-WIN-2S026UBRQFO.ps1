﻿<#
email backup

$ps1fS=gi C:\Users\administrator.CSD\SkyDrive\download\PS1\OS00_Index.ps1
$ps1fS=gi C:\Users\Chao_Ming\OneDrive\download\PS1\OS00_Index.ps1  #s21
$ps1fS=gi C:\Users\Administrator\OneDrive\download\PS1\OS00_Index.ps1

foreach ($ps1f in $ps1fS)
{
    start-sleep 1
    $ps1fname=$ps1f.name
    $ps1fFullname=$ps1f.FullName 
    $ps1flastwritetime=$ps1f.LastWriteTime
    $getdagte= get-date -format yyyyMMdd
    $ps1length=$ps1f.Length

    Send-MailMessage -SmtpServer  '172.16.200.27'  -To 'a0921887912@gmail.com' -from 'a0921887912@gmail.com' `
    -attachment $ps1fFullname  -Subject "ps1source  -- $getdagte      --        $ps1fname       --   $ps1flastwritetime -- $ps1length "  -Body "  ps1source from:me $ps1fname   " 
}

$str=get-date -Format yyyyMMdd
$f33mydata='\\172.16.220.33\f$\mydataII\pS1_'+$str
start-sleep 5

Copy-Item -Path C:\onenote_20150528\ -Destination C:\Users\administrator.CSD\SkyDrive\ –Recurse -Force

Copy-Item -Path C:\onenote_20150528\ -Destination \\172.16.220.33\f$\mydataII –Recurse -Force

Copy-Item -Path C:\Users\administrator.CSD\SkyDrive\download\PS1 -Destination $f33mydata –Recurse -Force
edit at IBM t61  Aug.06.2015 
pwd: p@ssw0rd  ; pass@word1
SQL2014X	172.16.220.61	192.168.112.129
W2K8R2-2013	10.1.51.52	    NULL
2016BI	    172.16.220.34	192.168.112.123
PMD2016   	172.16.220.33	192.168.112.144
SP2013WFE	172.16.220.216	192.168.112.115 
tempcsd\administrator  p*******s s*****@***4  
PMD	        172.16.201.147	192.168.112.55
('OS01_General'     N'pipeline,function,workflow, snap-in ,snapin ',N'profile ,math ,string ,Time ,random ,variable ,array,gps')

('OS02_performance'          ,N'Powershell start',N'powershell',Null)
('OS02_01_diskIO'            ,N'Powershell start',N'powershell',Null)
('OS02_03_Sharepoint_SQL'    ,N'counter list for SQL',N'powershell',Null)
('OS02_04_Alwayson'          ,N'Alwayson',N'powershell',Null)
('OS02_04_SSAS'              ,N'Alwayson',N'SSAS performance counter',Null)

('OS03_SendMail'             ,N'send Mail, monitor ,',N'powershell',Null)
('OS04_firewall'             ,N'create firewall',N'powershell',Null)
('OS05_Job'                  ,N'job , schedule task',N'job , scheduletask , Event',Null)
('OS06_remote'               ,N'enabling,disabling, session',N'powershell',Null)
('OS07_file'                 ,N'Powershell start',N'powershell','mingbackup','')
('OS08_System'               ,N'IIS , Server manage, HyperV, Network,DNS',N'WmiObject',enable powershell_ise,)
('OS09_modules'              ,N'type,import ,reload, write, check ',N'powershell',Null)
('OS10_AD'                   ,N'installation AD, Account ,Group policy ,Domain Controller ',N'AD ',Null)
('OS11_UC'                   ,N'Exchange ,Lync , Office365 ,sharepoint Online',N'exchagne,Lync ',Null)
('OS12_cloud'                ,N'Azure  install, connection, ',N'cloud ',Null)
('OS13_SC'                   ,N'SystemCenter ',N'cloud ',Null)
('OS14_Vendor'               ,N'VMWare ,Citrix ,Cisco ,Quest ',N'cloud ',Null)
('OS15_cluster'              ,N'cluster , ',N' ',Null)
('SQLPS01_alwayson'          ,N'Powershell start','powershell',NULL)
('SQLPS02_Sqlconfiguration'  ,N'filegroup ,index fragmentation ,job' ,'operator','powershell','Partition')
('SQLPS03_Invoke'            ,N'Powershell start','powershell',NULL)
('SQLPS04_extendedevent'     ,N'Powershell start','powershell',NULL)
('SQLPS05_DMV'               ,N'Powershell start','session',counter)
('SQLPS05_01_DMV_OSPerf'     ,N'Powershell start','powershell',N'')
('SQLPS05_02_DMV_Transcation',N'lock ,block, deadlock','powershell',N'')  
('SQLPS05_03_LISTALL'        ,N'lock ,block, deadlock','powershell',N'') 
('SQLPS06_BCP'               ,N'BCP','powershell',NULL)
('SQLPS07_General'           ,N'advnaced administrator Tasks , event alert ,',N'EXEC (@SQL)','Control-of-Flow Language')
('SQLPS08_Inventory'         ,N'Inventory','powershell',NULL)
('SQLPS09_replication'       ,NULL,'powershell',NULL)
('Sqlps09_01_DGPA'           ,for DGPA Project,'powershell',NULL)
('SQLPS10_storedprocedure'   ,NULL,'powershell',NULL)
('SQLPS11_alert'             ,N'alert,database Mail,',N'DDL Trigger',NULL)

('SQLPS12_security'           NULL,'security ,Aduit',NULL)
('Sqlps12_01_sp_help_revlogin'','NULL,'security ,Aduit',NULL)
('SQLPS13_TDE'               ,NULL,'powershell',NULL)
('SQLPS14_backupRestore'     ,N'fn_dblog',N'EXEC (@SQL)',NULL)
('SQLPS15_Mirroring'         ,N'Mirroring','powershell',NULL)
('SQLPS16_ResourceManager'   ,NULL,'powershell',NULL)
('SQLPS17_triggers'          ,'DML Trigger','powershell',NULL)
('SQLPS18_Profiler'          ,N'change tacking,trace,distribut Replay',N'change tacking,trace,',NULL)
('SQLPS19_Agent'             ,NULL,'powershell',NULL)
('SQLPS20_policy'            ,N'PBM','powershell',NULL)
('SQLPS21_BI'                ,N'SSRS ,SSAS ,SSIS ',N'checklists',NULL)
#01  Add-WindowsFeature PowerShell-ISE
#02  74 enable winrm & configuation
#03  109  get systeminfo
#04  139  get Disk
#05  173  get install product
#06  185  get services 
#07 197   get firewall rule 
#08 230　get SQL master_files
#09 246  　get SQL version
#10 269  　get SQL Job
#11  291 　get SQL databaseinfo
#12 312 　get SQL  serverinfo
#13 333 　get SQL backup 
#14 360  　get SQL SSIS  packages 
#15  　get Host performance
#16  　get SQL create script


# 20  74  check import File (ex:Family2010821X)  所有檔案是否已存放在 FamilyPhoto  之中了
# 284     delelte  Hidden   Thumbs.db
# 296     ONOFF=2 之處理
# 408    update ONOFF = 5 手動, filelength=0  ,then delete physical file
# 587     人工排除 重覆 
# 825     compare two folder  &　F1 copy to F2
powershell_ise  \\172.16.220.29\c$\Users\administrator.CSD\oneDrive\download\ps1\OS01_General.ps1
{ 
# 1   88  Enable Powershell ISE  & telnet
# 2   150  math
#11   750 PSSnapin  vs modules
#17  900  Group item find out count*
#(1777) NoNewline or next line
#  1777 expression  @{Name="Kbytes";Expression={$_.Length / 1Kb}} 
# 2         find right counter
# 3         accessing the counter' data  Port : 445
# 4   remote icm +  scriptblok + pararmeter  PowerShell DEEP DIVES ,port 445  p39
# 5    200  Using jobs for long-running tasks  icm -Asjob
# 6         Collecting and saving remote performance data to disk in a BLG file  PowerShell DEEP DIVES p41  ;Export-Counter
# 7    250  Import-Counter   Manipulating stored performance data from a file
# 8    300  real  Average
# 9    350  Get-AvGCPULoad.ps1   PowerShell DEEP DIVES P48
# 9-2  350  Get-AvgGlobalLoad.ps1   PowerShell DEEP DIVES P48
# 10        常用效能計算器 
# 11        performance  Get-Counter  perfmon.exe
# 12        re-log existing data  http://technet.microsoft.com/en-us/library/hh849683.aspx
# 13        PerformanceCounterSampleSet
# 14  550   disk I/0  sample
# 15 600  disk I/0  sample
# 16 700  performance set list
# 17  750 $using parameter pass to remote  -AsJob 
# 20         Using Format Commands to Change Output View  
#     1072   Missing SQL Server Performance Counters
#  268  remote job counter
#  351  os Memory  PCR
#  435  SQL　　 PCR
#  457  disk　　PCR
#  1 150  SQLServer:Availability Replica  PCR
#  2 200  SQLServer:Database Replica      PCR
#  3 200  SQLServer:Database              PCR
#  function  
#  function PCRTwoNode 
# 02  120  Scheduled Tasks  
# 03  250  New-ScheduledTaskAction
# 04  300  ScheduledTaskTrigger 
# 05  300  Register-ScheduledTask
# 06  400  schtasks.exe create  ScheduledTask 
#    x     time-based trigger vs Event-based triggers
# 07  500  Managing failover clusters with scheduled tasks
# 08  500  example   scheTest.ps1  
# 09  566  JOB CMDLET  
# 10  630  Get-eventlogs
# 11  700  new  & clear & remove  & write-log
# 12  760  Get-WinEvent
# 13  800  wevtutil 
#>}
# 2 Enable-PSRemoting  Port 445, 5985
# 3   115   Creating a remote Windows PowerShell session  pssession
# 4  captures output from the remote Windows PowerShell session, as well as outputfrom the local session
# 5  Running a single Windows PowerShell command
# 6  驗證配置與 Kerberos 不同，或是用戶端電腦沒有加入網域， 到 TrustedHosts 組態設定中。
# 7  get all member machine info
# 8  Test-Connection
# 9  250   Get all computername pararmeter 
# 10 250  remote create scheuletasks 
# 310   turn on Winrm using AD Group Policy Editor
# 460  gwmi firewall port
#>}

{<#
#  50 out-file
#  66 Using Format Commands to Change Output View
#  90 PowerShell Script to save System, Application, Security event viewer logs from various servers into a CSV file
#  200  mail all ps1 source to my Gmail 
#  200  Get disk FreeSpace & Size
#  212  compare two folder then copy difference
#  255  copy jpg * to folder by yyyyMMdd
#  300  merge two folder then copy difference by LastWriteTime
#  338  C:\PerfLogs\mingbackup.ps1
#  557  Backup Ming data to LOG @database
#  599 edit save  to file
#  613  remove folder if no any file
#  752  compare 2 Folder result to file
#  1006  save to excel xls xlsx csv export-csv
#  1077  ConvertTo-Csv   ConvertFrom-Csv
#  1106  Import-Csv  ipcsv
#  1129   foreach string  to CSV 
# 1175    save folder data to csv (inclue directory and file )
# 1292  CSV to excel  xls  xlsx
# 1309   CSV to sql table 
#  1397  photo  CSV to sql table   + folderlocation
#  1535  Get filePhotoLists  copy jpg to filephotopath ( familyPhoto) for SQL
#  1851  Familyphoto all folder properties to DB  FolderPhotoGroupS Table   
#  1873  Explore Structure of an XML Document
#  2104  excel xlsx  xls    to CSV
#  2153  Get File to Table

#>}
# 02        credential (Non-AD)  pass password
# 03   60   Disk using gwmi
# 03-1 150  10500 Checking disk space usage using gwmi  p133
# 04   200  Stop service with Gwmi & gsv
# 05   200  get BIOS
# 06        Get curent logonserver
# 07        IIS
# 08        Net.WebRequest     ping sp.csd.syscom
# 09  300   Net.Webclient
# 10  350   attempt a connection until it is able to do so
# 11        shows how many bytes a the webpage that you are downloading is
# 12        Gets content from a web page on the Internet
# 13  400   repeart
# 14        get-wmiobject 
# 15        Get computer system and hardware information
# 16  450   Get-ItemProperty   GET regedit value
#  596  Computer Startup shutdown , logon , logoff Scripts
#  620  Execute Powershell and Prompt User to choice 
#  650  Get  Share folder  Path of computer

# 02 55 Get-module -listAvailable  查詢出來可用地 
# 03 80  Get-module -查詢已匯入的模組  以及模組內的指令
# 04 80 import-module-匯入的模組  &移除模組時
# 05 100    尋找模組中的命令  
# 06 110     Get  remove -psdrive   gh get-psdrive -full  Net use * /delete /y
# 07 120     new -psdrive

#  108  Use PowerShell to Deploy a New Active Directory Forest 
#  290  Get-ADDomain
#  310  Get-ADComputer
#  428  NEW-ADOrganizationalUnit
#  523   ADUser 
#   669  Move-ADObject user to OU
#  699  ADGroupMember
#  734 ADAccountPassword
#  747 ADAccount  
#  781  How to configure a firewall for domains and trusts.


#02      Network check 
#03      Get  IP Address
#04  100 get/ Install WindowsFeature  &
#05      install #NET Framework 3.5 功能  
#06      SQL Server 2008 R2 叢集問題驗證失敗 
#07      check   Module  :  can see  FailoverClusters
#08      check   FailoverClusters command
#09      ClusterNode
#10      ClusterOwnerNode  
#11  250 ClusterGroup		
#12  300 ClusterResource  
#13  400 Disk   
#14  400 Get-ClusterAvailableDisk 
#15      Get-ClusterResourceDependency
#16  450 Get-ClusterParameter
#17  500 Get-ClusterNetwork
#18      ClusterAccess
#19  550 SQL Server Agent
#20  600 Get-ClusterLog   Create a log file for all nodes (or a specific a node) in a failover cluster.
#21  600 Get-ClusterLog
#22  600 function Start  SQL2012X   ClusSvc 
#23  700 force a cluster to start without a quorum
#24  750 GET path of File Share Witness
#25  750 Cluster Quorum 
# 01   50  Check Sharepoint software appwiz.cpl
# 02  150  Find Your SharePoint Version
# 03 200 get-PsSnapIn 
# 04 200  $profile
# 05  install  using Powershell
# 06  250 configuration using Powershell
# 07  330  SharePoint Services for OS
# 08  400 IIS Servcies
# 09  440 get-command *get-SP*
# 10  440 伺服器陣列的所有伺服器   status   gh Get-SPServer  -full
# 11  440  get-SPDatabase
# 12  450  Manage services on server  for Sharepoint  SPServiceInstance
# 13  500  服務應用程式集區  Service Application Pool
# 14  547  SP  Service   Application  Get-SPServiceApplication   Proxy
# 15  561  Install and Download SharePoint 2013 prerequisites offline
#     719  Install-SP2013RolesFeatures.ps1
#  1025  install sharepoint at WFE


#  101   create BI Group for SQL 
#  340 Install and Download SharePoint 2013 prerequisites offline  Sp01_installconfg.ps1 Line:561



#>}
#  17  Excel Services cmdlets
# 100    service application  cmdlets
# 128   Business Data Catalog Service Application 
# 188  PerformancePoint Service Application
# 244   Secure Store Service Application
# 324   Visio Graphics Service Application
#>}
#   41  SPFeature
#  142  Get-SPFeature -Limit ALL get 中文名稱
#   1329  Enable-SPFeature
#>}
# (2) 100  sQL Modules and snap-ins:
# (3) 150  Import-Module “sqlps” -DisableNameChecking
# (4) 150  naming parament rules  Development environment
# (5) 200  SQL Server Management Objects (SMO)  p20
# (6) 270  discover SQL-related cmdlets  p22
# (7)   service cmdlet
# (8) 300 SQL server configuration settings   with SQLPath
# (9) 350  Get / Set  configuration settings  with smo
# (10) 400 remote query timeout (s)
# (11) Searching for all database objects save to file  p60
# (12)  500  Creating /Drop /Set a database    with SMO  p67
# (13)  550  Creating /Drop /Set a table       with SMO  p75
# (14)  600  Creating /Drop /Set a VIEW        with SMO  p81
# (15)  650  Creating /Drop /Set a stored procedure with SMO  p85
# (16)  700  Creating /Drop /Set a Trigger     with SMO  p90
# (17)  750  Creating /Drop /Set INDEX         with SMO  p95
#  912  using ConfigurationFile ini install SQL 

#  (02) 117  Get instance information  using SQLPath
#  (03) 255  Get AvailabilityGroups information
#  (04) 300  configuration AlwaysOn with TSQL
#  (05) 600  adding and Managing an Availability Databases
#  5.1  735  adding and Managing an Availability Databases sp2013 and sql2012x : workable
#  5.2  800  adding and Managing an Availability Databases  sp2013wfe DataFile other load  workable
#  (06) 888  remove   add  a secondary replica
#  (07)      Availability Group with powershell   ref 4-(8)
#  8         Join-SqlAvailabilityGroup
#  9         enable AlwaysOn Availability Groups
#  10        Get who is Primary   Switch  SqlAvailabilityGroup
#  11    1100  Test-SqlAvailabilityGroup  with SQLPath
#  11.1  1200 Including User Policies   Test-SqlAvailabilityGroup
#  11.2  # 11.2   alwayson   with SMO 
#  12    1300     1   RegisterAllProvidersIP
#  13  

    http://msdn.microsoft.com/zh-tw/library/hh403386.aspx

#  14   To configure an existing availability group
#  14.1• Add a Secondary Replica to an Availability Group (SQL Server)
	• Remove a Secondary Replica from an Availability Group (SQL Server)
	• Add a Database to an Availability Group (SQL Server)
	• Remove a Secondary Database from an Availability Group (SQL Server)
	• Remove a Primary Database from an Availability Group (SQL Server)
	• Configure the Flexible Failover Policy to Control Conditions for Automatic Failover (AlwaysOn Availability Groups)
#  15 To manage an availability group
	• Configure Backup on Availability Replicas (SQL Server)
#15.2• Perform a Planned Manual Failover of an Availability Group (SQL Server)
#15.3• Perform a Forced Manual Failover of an Availability Group (SQL Server)
	• Remove an Availability Group (SQL Server)
#  16   To manage an availability replica
#16.1• Add a Secondary Replica to an Availability Group (SQL Server)
#16.2	• Join a Secondary Replica to an Availability Group (SQL Server)
#16.3	• Remove a Secondary Replica from an Availability Group (SQL Server)
#16.4	• Change the Availability Mode of an Availability Replica (SQL Server)
#16.5	• Change the Failover Mode of an Availability Replica (SQL Server)
#16.6	• Configure Backup on Availability Replicas (SQL Server)
#16.7	• Configure Read-Only Access on an Availability Replica (SQL Server)
#16.8	• Configure Read-Only Routing for an Availability Group (SQL Server)
#16.9	• Change the Session-Timeout Period for an Availability Replica (SQL Server)
#17  To manage an availability database
	• Add a Database to an Availability Group (SQL Server)
	• Join a Secondary Database to an Availability Group (SQL Server)
	• Remove a Primary Database from an Availability Group (SQL Server)
	• Remove a Secondary Database from an Availability Group (SQL Server)
	• Suspend an Availability Database (SQL Server)
	• Resume an Availability Database (SQL Server)
#18  To monitor an availability group
	• Monitoring of Availability Groups (SQL Server)

#19  To support migrating availability groups to a new WSFC cluster (cross-cluster migration)


	• Change the HADR Cluster Context of Server Instance (SQL Server)
	• Take an Availability Group Offline (SQL Server)

# (20) 1500  how to get  log_send_queue
# (21) 1500 21  what latency got introduced with choosing synchronous availability mode
#  22   1600  alwayson  DMV 
#  23  1650  dmv about alwayson  監視 WSFC 叢集中的可用性群組  Monitoring Availability Groups on the WSFC Cluster
#  24  1650    dmv  監視可用性群組 Groups  :Monitoring Availability Groups
#  25  1710  dmv  監視可用性複本 replicas  Monitoring Availability Replicas
#  26  2010  dmv  監視可用性資料庫  replicas  Monitoring Availability Databases
#  27  2400  dmv  監視可用性群組接聽程式  Monitoring Availability Group Listeners  
#  28 2500  monitor AG wiht SMO
#  29  2555   Monitor availability groups and availability replicas status information using T-SQL


# 02      Creating a filegroup
# 03 130     Adding secondary data files to a filegroup  p.l156 
# 04 200  Moving an index to a different filegroup 
# 05 300  Checking /Reorganizing/rebuilding  index fragmentation  p162
# 06 400  Listing /Creating/scheduling SQL Server job  / list only the failed jobs  p.178
# 07      Adding a SQL Server operator  jp.181
# 08
# 09
# 10
# 11  查詢 SQL Server 的產品版本  version
# 12  修改SQL伺服器名稱2
# 13  Adding a file to a database
# 14  Adding a filegroup with two files to a database
# 15  Adding two log files to a database
# 16  Removing a file from a database
# 17  Moving tempdb to a new location
# 18  Making a filegroup the default
# 19  Adding a Filegroup Using ALTER DATABASE
# 20  回傳 7 今天修改的
# 21  Creating a SQL Server instance object  p29
# 23  modify a job
#  1353    max degree of parallelism  MAXDOP
#  1447    in-memory 



# 1309  CSV to sql table (lost)
#  1397  photo  CSV to sql table   + folderlocation (lost)

#02     Memory used per database
#03  90 The queries that use the most CPU
#04     Finding where a query is used
#05     A simple monitor for  go number
#06     statement concerning isolation  level.
#07     Get All  DMV  and DMF
#08     Identify the 20 slowest queries on your server
#09     找出   Find those missing indexes  sql_server_dmvs_in_active.pdf p.16
#10     找出什麼SQL   正在執行
#11     Who’s doing what and when?
#12     Find a cached plan
#13     Permissions to the DMVs/DMFs
#14     找出 a  Database 讀寫次數   DB_NAME(qt.dbid) = 'ParisDev' 
#15     最久10大 TSQL Top 10 longest-running queries on server
#16     Creating an empty temporary table structure
#17     Extracting the Individual Query from the Parent Query 
#18     Determine query effect via differential between snapshots
#19     找出連接伺服器的使用者，然後傳回每位使用者的工作階段數  session  Max number of concurrent connections   
#20     Finding everyone’s last-run query
#21 530 Amount of space (total, used, and free) in tempdb
#22 545 Total amount of space (data, log, and log used) by database 
#23     Estimating when a job will finish  -5
#24 592 Determining the performance impact of a system upgrade 
#25 685 sys.dm_os_sys_info
#26 700 Finding where your query really spends its time 尋找查詢的真正花費的時間
#27 711    以sys.dm_exec_query_stats動態管理檢視查詢最耗損I/O資源的SQL語法
#28 735  監控是否有I/O延遲的狀況
#29 788   make lock  , deadlock 
#30 800     呈現鎖定與被鎖定間的鏈狀關係
#31 860     查詢某個資料庫內各物件使用記憶體暫存區資源的統計
#32 868  How to discover which locks are currently held
#33 900  How to identify contended resources
#34 934  How to identify contended resources, including SQL query details
#35 966  How to find an idle session with an open transaction
#36 988  What’s being blocked by idle sessions with open transactions
#37 1030 What has been blocked for more than 30 seconds
#38 1100 Listing / killing running/blocking processes using SMO  p128
#39 1111 statusOSPCRALL \ps1\0S02_sets_scenario004.ps1 
#40 1400 連續執行記錄   執行時間總筆數
#   1596  儲存DMV 到 SQL_inventory  perfXXX sample
#   1677 big table sample data  lab


#98   SQL Server Performance     Data Collection
#99   SQL Server Host Performance Data Collection
# 32   Listing 1.2 Find your slowest queries
# 55   Listing 1.3 Find those missing indexes  p.16
# 76   Listing 1.4 Identify what SQL is running now p.17
# 113  Listing 1.5 Quickly find a cached plan  p.19
# 137  Listing 1.6 Missing index details
# 149  Listing 2.1 Restricting output to a given database  p.33
# 164  Listing 2.2 Top 10 longest-running queries on server p.33
# 199  Listing 2.3 Creating a temporary table WHERE 1 = 2
# 210  Listing 2.4 Looping over all databases on a server pattern
# 253  Listing 2.5 Quickly find the most-used cached plans—simple version  p.37
# 273  Listing 2.6 Extracting the Individual Query from the Parent Query
# 296  Listing 2.7 Identify the database of ad hoc queries and stored procedures p.40
# 321  Listing 2.8 Determine query effect via differential between snapshots
# 373  Listing 2.9 Example of building dynamic SQL  p.47
# 398  Listing 2.10 Example of printing the content of large variables p.48
# 437  Listing 3.1 Identifying the most important missing indexes p.62
# 463  Listing 3.2 The most-costly unused indexes p.66
# 518  Listing 3.3 The top high-maintenance indexes  p.70
# 575  Listing 3.4 The most-used indexes  p.73
# 619  Listing 3.5 The most-fragmented indexes p.75
# 659  Listing 3.6 Identifying indexes used by a given routine p.78
# 730  Listing 3.7 The databases with the most missing indexes p.84
# 746  Listing 3.8 Indexes that aren’t used at all p.85
# 781  Listing 3.9 What is the state of your statistics? p.88
# 807  Listing 4.1 How to find a cached plan p.95
# 831  Listing 4.2 Finding where a query is used  p.97
# 858  Listing 4.3 The queries that take the longest time to run p.99
# 890  Listing 4.4 The queries spend the longest time being blocked p.104
# 922  Listing 4.5 The queries that use the most CPU p.106
# 953  Listing 4.6 The queries that use the most I/O p.109
# 979  Listing 4.7 The queries that have been executed the most often p.112
# 1001 Listing 4.8 Finding when a query was last run p.114
# 1017 Listing 4.9 Finding when a table was last inserted p.116
# 1094 Listing 5.1 Finding queries with missing statistics p.120
# 1113 Listing 5.2 Finding your default statistics options  p.123
# 1128 Listing 5.3 Finding disparate columns with different data types p.125
# 1162 Listing 5.4 Finding queries that are running slower than normal p.128
# 1241 Listing 5.5 Finding unused stored procedures   p.133
# 1255 Listing 5.6 Which queries run over a given time period p.134
# 1316 Listing 5.7 Amalgamated DMV snapshots  p.137
# 1470 Listing 5.8 What queries are running now  p.142
# 1498 Listing 5.9 Determining your most-recompiled queries p.144
# 1522 Listing 6.1 Why are you waiting? p.149
# 1544 Listing 6.2 Why are you waiting? (snapshot version) p.153
# 1581 Listing 6.3 Why your queries are waiting  p.155
# 1667 Listing 6.4 What is blocked? p.159
# 1696 Listing 6.5 Effect of queries on performance counters p.164
# 1736 Listing 6.6 Changes in performance counters and wait states p.166
# 1801 Listing 6.7 Queries that change performance counters and wait states p.169
# 1913 Listing 6.8 Recording DMV snapshots periodically p.173
# 1944 Listing 7.1 C# code to create regular expression functionality for use within SQL Server p.178
# 1957 Listing 7.2 Enabling CLR integration within SQL Server p.182
# 1976  Listing 7.3 Using the CLR regular expression functionality
# 1985 Listing 7.4 The queries that spend the most time in the CLR p.185
# 2034  Listing 7.5 The queries that spend the most time in the CLR (snapshot version) p.188
# 2090  Listing 7.6 Relationships between DMVs and CLR queries p190
# 2237 Listing 7.7 Obtaining information about SQL CLR assemblies p.194
# 2267 Listing 8.1 Transaction processing pattern p.198
# 2282 Listing 8.2 Creating the sample database and table p.199
# 2295 Listing 8.3 Starting an open transaction  p.200
# 2304 Listing 8.4 Selecting data from a table that has an open transaction against it p.200
# 2314 Listing 8.5  Observing the current locks  p.200
# 2327 Listing 8.6  Template for handling deadlock retries p.204
# 2372 Listing 8.7  Information contained in sessions, connections, and requests p.208
# 2389 Listing 8.8  How to discover which locks are currently held p.209
# 2415 Listing 8.9  How to identify contended resources p.211
# 2447 Listing 8.10 How to identify contended resources, including SQL query details p.211
# 2490 Listing 8.11 How to find an idle session with an open transaction p.214
# 2511 Listing 8.12 What’s being blocked by idle sessions with open transactions p.215
# 2556 Listing 8.13 What’s blocked by active sessions with open transactionsp.218
# 2602 Listing 8.14 What’s blocked—active and idle sessions with open transactions p.219
# 2648 Listing 8.15 What has been blocked for more than 30 seconds p.220
# 2695 Listing 9.1 Amount of space (total, used, and free) in tempdb  p.229
# 2719 Listing 9.2 Total amount of space (data, log, and log used) by database p.230
# 2740 Listing 9.3 Tempdb total space usage by object type p.231 
# 2760 Listing 9.4 Space usage by session
# 2789 Listing 9.5 Space used and reclaimed in tempdb for completed batches p.234
# 2822 Listing 9.6 Space usage by task
# 2849 Listing 9.7 Space used and not reclaimed in tempdb for active batches
# 2893  9.4  Tempdb recommendations  p.240 
# 2902  9.5 Index contention
# 2910 Listing 9.8 Indexes under the most row-locking pressure p.242 
# 2938 Listing 9.9 Indexes with the most lock escalations  p.244
# 2966 Listing 9.10 Indexes with the most unsuccessful lock escalations p.245
# 2990 Listing 9.11 Indexes with the most page splits  p.247 
# 3015 Listing 9.12 Indexes with the most latch contention p.248 
# 3040  Listing 9.13 Indexes with the most page I/O-latch contention p.250 
# 3066  Listing 9.14 Indexes under the most row-locking pressure—snapshot version p.251
# 3161 Listing 9.15 Determining how many rows are inserted/deleted/updated/selected  p.254
# 3278  Listing 10.1 CLR function to extract the routine name p.160
# 3330 Listing 10.2 Recompile routines that are running slower than normal p.262 
# 3435  Listing 10.3   Rebuilding and reorganizing fragmented indexes
# 3494 Listing 10.4 Rebuild/reorganize for all databases on a given server  p.268 
# 3556 Listing 10.5 Intelligently update statistics—simple version p.270 
# 3615 Listing 10.6 Intelligently update statistics—time-based version p.273
# 3770 Listing 10.7 Update statistics used by a SQL routine or a time interval p.277
# 3877 Listing 10.8 Automatically create any missing indexes
# 3936 Listing 10.9 Automatically disable or drop unused indexesp.283 
# 4009  Listing 11.1 Finding everyone’s last-run query p.287 
# 4027 Listing 11.2 Generic performance test harness p.289 
# 4082 Listing 11.3 Determining the performance impact of a system upgrade p.291
# 4236 Estimating the finishing time of system jobs
# 4219 Listing 11.4 Estimating when a job will finish p.295
# 4247 11.5 Get system information from within SQL Server p.297 
# 4265 11.6 Viewing enabled Enterprise features (2008 only) p.298
# 4315  Listing 11.5 Who’s doing what and when?  p.299
# 4373  11.8.1 Locating where your queries are spending their time  p.301
# 4435  Listing 11.7 Memory used per database  p.304
# 4455 11.10.1 Determining the memory used by tables and indexes p.305
# 4482  Listing 11.9 I/O stalls at the database level p.308 
# 4504  Listing 11.10 I/O stalls at the file level p.309
# 4526  Listing 11.11 Average read/write times per file, per database p.311 
# 4545 Listing 11.12 Simple trace utility  p.312
# 4603 11.13 Some best practices p.314

#  (2)  100 bulk export using BCP  P102
#  (3) 150  bulk import using BULK INSERT from CSV p.105

#(99)my test Person.persony 
#  1  system 變數  TSQL id ,hostname
#2         table => 變數 可執行  
#3         WHILE  loop 
#4         WAITFOR  
#5         RAND()   
#6         create table   
#7         INSERT data from Stored Procedure to Table 
#8         server_level objects 
#9     188 create   table
#10        insert 
#11        找出某Database 所有table   EXEC sp_MSforeachTable  
#12        找出某SQL 所有Database            Exec sp_MSforeachdb 
#13        Display Number of Rows in all Tables in a database
#14        Rebuild all indexes       Disable all Triggers      of all tables in a database
#15        like have '\'
#16    311 print echo
#17    343 查詢執行個體內SQL Server驗證的登入帳戶
#18    360 檢視「中央管理伺服器」存放在系統資料庫msdb內的資訊
#19    400 查詢 SQL Server 的產品版本、版本編號 
#20    420 step by step  create snapshot table
#21    450 Who   blocking  處理造成資料庫Blocking的情形 & sp_who
#22    474 set  single user
#23    477 Loop  example   & 大量產生資料  之變數
#24        table to table    +   計算時間 SET STATISTICS TIME
#25    559 回傳 7 今天修改的
#26    580 Create   database
#27    600 WMI Server event alerts  using WMI  p.136
#27-2  700 explore the SQL Server WMI events is to use a tool similar  p140
#28    800 Attaching  / Detaching  /copy  a database using SMO  p143
#29    900 Executing a SQL query to multiple servers p152
#30    900 Running DBCC commands p167
# 31   950 listing SQL Log error P215
# 1500     Control-of-Flow Language TSQL
#1801    Group having
#1815  TSQL Trigger
#1660  TQL Function

# 02 100  <Hosts>
# 03 150  insert/update Hosts
# 04 200  SQLServers information  with sQLPath
# 05 350  <SQLServers> with SERVERPROPERTY
# 05-1 1350 Function updateSQLServer with smo
# 05 450  function GetTCPPort
# 06 500  function GetSQLServiceStatus
# 07 550  function GetSQLstarttime
# 08 600  function GetSQLsystemDbDevice
# 09 650  <SQLDatabases>
# 10 650  Function GetSQLdatabases
# 11 750  Function GetSQLDBFileSize
# 12 800  GetDBfileNum
# 13 800  function updateMID
# 14 850  <HostsDisks>
# 15 900  Get  instance inventory  to CSV  p116
# 16 950  Get  Database information inventory  to CSV  p116
# 17 1000 Get  database using SMO
# 18 1200 GetHostDisks
# 19 1200  <SQLDisk>  + Function updateSQLDisks
# 20 1400  step by step DMV to SQL_inventory
# 21  1400  DBCC to SQL_inventory
# 22  get  Table index  filegroup 
#    1612   SQLEventLog
#+ SQLMonitor (alert, schedule, 
#+ PerfDisk
#+ perfCPU
#+ perfMemory
#+ perfNetwork
#+ perfalwayson
#+ perfreplication
#+ perfmirror
#+ DMVblock
#+ SQLstatus (view)
#+ historySQLDisks
#+ historyHostsDisk

# 99  ps1
#>}
$-----------------Sqlps09_replication
{<#
#         01 Test data  T6 ,T8 ,T9 , Hosts
# 02 224  Get Publisher  
# 03 354  Get 散發者設定
# 04 379  Get Subscriber 
# 05 401  create publication  
# 06 485  create  publication    merge 
# 07 525  drop publication  
# 08 541  Remove replication objects from the database. 
# 09 551  create subscription     
# 10 597  drop subscription     
# 11 618  將交易式提取Pull或匿名訂閱標示為在下次執行散發代理程式時重新初始化。 這個預存程序執行於提取訂閱資料庫的訂閱者端
# 12 681  article
# 13  監視複寫  http://technet.microsoft.com/zh-tw/library/ms152751.aspx
# 14  5) Monitoring Replication with System Monitor http://technet.microsoft.com/en-us/library/ms151754.aspx
# 15     agent job and MSreplication_monitordata
# 16  MSdistribution_status
# 17  http://basitaalishan.com/2012/07/25/transact-sql-script-to-monitor-replication-status/
#    1300  View and Modify Replication Security Settings
#>}
$-----------------Sqlps11_alert
{<#
# (1)  Get alert   --http://technet.microsoft.com/zh-tw/library/ms186933.aspx

#>}
$-----------------Sqlps12_Security
{<#
#01 Listing /set SQL Server service accounts p204
#02 Listing/ Set Authentication Modes p210
#03  950 Listing failed login attempts             p220
#04  Listing logins, users, and database mappings  p222
#05  Listing login/user roles and permissions      p225
#06 300 Creating / set Permission a login using SMO p227
#07 350  creating /assigning permission  a database user p.232
#08 createing a database Role p.237
#09   Fixing orphaned users p241
#10 Creating a credential  p.244
#11 600 Creating a proxy  p246
#12 Creating a database master key p.289
#13  700 Creating a certificate  p.291
#14 750  Creating symmetric and asymmetric keys P293
#15 800  How to link users and logins in an Availability Group  orphaned
#16  866  範例程式碼15-1：建立範例資料庫Northwind_ Audit
#17  866  範例程式碼15-2：在資料庫Northwind_Audit內，建立、修改與刪除資料庫物件
#18  933  範例程式碼15-3：建立登入帳戶wii，並賦予適當的權限
#19  960  範例程式碼15-4：利用登入帳戶wii，對資料表Custoemrs執行查詢與更新等作業
#20  977  範例程式碼15-5：使用sys.dm_server_audit_status動態管理檢視來查看各個「稽核」物件的目前狀態
#21  999  範例程式碼15-6：使用函數fn_get_audit_file分析「稽核」檔案.sql
#22  1060 範例程式碼15-7：建立、啟用與檢視「稽核」物件
#23  1077 範例程式碼15-8：建立與啟用「伺服器稽核規格」物件
#24  1099 範例程式碼15-9：檢視「伺服器稽核規格」物件的相關資料
#25  1111 範例程式碼15-10：檢視可用於設定的稽核動作、稽核動作群組與稽核類型的項目
#26  1150 範例程式碼15-11：建立與啟用「資料庫稽核規格」
#27  1168 範例程式碼15-12：檢視「資料庫稽核規格」物件的目前狀態
#28  1180 範例程式碼15-13：建立登入帳戶ps3，可以連線資料庫Northwind_Audit，並賦予適當的權限
#29  1208 範例程式碼15-14：查詢資料庫Northwind_Audit內的資料表
#30  1233 範例程式碼15-15：建立函數，篩選與分析所需的稽核資料
#32  1400 Testing  Database Audit Specification
#33  1470   檢視/create/drop   Audit   20150610
#34  1500   Get audit actions   20150610
#35  1800  sp_change_users_login  現有的資料庫使用者對應至 SQL Server 登入  20150720
#36  1800      執行個體之間傳送登入和密碼 sp_help_revlogin   sp_hexadecimal  20150721
#>}
$-----------------Sqlps14_backupRestore
{<#
# 1  交易記錄檔的使用狀況
# 2  截斷交易記錄 &  簡單完整模式
# 3  移動資料或記錄檔
# 4  壓縮記錄檔
# 5  結尾記錄備份 
# 6  備份 
# 7  還原資料庫 + 移動檔案  
# 8  交易記錄還原到標記
# 9  清除檔案 
# 10 200 Changing database recovery model  using SMO p.30
# 11  300  Listing backup history  P309
# 12 300  Creating a backup device  p.310 
# 13 Listing backup header and file listinformation  p312
# 14  400  Creating a full backup  p316
# 15  500  Creating a backup on mirrored media sets  p321
# 16 550  Creating a differential backup   p324
# 17 600  Creating a transcation log  backup   p327
# 18 600  Creating a filegroup backup   p329
# 19    Restoring a database to a point in time   p332
# 20 800 Performing an online piecemeal restore p.34
# 21  800 Recovery-Only Database Restore  在不還原資料的情況下復原資料庫
# 22 How to read the SQL Server Database Transaction Log   sys.fn_dblog(NULL,NULL)
# 23  929  LSN 
# 24 2166   Recovery Paths 復原路徑
# 25 2200  Piecemeal Restore of Databases  分次還原
#>}

$-----------------Sqlps17_Triggers
{<#
\\192.168.112.124\c$\Users\administrator.CSD\OneDrive\download\PS1\Sqlps17_triggers.ps1

#  50  DML trigger  新增更改刪除 another Table
#  200 DDL trigger   
#  300  RAISERROR 透過對 CREATE_TABLE 事件建立觸發程序，記錄建立者的帳號到 Windows Event Log
#  350  DDL 觸發程序搭配資料表記錄使用者對資料庫的變更動作
#  400   sys.messages 目錄檢檢視
#  485   登入觸發程序  Logon Triggers
#  535  使用 EVENTDATA 函數
#  607 DML  trigger  for DGPA 

#>}

$-----------------Sqlps20_policy
{<#
# 1：建立目標資料庫Northwind_PBM與使用者預存程序：dbo.sp_haha01
# 2：建立不符合「原則」的「條件」規範之使用者自定預存程序，其前置詞為sp_
# 3：建立符合「原則」的「條件」規範之使用者自定預存程序，其前置詞為np_
# 4：測試「原則」：預存程序的物件名稱之前置詞不得為sp_
# 5：建立違反原則的使用者自定預存程序，並檢視其錯誤訊息
# 6：利用xp_cmdshell擴充預存程序，執行顯示目錄命令
# 7：以原則為基礎的管理與系統檢視
# 8：刪除「以原則為基礎的管理」的歷史紀錄
# 9       Listing facets and facet properties  p252
# 10      Listing / Exporting  policies  p.254
# 11      Creating a condition  p.264
# 12  700  Creating  /Evaluating  a policy P.268
#  13   800 PBM default for alwayson
#  14   900 msdb.dbo.syspolicy_policies  for alwayson
#  15  900  msdb.dbo.syspolicy_conditions   msdb.dbo.syspolicy_conditions_internal    for alwayson
#  16  950  look for all  properties facts      Microsoft.SqlServer.Management.Smo Namespace
#>}
$-----------------SQLPS21_BI
{<#
powershell_ise \\192.168.112.124\c$\Users\administrator.CSD\OneDrive\download\PS1\SQLPS21_BI.ps1
#  27   Analysis Services PowerShell
#  230  SQL Server Analysis Services 教學課程
#  309 Using powerPivot  in excel 2013
#  333 Using power view
#  385 Troubleshooting    SSAS startup failure
#  396    SSISDB 目錄
#  407    SSIS configuration  deploy package   Dtutil 

#>}