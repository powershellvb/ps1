﻿<#
OS02_03_Sharepoint_SQL.ps1
Desc:   for M3 
filename:   
\\192.168.112.124\c$\Users\administrator.CSD\OneDrive\download\PS1\OS02_03_Sharepoint_SQL.ps1
  \\172.16.220.29\c$\Users\administrator.CSD\SkyDrive\download\ps1\OS02_03_Sharepoint_SQL.ps1

Date:May.20.2014
last: Nov.04.2015

author: a0921887912@gmail.com
from : OS0201_diskIO.ps1

JOB , blg , 
#>

#  18  Get basci info
#  268  remote job counter
#  351  os Memory
#  435  sql
#  457  disk
#  586  processor


#---------------------------------------------------------------
#  18  Get basci info
#---------------------------------------------------------------

$dbinstance='PMD2016' 
$dbinstance='SP2013' 


$dbname    ='sql_inventory'


function dbmdfldfSize ($dbinstance,$dbname){
  $tsql_selectdbFileSize="
print 'Show Size, Space Used, Unused Space, Type, and Name of all database files'
select
	[FileSizeMB]	=
		convert(numeric(10,2),sum(round(a.size*0.008,2))),
        [UsedSpaceMB]	=
		convert(numeric(10,2),sum(round(fileproperty( a.name,'SpaceUsed')*0.008,2))) ,
        [UnusedSpaceMB]	=
		convert(numeric(10,2),sum(round((a.size-fileproperty( a.name,'SpaceUsed'))*0.008 ,2))) ,
	[Type] =
		case when a.groupid is null then '' when a.groupid = 0 then 'Log' else 'Data' end,
	[DBFileName]	= isnull(a.name,'+++ Total for all files ++')
from
	sysfiles a
group by
	groupid,
	a.name
	with rollup
having
	a.groupid is null or
	a.name is not null
order by
	case when a.groupid is null then 99 when a.groupid = 0 then 0 else 1 end,
	a.groupid,
	case when a.name is null then 99 else 0 end,
	a.name
"
Invoke-Sqlcmd -Query $tsql_selectdbFileSize -ServerInstance  $dbinstance  -Database $dbname  -user sa  -password p@ssw0rd  |ft -AutoSize  
}
dbmdfldfSize PMD2016 sql_inventory


$tsql_select53="select name, physical_name, size *0.000008 from sys.master_files"     

   Invoke-Sqlcmd -Query $tsql_select53 -ServerInstance  PMD2016  -user sa  -password p@ssw0rd  |ft -AutoSize


$tsql_GetTableRowSize=@"
create table #TABLE_SPACE_WORK
(
	TABLE_NAME 	sysname		not null ,
	TABLE_ROWS 	numeric(18,0)	not null ,
	RESERVED 	varchar(50) 	not null ,
	DATA 		varchar(50) 	not null ,
	INDEX_SIZE 	varchar(50) 	not null ,
	UNUSED 		varchar(50) 	not null ,
)

create table #TABLE_SPACE_USED
(
	Seq		int		not null	
	identity(1,1)	primary key clustered,
	TABLE_NAME 	sysname		not null ,
	TABLE_ROWS 	numeric(18,0)	not null ,
	RESERVED 	varchar(50) 	not null ,
	DATA 		varchar(50) 	not null ,
	INDEX_SIZE 	varchar(50) 	not null ,
	UNUSED 		varchar(50) 	not null ,
)
create table #TABLE_SPACE
(
	Seq		int		not null
	identity(1,1)	primary key clustered,
	TABLE_NAME 	SYSNAME 	not null ,
	TABLE_ROWS 	int	 	not null ,
	RESERVED 	int	 	not null ,
	DATA 		int	 	not null ,
	INDEX_SIZE 	int	 	not null ,
	UNUSED 		int	 	not null ,
	USED_MB				numeric(18,4)	not null,
	USED_GB				numeric(18,4)	not null,
	AVERAGE_BYTES_PER_ROW		numeric(18,5)	null,
	AVERAGE_DATA_BYTES_PER_ROW	numeric(18,5)	null,
	AVERAGE_INDEX_BYTES_PER_ROW	numeric(18,5)	null,
	AVERAGE_UNUSED_BYTES_PER_ROW	numeric(18,5)	null,
)




declare @fetch_status int
declare @proc 	varchar(200)
select	@proc	= rtrim(db_name())+'.dbo.sp_spaceused'
declare Cur_Cursor cursor local
for
--select TABLE_NAME	= rtrim(TABLE_SCHEMA)+'.'+rtrim(TABLE_NAME)
--from INFORMATION_SCHEMA.TABLES 
--where  TABLE_TYPE	= 'BASE TABLE'
--order by	1

select TABLE_NAME =name  from  sys.tables  where is_ms_shipped ='0'

open Cur_Cursor
declare @TABLE_NAME 	varchar(200)
select @fetch_status = 0
while @fetch_status = 0
	begin
fetch next from Cur_Cursor
	into
		@TABLE_NAME
select @fetch_status = @@fetch_status
if @fetch_status <> 0
		begin
		continue
		end
truncate table #TABLE_SPACE_WORK
insert into #TABLE_SPACE_WORK
		(
		TABLE_NAME,
		TABLE_ROWS,
		RESERVED,
		DATA,
		INDEX_SIZE,
		UNUSED
		)
	exec @proc @objname =  @TABLE_NAME ,@updateusage = 'true'
-- Needed to work with SQL 7
	update #TABLE_SPACE_WORK
	set
		TABLE_NAME = @TABLE_NAME
insert into #TABLE_SPACE_USED
		(
		TABLE_NAME,
		TABLE_ROWS,
		RESERVED,
		DATA,
		INDEX_SIZE,
		UNUSED
		)
	select
		TABLE_NAME,
		TABLE_ROWS,
		RESERVED,
		DATA,
		INDEX_SIZE,
		UNUSED
	from
		#TABLE_SPACE_WORK
end 	--While end
close Cur_Cursor
deallocate Cur_Cursor
insert into #TABLE_SPACE
	(
	TABLE_NAME,
	TABLE_ROWS,
	RESERVED,
	DATA,
	INDEX_SIZE,
	UNUSED,
	USED_MB,
	USED_GB,
	AVERAGE_BYTES_PER_ROW,
	AVERAGE_DATA_BYTES_PER_ROW,
	AVERAGE_INDEX_BYTES_PER_ROW,
	AVERAGE_UNUSED_BYTES_PER_ROW
)
select
	TABLE_NAME,
	TABLE_ROWS,
	RESERVED,
	DATA,
	INDEX_SIZE,
	UNUSED,
	USED_MB			=
		round(convert(numeric(25,10),RESERVED)/
		convert(numeric(25,10),1024),4),
	USED_GB			=
		round(convert(numeric(25,10),RESERVED)/
		convert(numeric(25,10),1024*1024),4),
	AVERAGE_BYTES_PER_ROW	=
		case
		when TABLE_ROWS <> 0
		then round(
		(1024.000000*convert(numeric(25,10),RESERVED))/
		convert(numeric(25,10),TABLE_ROWS),5)
		else null
		end,
	AVERAGE_DATA_BYTES_PER_ROW	=
		case
		when TABLE_ROWS <> 0
		then round(
		(1024.000000*convert(numeric(25,10),DATA))/
		convert(numeric(25,10),TABLE_ROWS),5)
		else null
		end,
	AVERAGE_INDEX_BYTES_PER_ROW	=
		case
		when TABLE_ROWS <> 0
		then round(
		(1024.000000*convert(numeric(25,10),INDEX_SIZE))/
		convert(numeric(25,10),TABLE_ROWS),5)
		else null
		end,
	AVERAGE_UNUSED_BYTES_PER_ROW	=
		case
		when TABLE_ROWS <> 0
		then round(
		(1024.000000*convert(numeric(25,10),UNUSED))/
		convert(numeric(25,10),TABLE_ROWS),5)
		else null
		end
from
	(
	select
		TABLE_NAME,
		TABLE_ROWS,
		RESERVED	= 
		convert(int,rtrim(replace(RESERVED,'KB',''))),
		DATA		= 
		convert(int,rtrim(replace(DATA,'KB',''))),
		INDEX_SIZE	= 
		convert(int,rtrim(replace(INDEX_SIZE,'KB',''))),
		UNUSED		= 
		convert(int,rtrim(replace(UNUSED,'KB','')))
	from
		#TABLE_SPACE_USED aa
	) a
order by
	TABLE_NAME

print 'Show results in descending order by size in MB'
select TABLE_NAME,TABLE_ROWS,USED_MB,AVERAGE_BYTES_PER_ROW,AVERAGE_DATA_BYTES_PER_ROW,AVERAGE_INDEX_BYTES_PER_ROW,AVERAGE_UNUSED_BYTES_PER_ROW

from #TABLE_SPACE order by USED_MB desc
go
drop table #TABLE_SPACE_WORK
drop table #TABLE_SPACE_USED 
drop table #TABLE_SPACE
"@
Invoke-Sqlcmd -Query $tsql_GetTableRowSize -ServerInstance  $dbinstance  -Database $dbname  -user sa  -password p@ssw0rd  |ft -AutoSize  

set statistics io on
set statistics time  on


#---------------------------------------------------------------
#  268  remote job counter
#---------------------------------------------------------------


$tr = get-date;
$t1 =  $tr.AddMinutes(1)
$te =  $tr.AddMinutes(10)


$blgFile='c:\perfmon\diskIO_'+((get-date -Format HHmm)).ToString()+'.blg'
$blgFile='c:\perfmon\diskIO_'+((get-date -Format YM   HHmm)).ToString()+'.blg';$blgFile

$APcounterS_Network='\Network Interface(*)\Bytes Total/sec'

ssms
$APcounterS='
$DBcounterS=''
'

$tr = get-date;
$t1 =  $tr.AddMinutes(1)
$te =  $tr.AddMinutes(10)


while ($te -ge $tr ) { #p.37

  if(($tr.Minute -ge $t1.Minute )  -and ($tr.Second -eq 0 )){   #p.65
  
  # backgraud
    
$tj1=get-date ; '(p.83)tj1--  '+$tj1 +'  blgFile= '+$blgFile

$job1=start-job { param($blgFile) `
Get-counter -Counter "\PhysicalDisk(1 H:)\Disk Transfers/sec" ,"\PhysicalDisk(1 H:)\Avg. Disk sec/Write" `
,"\PhysicalDisk(1 H:)\Avg. Disk sec/Read","\PhysicalDisk(1 H:)\Avg. Disk sec/Transfer"`
,"\PhysicalDisk(1 H:)\Disk Bytes/sec" ,"\PhysicalDisk(1 H:)\% Disk Time" `
–Continuous  | Export-Counter -Path $blgFile -FileFormat blg -Force} -ArgumentList $blgFile

  # TSQL  Invoke-Sql
$ts1=get-date ; '(p.93)SqlBegin--'+$ts1
$ts2=$ts1;$ts3=$ts1;$ts4=$ts1;   

Invoke-Sqlcmd -Query $TSQL_create  -ServerInstance $tServerInstance -Database $tDB -QueryTimeout 600
$job_local=start-job {param($TestTSQL,$tServerInstance,$tDB)Invoke-Sqlcmd -Query $TestTSQL   `
-ServerInstance $tServerInstance -Database $tDB -QueryTimeout 600} `
-ArgumentList $TestTSQL,$tServerInstance,$tDB

#Invoke-Sqlcmd -Query $TSQL_create  -ServerInstance spm -Database AdventureWorks2012 -QueryTimeout 600
#Invoke-Sqlcmd -Query $TestTSQL  -ServerInstance spm -Database AdventureWorks2012 -QueryTimeout 600


$job_sp2013wfe=start-job { param($runFile) icm sp2013wfe  -FilePath $runFile } -ArgumentList $runFile 
$job_sql2012x =start-job { param($runFile) icm sql2012x   -FilePath $runFile } -ArgumentList $runFile 

  do
  {
     # (get-date).ToString() +"     I'm Running"
    if(($job_local.State     -eq  'Completed') -and ($t2g -eq $False)) { $ts2=get-date ; '(p.115)local     Finish --' +$ts2 ;$t2g=$true }
    if(($job_sp2013wfe.State -eq  'Completed') -and ($t3g -eq $False)) { $ts3=get-date ; '(p.116)sp2013wfe Finish --' +$ts3 ;$t3g=$true }
    if(($job_sql2012x.State  -eq  'Completed') -and ($t4g -eq $False)) { $ts4=get-date ; '(p.117)sql2012x  Finish --' +$ts4 ;$t4g=$true }
  }
  until (($job_sql2012x.State  -eq  'Completed') -and ($job_sp2013wfe.State  -eq  'Completed') -and ($job_local.State  -eq  'Completed'))
   
   if($ts2 -eq $ts1){$ts2=get-date }
   if($ts3 -eq $ts1){$ts3=get-date }
   if($ts4 -eq $ts1){$ts4=get-date }
 
"(p.125)SQL Local      Execution  Time = "+($ts2-$ts1).TotalMinutes  +" Minutes"
"(p.126)SQL sp2013wfe  Execution  Time = "+($ts3-$ts1).TotalMinutes  +" Minutes"
"(p.127)SQL sql2012x   Execution  Time = "+($ts4-$ts1).TotalMinutes  +" Minutes"

sleep 10

remove-item $runFile
Invoke-Sqlcmd -Query $TSQL_drop  -ServerInstance $tServerInstance -Database $tDB -QueryTimeout 600
#--get-job *
stop-job *
remove-job *  #-id 8
sleep 10
Break
 
  } #p.65


$tr =get-date

}#p.37


#---------------------------------------------------------------
#  351  os Memory
#---------------------------------------------------------------


Get-Counter -ListSet *Memory* | Select-Object -ExpandProperty Paths

'\Memory\Page Faults/sec', #
'\Memory\Available Bytes', #還可使用數
'\Memory\Committed Bytes', #Memory
'\Memory\Commit Limit', #可使用最大值
'\Memory\Write Copies/sec', #Memory
'\Memory\Transition Faults/sec', #Memory
'\Memory\Cache Faults/sec', #Memory
'\Memory\Demand Zero Faults/sec', #Memory

'\Memory\Pages/sec',       #每秒幾個　pages Input +Output  數量  https://support.microsoft.com/en-us/kb/139609
'\Memory\Page Reads/sec',  #每秒幾個　pages Read   數量
'\Memory\Page Writes/sec', #每秒幾個　pages write  數量
'\Memory\Pages Input/sec', #Memory
'\Memory\Pages Output/sec', #Memory

'\Memory\Pool Paged Bytes', #Memory
'\Memory\Pool Nonpaged Bytes', #Memory

'\Memory\Pool Paged Allocs', #Memory
'\Memory\Pool Nonpaged Allocs', #Memory
'\Memory\Free System Page Table Entries', #Memory
'\Memory\Cache Bytes', #指出檔案系統快取正在使用的記憶體量。如果此值大於 200MB，就表示可能發生磁碟瓶頸了。
'\Memory\Cache Bytes Peak', #Memory
'\Memory\Pool Paged Resident Bytes', #Memory
'\Memory\System Code Total Bytes', #Memory
'\Memory\System Code Resident Bytes', #Memory
'\Memory\System Driver Total Bytes', #Memory
'\Memory\System Driver Resident Bytes', #Memory
'\Memory\System Cache Resident Bytes', #Memory
'\Memory\% Committed Bytes In Use', #Memory
'\Memory\Available KBytes', #Memory
'\Memory\Available MBytes', #Memory
'\Memory\Transition Pages RePurposed/sec', #Memory
'\Memory\Free & Zero Page List Bytes', #Memory
'\Memory\Modified Page List Bytes', #Memory
'\Memory\Standby Cache Reserve Bytes', #Memory
'\Memory\Standby Cache Normal Priority Bytes', #Memory
'\Memory\Standby Cache Core Bytes', #Memory
'\Memory\Long-Term Average Standby Cache Lifetime (s)', #Memory

Get-Counter  "\\sql2014x\Paging File\% Usage"   #|Select-Object -ExpandProperty Paths
Get-Counter    -Counter   "\\sp2013\\memory\% committed bytes in use"

$PCR_Memory =   #1
'\Memory\Committed Bytes', #己使用總數
'\Memory\Commit Limit',    #可使用最大值
'\Memory\Available Bytes', #還可使用數
'\Memory\Pages/sec',       #每秒幾個　pages Input +Output  數量  https://support.microsoft.com/en-us/kb/139609
'\Memory\Page Reads/sec',  #每秒幾個　pages Read   數量
'\Memory\Page Writes/sec', #每秒幾個　pages write  數量
'\Memory\Cache Bytes'      #指出檔案系統快取正在使用的記憶體量。


$PCR_CPU =  `  #
'\processor(_total)\% processor time'`
,'\memory\% committed bytes in use'


$PCR_s1=$PCR_Memory+$PCR_CPU; $PCR_s1

    Get-Counter   -comp $dbinstance    -Counter  $PCR_Memory
    Get-Counter   -comp $dbinstance   -Counter  $PCR_s1



get-counter -ComputerName $dbinstance

#---------------------------------------------------------------
#  435  sql
#---------------------------------------------------------------

Get-Counter -ListSet *sqlserver:Locks* | Select-Object -ExpandProperty Paths
\SQLServer:Locks(*)\Lock Requests/sec
\SQLServer:Locks(*)\Lock Timeouts/sec
\SQLServer:Locks(*)\Number of Deadlocks/sec
'\SQLServer:Locks(*)\Lock Waits/sec',#每秒需要呼叫者等候的鎖定要求次數   _total  https://msdn.microsoft.com/zh-tw/library/ms190216.aspx
\SQLServer:Locks(*)\Lock Wait Time (ms)
\SQLServer:Locks(*)\Average Wait Time (ms)
\SQLServer:Locks(*)\Lock Timeouts (timeout > 0)/sec


Get-Counter -ListSet *'SQLServer:SQL Statistics'* | Select-Object -ExpandProperty Paths


\SQLServer:SQL Statistics\Batch Requests/sec
\SQLServer:SQL Statistics\Forced Parameterizations/sec
\SQLServer:SQL Statistics\Auto-Param Attempts/sec
\SQLServer:SQL Statistics\Failed Auto-Params/sec
\SQLServer:SQL Statistics\Safe Auto-Params/sec
\SQLServer:SQL Statistics\Unsafe Auto-Params/sec
\SQLServer:SQL Statistics\SQL Compilations/sec
\SQLServer:SQL Statistics\SQL Re-Compilations/sec
\SQLServer:SQL Statistics\SQL Attention rate
\SQLServer:SQL Statistics\Guided plan executions/sec
\SQLServer:SQL Statistics\Misguided plan executions/sec


Get-Counter -ListSet *'SQLServer:General Statistics'* | Select-Object -ExpandProperty Paths

'\SQLServer:General Statistics\Active Temp Tables
\SQLServer:General Statistics\Temp Tables Creation Rate
\SQLServer:General Statistics\Logins/sec
\SQLServer:General Statistics\Connection Reset/sec
\SQLServer:General Statistics\Logouts/sec
\SQLServer:General Statistics\User Connections
\SQLServer:General Statistics\Logical Connections
\SQLServer:General Statistics\Transactions
\SQLServer:General Statistics\Non-atomic yield rate
\SQLServer:General Statistics\Mars Deadlocks
\SQLServer:General Statistics\HTTP Authenticated Requests
\SQLServer:General Statistics\SOAP Empty Requests
\SQLServer:General Statistics\SOAP SQL Requests
\SQLServer:General Statistics\SOAP Method Invocations
\SQLServer:General Statistics\SOAP WSDL Requests
\SQLServer:General Statistics\SOAP Session Initiate Requests
\SQLServer:General Statistics\SOAP Session Terminate Requests
\SQLServer:General Statistics\Processes blocked
\SQLServer:General Statistics\Temp Tables For Destruction
\SQLServer:General Statistics\Event Notifications Delayed Drop
\SQLServer:General Statistics\Trace Event Notification Queue
\SQLServer:General Statistics\SQL Trace IO Provider Lock Waits
\SQLServer:General Statistics\Tempdb recovery unit id
\SQLServer:General Statistics\Tempdb rowset id'





\SQLServer:Transactions\Transactions
\SQLServer:Transactions\Snapshot Transactions
\SQLServer:Transactions\Update Snapshot Transactions
\SQLServer:Transactions\NonSnapshot Version Transactions
\SQLServer:Transactions\Longest Transaction Running Time
\SQLServer:Transactions\Update conflict ratio
\SQLServer:Transactions\Free Space in tempdb (KB)
\SQLServer:Transactions\Version Generation rate (KB/s)
\SQLServer:Transactions\Version Cleanup rate (KB/s)
\SQLServer:Transactions\Version Store Size (KB)
\SQLServer:Transactions\Version Store unit count
\SQLServer:Transactions\Version Store unit creation
\SQLServer:Transactions\Version Store unit truncation

$PCR_sQL=  #
'\SQLServer:Locks(_total)\Lock Waits/sec'#每秒需要呼叫者等候的鎖定要求次數 
,'\SQLServer:General Statistics\User Connections'
 Get-Counter   -comp $dbinstance   -Counter  $PCR_sQL



#---------------------------------------------------------------
#  457  disk
#---------------------------------------------------------------

Get-Counter -ListSet *disk* | Select-Object -ExpandProperty Paths

'\FileSystem Disk Activity(*)\FileSystem Bytes Written',#disk
'\FileSystem Disk Activity(*)\FileSystem Bytes Read',#disk
'\LogicalDisk(*)\% Free Space',#disk
'\LogicalDisk(*)\Free Megabytes',#disk
'\LogicalDisk(*)\Current Disk Queue Length',#disk
'\LogicalDisk(*)\% Disk Time',#disk
'\LogicalDisk(*)\Avg. Disk Queue Length',#disk
'\LogicalDisk(*)\% Disk Read Time',#disk
'\LogicalDisk(*)\Avg. Disk Read Queue Length',#disk
'\LogicalDisk(*)\% Disk Write Time',#disk
'\LogicalDisk(*)\Avg. Disk Write Queue Length',#disk
'\LogicalDisk(*)\Avg. Disk sec/Transfer',#disk
'\LogicalDisk(*)\Avg. Disk sec/Read',#disk
'\LogicalDisk(*)\Avg. Disk sec/Write',#disk
'\LogicalDisk(*)\Disk Transfers/sec',#disk
'\LogicalDisk(*)\Disk Reads/sec',#disk
'\LogicalDisk(*)\Disk Writes/sec',#disk
'\LogicalDisk(*)\Disk Bytes/sec',#disk
'\LogicalDisk(*)\Disk Read Bytes/sec',#disk
'\LogicalDisk(*)\Disk Write Bytes/sec',#disk
'\LogicalDisk(*)\Avg. Disk Bytes/Transfer',#disk
'\LogicalDisk(*)\Avg. Disk Bytes/Read',#disk
'\LogicalDisk(*)\Avg. Disk Bytes/Write',#disk
'\LogicalDisk(*)\% Idle Time',#測量在取樣間隔期間，磁碟閒置時間的百分比。如果這個計數器低於 20%，就表示磁碟系統已達飽和狀態。您可以考慮把目前的磁碟系統換成速度較快的磁碟系統。
'\LogicalDisk(*)\Split IO/Sec',#disk
'\PhysicalDisk(*)\Current Disk Queue Length',#disk
'\PhysicalDisk(*)\% Disk Time',#disk
'\PhysicalDisk(*)\Avg. Disk Queue Length',#目前有多少個 I/O 作業正在等候使用磁碟機
'\PhysicalDisk(*)\% Disk Read Time',#disk
'\PhysicalDisk(*)\Avg. Disk Read Queue Length',#disk
'\PhysicalDisk(*)\% Disk Write Time',#disk
'\PhysicalDisk(*)\Avg. Disk Write Queue Length',#disk
'\PhysicalDisk(*)\Avg. Disk sec/Transfer',#disk
'\PhysicalDisk(*)\Avg. Disk sec/Read',# 測量從磁碟讀取資料的平均時間 (以秒為單位)
'\PhysicalDisk(*)\Avg. Disk sec/Write',# 測量將資料寫入磁碟的平均時間 (以秒為單位)
'\PhysicalDisk(*)\Disk Transfers/sec',#disk
'\PhysicalDisk(*)\Disk Reads/sec',#disk
'\PhysicalDisk(*)\Disk Writes/sec',#disk
'\PhysicalDisk(*)\Disk Bytes/sec',#disk
'\PhysicalDisk(*)\Disk Read Bytes/sec',#disk
'\PhysicalDisk(*)\Disk Write Bytes/sec',#disk
'\PhysicalDisk(*)\Avg. Disk Bytes/Transfer',#disk
'\PhysicalDisk(*)\Avg. Disk Bytes/Read',#disk
'\PhysicalDisk(*)\Avg. Disk Bytes/Write',#disk
'\PhysicalDisk(*)\% Idle Time',#disk
'\PhysicalDisk(*)\Split IO/Sec',#disk


$PCR_disk =   #1
'\PhysicalDisk(*)\Avg. Disk Queue Length'    ,#目前有多少個 I/O 作業正在等候使用磁碟機



$PCR_disk =   #1
'\LogicalDisk(_total)\% Disk Time'



Get-Counter   -comp $dbinstance   -Counter  $PCR_disk



#---------------------------------------------------------------
#  586  Processor
#---------------------------------------------------------------
Get-Counter -ListSet *processor* | Select-Object -ExpandProperty Paths

'
\Processor Information(*)\Performance Limit Flags
\Processor Information(*)\% Performance Limit
\Processor Information(*)\% Privileged Utility
\Processor Information(*)\% Processor Utility
\Processor Information(*)\% Processor Performance
\Processor Information(*)\Idle Break Events/sec
\Processor Information(*)\Average Idle Time
\Processor Information(*)\Clock Interrupts/sec
\Processor Information(*)\Processor State Flags
\Processor Information(*)\% of Maximum Frequency
\Processor Information(*)\Processor Frequency
\Processor Information(*)\Parking Status
\Processor Information(*)\% Priority Time
\Processor Information(*)\C3 Transitions/sec
\Processor Information(*)\C2 Transitions/sec
\Processor Information(*)\C1 Transitions/sec
\Processor Information(*)\% C3 Time
\Processor Information(*)\% C2 Time
\Processor Information(*)\% C1 Time
\Processor Information(*)\% Idle Time
\Processor Information(*)\DPC Rate
\Processor Information(*)\DPCs Queued/sec
\Processor Information(*)\% Interrupt Time
\Processor Information(*)\% DPC Time
\Processor Information(*)\Interrupts/sec
\Processor Information(*)\% Privileged Time
\Processor Information(*)\% User Time
\Processor Information(*)\% Processor Time
\Per Processor Network Activity Cycles(*)\Interrupt DPC Latency Cycles/sec
\Per Processor Network Activity Cycles(*)\Stack Send Complete Cycles/sec
\Per Processor Network Activity Cycles(*)\Miniport RSS Indirection Table Change Cycles
\Per Processor Network Activity Cycles(*)\Build Scatter Gather Cycles/sec
\Per Processor Network Activity Cycles(*)\NDIS Send Complete Cycles/sec
\Per Processor Network Activity Cycles(*)\Miniport Send Cycles/sec
\Per Processor Network Activity Cycles(*)\NDIS Send Cycles/sec
\Per Processor Network Activity Cycles(*)\Miniport Return Packet Cycles/sec
\Per Processor Network Activity Cycles(*)\NDIS Return Packet Cycles/sec
\Per Processor Network Activity Cycles(*)\Stack Receive Indication Cycles/sec
\Per Processor Network Activity Cycles(*)\NDIS Receive Indication Cycles/sec
\Per Processor Network Activity Cycles(*)\Interrupt Cycles/sec
\Per Processor Network Activity Cycles(*)\Interrupt DPC Cycles/sec
\Per Processor Network Interface Card Activity(*)\Packets Coalesced/sec
\Per Processor Network Interface Card Activity(*)\DPCs Deferred/sec
\Per Processor Network Interface Card Activity(*)\Tcp Offload Send bytes/sec
\Per Processor Network Interface Card Activity(*)\Tcp Offload Receive bytes/sec
\Per Processor Network Interface Card Activity(*)\Tcp Offload Send Request Calls/sec
\Per Processor Network Interface Card Activity(*)\Tcp Offload Receive Indications/sec
\Per Processor Network Interface Card Activity(*)\Low Resource Received Packets/sec
\Per Processor Network Interface Card Activity(*)\Low Resource Receive Indications/sec
\Per Processor Network Interface Card Activity(*)\RSS Indirection Table Change Calls/sec
\Per Processor Network Interface Card Activity(*)\Build Scatter Gather List Calls/sec
\Per Processor Network Interface Card Activity(*)\Sent Complete Packets/sec
\Per Processor Network Interface Card Activity(*)\Sent Packets/sec
\Per Processor Network Interface Card Activity(*)\Send Complete Calls/sec
\Per Processor Network Interface Card Activity(*)\Send Request Calls/sec
\Per Processor Network Interface Card Activity(*)\DPCs Queued on Other CPUs/sec
\Per Processor Network Interface Card Activity(*)\Returned Packets/sec
\Per Processor Network Interface Card Activity(*)\Received Packets/sec
\Per Processor Network Interface Card Activity(*)\Return Packet Calls/sec
\Per Processor Network Interface Card Activity(*)\Receive Indications/sec
\Per Processor Network Interface Card Activity(*)\Interrupts/sec
\Per Processor Network Interface Card Activity(*)\DPCs Queued/sec
'\Processor(*)\% Processor Time', #測量處理器在執行非閒置執行緒時，已耗用時間的百分比。如果此百分比大於 85%
\Processor(*)\% User Time
\Processor(*)\% Privileged Time
\Processor(*)\Interrupts/sec
\Processor(*)\% DPC Time
\Processor(*)\% Interrupt Time
\Processor(*)\DPCs Queued/sec
\Processor(*)\DPC Rate
\Processor(*)\% Idle Time
\Processor(*)\% C1 Time
\Processor(*)\% C2 Time
\Processor(*)\% C3 Time
\Processor(*)\C1 Transitions/sec
\Processor(*)\C2 Transitions/sec
\Processor(*)\C3 Transitions/sec'



$PCR_Processor =   #1
'\Processor(_total)\% Processor Time'

hostname
Get-Counter    -Counter  $PCR_Processor
#---------------------------------------------------------------
#   ref 
#---------------------------------------------------------------

https://technet.microsoft.com/zh-tw/magazine/2008.08.pulse.aspx
測量的內容和時機
當資源到達容量上限時，就會產生瓶頸，使整個系統的效能降低。瓶頸通常是因為資源不足或配置不當、元件無法正常運作，以及程式要求資源不當所致。
會產生瓶頸而影響伺服器效能的資源區域主要有五個：實體磁碟、記憶體、處理序、CPU 和網路。如果上述任何一項資源使用過度，伺服器或應用程式就可能明顯變慢，或甚至當機。接下來我會一一解說每一個區域，針對您應該使用的計數器給予指引，並提供建議閾值來為伺服器把脈。
由於取樣間隔對於記錄檔和伺服器負載的大小有明顯的影響，因此最好能夠根據平均耗用時間來設定問題發生的取樣間隔，建立基準線，以避免問題再次發生。這樣可以幫助您找出導致問題的趨勢走向。
不消 15 分鐘的時間，就可以提供一個不賴的視窗，在進行一般作業時用來建立基準線。如果發生問題的平均耗用時間是四小時左右，請將取樣間隔設為 15 秒。如果發生問題的取樣間隔時間是八小時或八小時以上，取樣間隔就不要短於 5 分鐘；否則，最後記錄檔會變得巨大無比，而很難分析資料。

硬碟瓶頸
由於磁碟系統會儲存和處理伺服器的程式與資料，因此影響磁碟速度和使用情形的瓶頸，勢必會使伺服器的整體效能大打折扣。
請注意，如果伺服器尚未啟用磁碟物件，必須使用命令列工具 Diskperf 來啟用它們。另外還有一點，% Disk Time 可能會超過 100%，因此我比較喜歡使用 % Idle Time、Avg. Disk sec/Read 和 Avg. Disk sec/write 讓我更準確的瞭解硬碟的忙碌程度。您可以在知識庫文章 (support.microsoft.com/kb/310067) 找到更多關於 % Disk Time 的資訊。
下面是 Microsoft 服務支援工程師在監視磁碟所用的計數器。
LogicalDisk\% Free Space 它會測量所選邏輯磁碟機上的可用空間百分比。如果此值低於 15%，就要注意了，因為這表示儲存重要檔案的作業系統可用空間快要用完了。解決方法很簡單，就是增加磁碟空間。
PhysicalDisk\% Idle Time 它會測量在取樣間隔期間，磁碟閒置時間的百分比。如果這個計數器低於 20%，就表示磁碟系統已達飽和狀態。您可以考慮把目前的磁碟系統換成速度較快的磁碟系統。
PhysicalDisk\Avg.Disk Sec/Read  它會測量從磁碟讀取資料的平均時間 (以秒為單位)。如果此值大於 25 毫秒 (ms)，就表示磁碟系統從磁碟機讀取的速度有所延遲。如果是掌控 SQL Server® 和 Exchange Server 的重要伺服器，則能夠接受的閾值就更遠低於此，大約 10 毫秒左右。最符合邏輯的解決方案，是把磁碟系統換成速度更快的磁碟系統。
PhysicalDisk\Avg.Disk Sec/Write 它會測量將資料寫入磁碟的平均時間 (以秒為單位)。如果此值大於 25 毫秒，就表示磁碟系統寫入磁碟的速度有所延遲。如果是掌控 SQL Server 和 Exchange Server 的重要伺服器，則能夠接受的閾值就更遠低於此，大約 10 毫秒左右。最可能的解決方案，是把磁碟系統換成速度更快的磁碟系統。
PhysicalDisk\Avg.Disk Queue Length它會指出目前有多少個 I/O 作業正在等候使用磁碟機。如果此值大於磁針數再加上 2，就表示磁碟本身可能就是瓶頸所在。
Memory\Cache Bytes 它會指出檔案系統快取正在使用的記憶體量。如果此值大於 200MB，就表示可能發生磁碟瓶頸了。

get-counter -Counter "\Memory\Cache Bytes"


記憶體瓶頸
記憶體不足通常是因為 RAM 不足、記憶體流失或是將記憶體參數置於 boot.ini 內。在探討記憶體計數器之前，我應該先討論 /3GB 參數。
記憶體越多，越能減少磁碟 I/O 活動，並且提升應用程式效能。/3GB 參數當初是在 Windows NT® 中引進，它的作用是為採用使用者模式的程式提供更多記憶體。

Windows 所用的虛擬位址空間有 4GB (這與系統擁有多少實體 RAM 無關)。根據預設，較低層的 2GB 是保留給採用使用者模式的程式，而較上層的 2GB 則是保留給採用核心模式的程式。若使用 /3GB 參數，則會提供 3GB 給使用者模式的處理序。當然，如此一來會佔用到核心記憶體，使它只剩 1GB 的虛擬位址空間。而這樣可能會產生問題，因為 Pool Non-Paged Byte、Pool Paged Byte、Free System Page Tables Entries 和桌面堆積全部都擠在 1GB 的空間當中。因此，/3GB 參數應該只在環境中經過徹底測試之後再使用。
如果您懷疑您遇到的瓶頸與記憶體有關，可以考量這一點。如果 /3GB 參數不是問題癥結所在，則可以使用這些計數器來診斷可能的記憶體瓶頸。

Memory\% Committed Bytes in Use它會測量已被認可的位元組數與認可限制之間的比例 — 換句話說，就是使用中的虛擬記憶體量。如果此值大於 80%，就表示記憶體不足。解決方法很簡單，就是增加記憶體。
Memory\% Available Mbytes它會測量執行處理序所能使用的實體記憶體量 (以 MB 為單位)。如果此值小於總實體 RAM 的 5%，就表示記憶體不足，可能會增加分頁活動。解決這個問題的方法很簡單，只要增加記憶體就行了。
Memory\Free System Page Table Entries 它會指出系統目前未在使用中的分頁表項目數。如果此值小於 5,000，就表示有記憶體流失的現象發生。
Memory\Pool Non-Paged Bytes 它會測量非分頁集區的大小 (以位元組為單位)。這是系統記憶體區域，專門容納無法寫入磁碟、而必須留在實體記憶體的物件 (只要有配置物件的話)。如果此值大於 175MB (若使用 /3GB 參數的話，則為 100MB )，就表示可能有記憶體流失的現象發生。這時候系統事件記錄檔會記錄一般事件識別碼 2019。
Memory\Pool Non-Paged Bytes 它會測量分頁集區的大小 (以位元組為單位)。這是系統記憶體區域，專門容納在不使用的時候可以寫入磁碟的物件。如果此值大於 250MB (若使用 /3GB 參數的話，則為 170MB )，就表示可能有記憶體流失的現象發生。這時候系統事件記錄檔會記錄一般事件識別碼 2020。
Memory\Pages per Second 它會測量從磁碟讀取網頁或者將網頁寫入磁碟以解決硬體分頁錯誤的速率。如果此值大於 1000 (因為過量分頁的關係)，就表示可能有記憶體流失的現象發生。

處理器瓶頸
如果處理器體力透支，可能是因為處理器本身沒有提供足夠的電源，或者因為應用程式不足的關係。您必須再三檢查處理器是否耗費太多時間在分頁上面，而導致實體記憶體不足。
面是 Microsoft 服務支援工程師調查可能的處理器瓶頸所用的計數器。

Processor\% Processor Time    測量處理器在執行非閒置執行緒時，已耗用時間的百分比。如果此百分比大於 85%，就表示處理器已經筋疲力盡，伺服器需要換一個速度較快的處理器。
Processor\% User Time         測量處理器在使用者模式所耗用時間的百分比。如果此值很高，表示伺服器正忙著處理應用程式。也許您可以把即將用完處理器資源的應用程式最佳化，來解決這個問題。
Processor\% Interrupt Time    測量處理器在特定的取樣間隔期間，花在接收和處理硬體中斷的時間。如果此值大於 15%，就表示這個計數器可能有硬體問題。
System\Processor Queue Length 它會測量處理器佇列中的執行緒數目。如果此值大於延伸時段所用的 CPU 數目的兩倍，就表示伺服器沒有足夠的處理器電源。

網路瓶頸
網路瓶頸肯定會影響伺服器透過網路收送資料的能力。這可能是伺服器的網路卡問題，也可能是網路已經飽和，需要加以分段。您可以使用下列計數器來診斷可能的網路瓶頸。
Network Interface\Bytes Total/Sec 它會測量每一張網路介面卡收送位元組的速率 (包括結構字元在內)。如果您發現耗用的介面超過 70%，就表示網路已飽和。如果是 100-Mbps NIC，則耗用的介面是 8.7MB/秒 (100Mbps = 100000kbps = 12.5MB/秒* 70%)。碰到這種情形，可以安插一個較快的網路卡，或者將網路分段。
Network Interface\Output Queue Length 它會測量輸出封包佇列的長度 (以封包為單位)。如果此值大於 2，就表示網路已飽和。您可以安插一個較快的網路卡，或者將網路分段，來解決這個問題。

處理序瓶頸
如果您的處理序行為不當，或者沒有最佳化，就會使伺服器的效能大打折扣。執行緒和控制碼外洩最後會使伺服器當掉，而過度使用處理器，則會使伺服器變得如老牛拉車一樣慢。下面是診斷處理序相關瓶頸時不可或缺的計數器。
Process\Handle Count 它會測量處理序目前開啟的控制碼總數。如果此值大於 10,000，就表示可能有控制碼外洩的現象發生。
Process\Thread Count 它會測量處理序中目前有多少執行緒在作用中。如果此值介於執行緒數的上限和下限之間，並且大於 500，就表示可能有執行緒外洩的現象發生。
Process\Private Bytes它會指出這個處理序已經配置、而且不能與其他處理序共用的記憶體量。如果此值介於執行緒數的上限和下限之間，並且大於 250，就表示可能有記憶體流失的現象發生。


Do you have a list of SQL Server Counters you review when monitoring your SQL Server environment? Counters allow you a method to measure current performance, as well as performance over time. Identifying the metrics you like to use to measure SQL Server performance and collecting them over time gives you a quick and easy way to identify SQL Server problems, as well as graph your performance trend over time.

Below is my top 10 list of SQL Server counters in no particular order. For each counter I have described what it is, and in some cases I have described the ideal value of these counters. This list should give you a starting point for developing the metrics you want to use to measure database performance in your SQL Server environment.

1. SQLServer: Buffer Manager: Buffer cache hit ratio

The buffer cache hit ratio counter represents how often SQL Server is able to find data pages in its buffer cache when a query needs a data page. The higher this number the better, because it means SQL Server was able to get data for queries out of memory instead of reading from disk. You want this number to be as close to 100 as possible. Having this counter at 100 means that 100% of the time SQL Server has found the needed data pages in memory. A low buffer cache hit ratio could indicate a memory problem.

2. SQLServer: Buffer Manager: Page life expectancy

The page life expectancy counter measures how long pages stay in the buffer cache in seconds. The longer a page stays in memory, the more likely SQL Server will not need to read from disk to resolve a query. You should watch this counter over time to determine a baseline for what is normal in your database environment. Some say anything below 300 (or 5 minutes) means you might need additional memory.

3. SQLServer: SQL Statistics: Batch Requests/Sec

Batch Requests/Sec measures the number of batches SQL Server is receiving per second. This counter is a good indicator of how much activity is being processed by your SQL Server box. The higher the number, the more queries are being executed on your box. Like many counters, there is no single number that can be used universally to indicate your machine is too busy. Today’s machines are getting more and more powerful all the time and therefore can process more batch requests per second. You should review this counter over time to determine a baseline number for your environment.

4. SQLServer: SQL Statistics: SQL Compilations/Sec

The SQL Compilations/Sec measure the number of times SQL Server compiles an execution plan per second. Compiling an execution plan is a resource-intensive operation. Compilations/Sec should be compared with the number of Batch Requests/Sec to get an indication of whether or not complications might be hurting your performance. To do that, divide the number of batch requests by the number of compiles per second to give you a ratio of the number of batches executed per compile. Ideally you want to have one compile per every 10 batch requests.

5. SQLServer: SQL Statistics: SQL Re-Compilations/Sec

When the execution plan is invalidated due to some significant event, SQL Server will re-compile it. The Re-compilations/Sec counter measures the number of time a re-compile event was triggered per second. Re-compiles, like compiles, are expensive operations so you want to minimize the number of re-compiles. Ideally you want to keep this counter less than 10% of the number of Compilations/Sec.

6. SQLServer: General Statistics: User Connections

The user connections counter identifies the number of different users that are connected to SQL Server at the time the sample was taken. You need to watch this counter over time to understand your baseline user connection numbers. Once you have some idea of your high and low water marks during normal usage of your system, you can then look for times when this counter exceeds the high and low marks. If the value of this counter goes down and the load on the system is the same, then you might have a bottleneck that is not allowing your server to handle the normal load. Keep in mind though that this counter value might go down just because less people are using your SQL Server instance.

7. SQLServer: Locks: Lock Waits / Sec: _Total

In order for SQL Server to manage concurrent users on the system, SQL Server needs to lock resources from time to time. The lock waits per second counter tracks the number of times per second that SQL Server is not able to retain a lock right away for a resource. Ideally you don't want any request to wait for a lock. Therefore you want to keep this counter at zero, or close to zero at all times.

8. SQLServer: Access Methods: Page Splits / Sec

This counter measures the number of times SQL Server had to split a page when updating or inserting data per second. Page splits are expensive, and cause your table to perform more poorly due to fragmentation. Therefore, the fewer page splits you have the better your system will perform. Ideally this counter should be less than 20% of the batch requests per second.

9. SQLServer: General Statistic: Processes Block

The processes blocked counter identifies the number of blocked processes. When one process is blocking another process, the blocked process cannot move forward with its execution plan until the resource that is causing it to wait is freed up. Ideally you don't want to see any blocked processes. When processes are being blocked you should investigate.

10. SQLServer: Buffer Manager: Checkpoint Pages / Sec

The checkpoint pages per second counter measures the number of pages written to disk by a checkpoint operation. You should watch this counter over time to establish a baseline for your systems. Once a baseline value has been established you can watch this value to see if it is climbing. If this counter is climbing, it might mean you are running into memory pressures that are causing dirty pages to be flushed to disk more frequently than normal.

'
Get-Counter -ListSet *sqlserver* | Select-Object -ExpandProperty Paths

'\.NET Data Provider for SqlServer(*)\HardConnectsPerSecond
\.NET Data Provider for SqlServer(*)\HardDisconnectsPerSecond
\.NET Data Provider for SqlServer(*)\SoftConnectsPerSecond
\.NET Data Provider for SqlServer(*)\SoftDisconnectsPerSecond
\.NET Data Provider for SqlServer(*)\NumberOfNonPooledConnections
\.NET Data Provider for SqlServer(*)\NumberOfPooledConnections
\.NET Data Provider for SqlServer(*)\NumberOfActiveConnectionPoolGroups
\.NET Data Provider for SqlServer(*)\NumberOfInactiveConnectionPoolGroups
\.NET Data Provider for SqlServer(*)\NumberOfActiveConnectionPools
\.NET Data Provider for SqlServer(*)\NumberOfInactiveConnectionPools
\.NET Data Provider for SqlServer(*)\NumberOfActiveConnections
\.NET Data Provider for SqlServer(*)\NumberOfFreeConnections
\.NET Data Provider for SqlServer(*)\NumberOfStasisConnections
\.NET Data Provider for SqlServer(*)\NumberOfReclaimedConnections
\SQLServer:Memory Broker Clerks(*)\Memory broker clerk size
\SQLServer:Memory Broker Clerks(*)\Simulation benefit
\SQLServer:Memory Broker Clerks(*)\Simulation size
\SQLServer:Memory Broker Clerks(*)\Internal benefit
\SQLServer:Memory Broker Clerks(*)\Periodic evictions (pages)
\SQLServer:Memory Broker Clerks(*)\Pressure evictions (pages/sec)
\SQLServer:Buffer Manager\Buffer cache hit ratio
\SQLServer:Buffer Manager\Page lookups/sec
\SQLServer:Buffer Manager\Free list stalls/sec
\SQLServer:Buffer Manager\Database pages
\SQLServer:Buffer Manager\Target pages
\SQLServer:Buffer Manager\Integral Controller Slope
\SQLServer:Buffer Manager\Lazy writes/sec
\SQLServer:Buffer Manager\Readahead pages/sec
\SQLServer:Buffer Manager\Readahead time/sec
\SQLServer:Buffer Manager\Page reads/sec
\SQLServer:Buffer Manager\Page writes/sec
\SQLServer:Buffer Manager\Checkpoint pages/sec
\SQLServer:Buffer Manager\Background writer pages/sec
\SQLServer:Buffer Manager\Page life expectancy
\SQLServer:Buffer Manager\Extension page writes/sec
\SQLServer:Buffer Manager\Extension page reads/sec
\SQLServer:Buffer Manager\Extension outstanding IO counter
\SQLServer:Buffer Manager\Extension page evictions/sec
\SQLServer:Buffer Manager\Extension allocated pages
\SQLServer:Buffer Manager\Extension free pages
\SQLServer:Buffer Manager\Extension in use as percentage
\SQLServer:Buffer Manager\Extension page unreferenced time
\SQLServer:Buffer Node(*)\Database pages
\SQLServer:Buffer Node(*)\Page life expectancy
\SQLServer:Buffer Node(*)\Local node page lookups/sec
\SQLServer:Buffer Node(*)\Remote node page lookups/sec
\SQLServer:General Statistics\Active Temp Tables
\SQLServer:General Statistics\Temp Tables Creation Rate
\SQLServer:General Statistics\Logins/sec
\SQLServer:General Statistics\Connection Reset/sec
\SQLServer:General Statistics\Logouts/sec
\SQLServer:General Statistics\User Connections
\SQLServer:General Statistics\Logical Connections
\SQLServer:General Statistics\Transactions
\SQLServer:General Statistics\Non-atomic yield rate
\SQLServer:General Statistics\Mars Deadlocks
\SQLServer:General Statistics\HTTP Authenticated Requests
\SQLServer:General Statistics\SOAP Empty Requests
\SQLServer:General Statistics\SOAP SQL Requests
\SQLServer:General Statistics\SOAP Method Invocations
\SQLServer:General Statistics\SOAP WSDL Requests
\SQLServer:General Statistics\SOAP Session Initiate Requests
\SQLServer:General Statistics\SOAP Session Terminate Requests
\SQLServer:General Statistics\Processes blocked
\SQLServer:General Statistics\Temp Tables For Destruction
\SQLServer:General Statistics\Event Notifications Delayed Drop
\SQLServer:General Statistics\Trace Event Notification Queue
\SQLServer:General Statistics\SQL Trace IO Provider Lock Waits
\SQLServer:General Statistics\Tempdb recovery unit id
\SQLServer:General Statistics\Tempdb rowset id
\SQLServer:Locks(*)\Lock Requests/sec
\SQLServer:Locks(*)\Lock Timeouts/sec
\SQLServer:Locks(*)\Number of Deadlocks/sec
\SQLServer:Locks(*)\Lock Waits/sec
\SQLServer:Locks(*)\Lock Wait Time (ms)
\SQLServer:Locks(*)\Average Wait Time (ms)
\SQLServer:Locks(*)\Lock Timeouts (timeout > 0)/sec
\SQLServer:Databases(*)\Data File(s) Size (KB)
\SQLServer:Databases(*)\Log File(s) Size (KB)
\SQLServer:Databases(*)\Log File(s) Used Size (KB)
\SQLServer:Databases(*)\Percent Log Used
\SQLServer:Databases(*)\XTP Memory Used (KB)
\SQLServer:Databases(*)\Active Transactions
\SQLServer:Databases(*)\Transactions/sec
\SQLServer:Databases(*)\Repl. Pending Xacts
\SQLServer:Databases(*)\Repl. Trans. Rate
\SQLServer:Databases(*)\Log Cache Reads/sec
\SQLServer:Databases(*)\Log Cache Hit Ratio
\SQLServer:Databases(*)\Log Pool Requests/sec
\SQLServer:Databases(*)\Log Pool Cache Misses/sec
\SQLServer:Databases(*)\Log Pool Disk Reads/sec
\SQLServer:Databases(*)\Bulk Copy Rows/sec
\SQLServer:Databases(*)\Bulk Copy Throughput/sec
\SQLServer:Databases(*)\Backup/Restore Throughput/sec
\SQLServer:Databases(*)\DBCC Logical Scan Bytes/sec
\SQLServer:Databases(*)\Shrink Data Movement Bytes/sec
\SQLServer:Databases(*)\Log Flushes/sec
\SQLServer:Databases(*)\Log Bytes Flushed/sec
\SQLServer:Databases(*)\Log Flush Waits/sec
\SQLServer:Databases(*)\Log Flush Wait Time
\SQLServer:Databases(*)\Group Commit Time/sec
\SQLServer:Databases(*)\Log Flush Write Time (ms)
\SQLServer:Databases(*)\Log Truncations
\SQLServer:Databases(*)\Log Growths
\SQLServer:Databases(*)\Log Shrinks
\SQLServer:Databases(*)\Tracked transactions/sec
\SQLServer:Databases(*)\Write Transactions/sec
\SQLServer:Databases(*)\Commit table entries
\SQLServer:Database Mirroring(*)\Bytes Sent/sec
\SQLServer:Database Mirroring(*)\Pages Sent/sec
\SQLServer:Database Mirroring(*)\Sends/sec
\SQLServer:Database Mirroring(*)\Transaction Delay
\SQLServer:Database Mirroring(*)\Redo Queue KB
\SQLServer:Database Mirroring(*)\Redo Bytes/sec
\SQLServer:Database Mirroring(*)\Log Send Queue KB
\SQLServer:Database Mirroring(*)\Bytes Received/sec
\SQLServer:Database Mirroring(*)\Receives/sec
\SQLServer:Database Mirroring(*)\Log Bytes Received/sec
\SQLServer:Database Mirroring(*)\Log Bytes Sent/sec
\SQLServer:Database Mirroring(*)\Send/Receive Ack Time
\SQLServer:Database Mirroring(*)\Log Compressed Bytes Rcvd/sec
\SQLServer:Database Mirroring(*)\Log Compressed Bytes Sent/sec
\SQLServer:Database Mirroring(*)\Mirrored Write Transactions/sec
\SQLServer:Database Mirroring(*)\Log Scanned for Undo KB
\SQLServer:Database Mirroring(*)\Log Remaining for Undo KB
\SQLServer:Database Mirroring(*)\Log Bytes Sent from Cache/sec
\SQLServer:Database Mirroring(*)\Log Bytes Redone from Cache/sec
\SQLServer:Database Mirroring(*)\Log Send Flow Control Time (ms)
\SQLServer:Database Mirroring(*)\Log Harden Time (ms)
\SQLServer:Database Replica(*)\Recovery Queue
\SQLServer:Database Replica(*)\Redone Bytes/sec
\SQLServer:Database Replica(*)\Log Send Queue
\SQLServer:Database Replica(*)\Log Bytes Received/sec
\SQLServer:Database Replica(*)\File Bytes Received/sec
\SQLServer:Database Replica(*)\Mirrored Write Transactions/sec
\SQLServer:Database Replica(*)\Transaction Delay
\SQLServer:Database Replica(*)\Total Log requiring undo
\SQLServer:Database Replica(*)\Log remaining for undo
\SQLServer:Database Replica(*)\Redo Bytes Remaining
\SQLServer:Database Replica(*)\Redo blocked/sec
\SQLServer:Availability Replica(*)\Bytes Sent to Replica/sec
\SQLServer:Availability Replica(*)\Sends to Replica/sec
\SQLServer:Availability Replica(*)\Bytes Sent to Transport/sec
\SQLServer:Availability Replica(*)\Sends to Transport/sec
\SQLServer:Availability Replica(*)\Bytes Received from Replica/sec
\SQLServer:Availability Replica(*)\Receives from Replica/sec
\SQLServer:Availability Replica(*)\Flow Control Time (ms/sec)
\SQLServer:Availability Replica(*)\Flow Control/sec
\SQLServer:Availability Replica(*)\Resent Messages/sec
\SQLServer:Latches\Latch Waits/sec
\SQLServer:Latches\Average Latch Wait Time (ms)
\SQLServer:Latches\Total Latch Wait Time (ms)
\SQLServer:Latches\Number of SuperLatches
\SQLServer:Latches\SuperLatch Promotions/sec
\SQLServer:Latches\SuperLatch Demotions/sec
\SQLServer:Access Methods\Full Scans/sec
\SQLServer:Access Methods\Range Scans/sec
\SQLServer:Access Methods\Probe Scans/sec
\SQLServer:Access Methods\Scan Point Revalidations/sec
\SQLServer:Access Methods\Workfiles Created/sec
\SQLServer:Access Methods\Worktables Created/sec
\SQLServer:Access Methods\Worktables From Cache Ratio
\SQLServer:Access Methods\Forwarded Records/sec
\SQLServer:Access Methods\Skipped Ghosted Records/sec
\SQLServer:Access Methods\Index Searches/sec
\SQLServer:Access Methods\FreeSpace Scans/sec
\SQLServer:Access Methods\FreeSpace Page Fetches/sec
\SQLServer:Access Methods\Pages Allocated/sec
\SQLServer:Access Methods\Extents Allocated/sec
\SQLServer:Access Methods\Mixed page allocations/sec
\SQLServer:Access Methods\Extent Deallocations/sec
\SQLServer:Access Methods\Page Deallocations/sec
\SQLServer:Access Methods\Page Splits/sec
\SQLServer:Access Methods\Table Lock Escalations/sec
\SQLServer:Access Methods\Deferred Dropped rowsets
\SQLServer:Access Methods\Dropped rowset cleanups/sec
\SQLServer:Access Methods\Dropped rowsets skipped/sec
\SQLServer:Access Methods\Deferred dropped AUs
\SQLServer:Access Methods\AU cleanups/sec
\SQLServer:Access Methods\AU cleanup batches/sec
\SQLServer:Access Methods\Failed AU cleanup batches/sec
\SQLServer:Access Methods\Used tree page cookie
\SQLServer:Access Methods\Failed tree page cookie
\SQLServer:Access Methods\Used leaf page cookie
\SQLServer:Access Methods\Failed leaf page cookie
\SQLServer:Access Methods\LobSS Provider Create Count
\SQLServer:Access Methods\LobSS Provider Destroy Count
\SQLServer:Access Methods\LobSS Provider Truncation Count
\SQLServer:Access Methods\LobHandle Create Count
\SQLServer:Access Methods\LobHandle Destroy Count
\SQLServer:Access Methods\By-reference Lob Create Count
\SQLServer:Access Methods\By-reference Lob Use Count
\SQLServer:Access Methods\Count Push Off Row
\SQLServer:Access Methods\Count Pull In Row
\SQLServer:Access Methods\Count Lob Readahead
\SQLServer:Access Methods\Page compression attempts/sec
\SQLServer:Access Methods\Pages compressed/sec
\SQLServer:Access Methods\InSysXact waits/sec
\SQLServer:SQL Errors(*)\Errors/sec
\SQLServer:SQL Statistics\Batch Requests/sec
\SQLServer:SQL Statistics\Forced Parameterizations/sec
\SQLServer:SQL Statistics\Auto-Param Attempts/sec
\SQLServer:SQL Statistics\Failed Auto-Params/sec
\SQLServer:SQL Statistics\Safe Auto-Params/sec
\SQLServer:SQL Statistics\Unsafe Auto-Params/sec
\SQLServer:SQL Statistics\SQL Compilations/sec
\SQLServer:SQL Statistics\SQL Re-Compilations/sec
\SQLServer:SQL Statistics\SQL Attention rate
\SQLServer:SQL Statistics\Guided plan executions/sec
\SQLServer:SQL Statistics\Misguided plan executions/sec
\SQLServer:Plan Cache(*)\Cache Hit Ratio
\SQLServer:Plan Cache(*)\Cache Pages
\SQLServer:Plan Cache(*)\Cache Object Counts
\SQLServer:Plan Cache(*)\Cache Objects in use
\SQLServer:Cursor Manager by Type(*)\Cache Hit Ratio
\SQLServer:Cursor Manager by Type(*)\Cached Cursor Counts
\SQLServer:Cursor Manager by Type(*)\Cursor Cache Use Counts/sec
\SQLServer:Cursor Manager by Type(*)\Cursor Requests/sec
\SQLServer:Cursor Manager by Type(*)\Active cursors
\SQLServer:Cursor Manager by Type(*)\Cursor memory usage
\SQLServer:Cursor Manager by Type(*)\Cursor worktable usage
\SQLServer:Cursor Manager by Type(*)\Number of active cursor plans
\SQLServer:Cursor Manager Total\Cursor conversion rate
\SQLServer:Cursor Manager Total\Async population count
\SQLServer:Cursor Manager Total\Cursor flushes
\SQLServer:Memory Manager\External benefit of memory
\SQLServer:Memory Manager\Connection Memory (KB)
\SQLServer:Memory Manager\Database Cache Memory (KB)
\SQLServer:Memory Manager\Free Memory (KB)
\SQLServer:Memory Manager\Granted Workspace Memory (KB)
\SQLServer:Memory Manager\Lock Memory (KB)
\SQLServer:Memory Manager\Lock Blocks Allocated
\SQLServer:Memory Manager\Lock Owner Blocks Allocated
\SQLServer:Memory Manager\Lock Blocks
\SQLServer:Memory Manager\Lock Owner Blocks
\SQLServer:Memory Manager\Maximum Workspace Memory (KB)
\SQLServer:Memory Manager\Memory Grants Outstanding
\SQLServer:Memory Manager\Memory Grants Pending
\SQLServer:Memory Manager\Optimizer Memory (KB)
\SQLServer:Memory Manager\Reserved Server Memory (KB)
\SQLServer:Memory Manager\SQL Cache Memory (KB)
\SQLServer:Memory Manager\Stolen Server Memory (KB)
\SQLServer:Memory Manager\Log Pool Memory (KB)
\SQLServer:Memory Manager\Target Server Memory (KB)
\SQLServer:Memory Manager\Total Server Memory (KB)
\SQLServer:Memory Node(*)\Database Node Memory (KB)
\SQLServer:Memory Node(*)\Free Node Memory (KB)
\SQLServer:Memory Node(*)\Foreign Node Memory (KB)
\SQLServer:Memory Node(*)\Stolen Node Memory (KB)
\SQLServer:Memory Node(*)\Target Node Memory (KB)
\SQLServer:Memory Node(*)\Total Node Memory (KB)
\SQLServer:User Settable(*)\Query
\SQLServer:Replication Agents(*)\Running
\SQLServer:Replication Merge(*)\Uploaded Changes/sec
\SQLServer:Replication Merge(*)\Downloaded Changes/sec
\SQLServer:Replication Merge(*)\Conflicts/sec
\SQLServer:Replication Logreader(*)\Logreader:Delivery Latency
\SQLServer:Replication Logreader(*)\Logreader:Delivered Cmds/sec
\SQLServer:Replication Logreader(*)\Logreader:Delivered Trans/sec
\SQLServer:Replication Dist.(*)\Dist:Delivery Latency
\SQLServer:Replication Dist.(*)\Dist:Delivered Cmds/sec
\SQLServer:Replication Dist.(*)\Dist:Delivered Trans/sec
\SQLServer:Replication Snapshot(*)\Snapshot:Delivered Cmds/sec
\SQLServer:Replication Snapshot(*)\Snapshot:Delivered Trans/sec
\SQLServer:Backup Device(*)\Device Throughput Bytes/sec
\SQLServer:Transactions\Transactions
\SQLServer:Transactions\Snapshot Transactions
\SQLServer:Transactions\Update Snapshot Transactions
\SQLServer:Transactions\NonSnapshot Version Transactions
\SQLServer:Transactions\Longest Transaction Running Time
\SQLServer:Transactions\Update conflict ratio
\SQLServer:Transactions\Free Space in tempdb (KB)
\SQLServer:Transactions\Version Generation rate (KB/s)
\SQLServer:Transactions\Version Cleanup rate (KB/s)
\SQLServer:Transactions\Version Store Size (KB)
\SQLServer:Transactions\Version Store unit count
\SQLServer:Transactions\Version Store unit creation
\SQLServer:Transactions\Version Store unit truncation
\SQLServer:Broker Statistics\SQL SENDs/sec
\SQLServer:Broker Statistics\SQL SEND Total
\SQLServer:Broker Statistics\SQL RECEIVEs/sec
\SQLServer:Broker Statistics\SQL RECEIVE Total
\SQLServer:Broker Statistics\Broker Transaction Rollbacks
\SQLServer:Broker Statistics\Dialog Timer Event Count
\SQLServer:Broker Statistics\Enqueued Messages/sec
\SQLServer:Broker Statistics\Enqueued P1 Messages/sec
\SQLServer:Broker Statistics\Enqueued P2 Messages/sec
\SQLServer:Broker Statistics\Enqueued P3 Messages/sec
\SQLServer:Broker Statistics\Enqueued P4 Messages/sec
\SQLServer:Broker Statistics\Enqueued P5 Messages/sec
\SQLServer:Broker Statistics\Enqueued P6 Messages/sec
\SQLServer:Broker Statistics\Enqueued P7 Messages/sec
\SQLServer:Broker Statistics\Enqueued P8 Messages/sec
\SQLServer:Broker Statistics\Enqueued P9 Messages/sec
\SQLServer:Broker Statistics\Enqueued P10 Messages/sec
\SQLServer:Broker Statistics\Enqueued Local Messages/sec
\SQLServer:Broker Statistics\Enqueued Transport Msgs/sec
\SQLServer:Broker Statistics\Enqueued Transport Msg Frags/sec
\SQLServer:Broker Statistics\Enqueued Messages Total
\SQLServer:Broker Statistics\Enqueued Local Messages Total
\SQLServer:Broker Statistics\Enqueued Transport Msgs Total
\SQLServer:Broker Statistics\Enqueued Transport Msg Frag Tot
\SQLServer:Broker Statistics\Forwarded Pending Msg Count
\SQLServer:Broker Statistics\Forwarded Pending Msg Bytes
\SQLServer:Broker Statistics\Forwarded Msgs Discarded/sec
\SQLServer:Broker Statistics\Forwarded Msg Discarded Total
\SQLServer:Broker Statistics\Forwarded Messages/sec
\SQLServer:Broker Statistics\Forwarded Messages Total
\SQLServer:Broker Statistics\Forwarded Msg Bytes/sec
\SQLServer:Broker Statistics\Forwarded Msg Byte Total
\SQLServer:Broker Statistics\Enqueued TransmissionQ Msgs/sec
\SQLServer:Broker Statistics\Dequeued TransmissionQ Msgs/sec
\SQLServer:Broker Statistics\Dropped Messages Total
\SQLServer:Broker Statistics\Corrupted Messages Total
\SQLServer:Broker Statistics\Activation Errors Total
\SQLServer:Broker/DBM Transport\Open Connection Count
\SQLServer:Broker/DBM Transport\Send I/Os/sec
\SQLServer:Broker/DBM Transport\Send I/O bytes/sec
\SQLServer:Broker/DBM Transport\Send I/O Len Avg
\SQLServer:Broker/DBM Transport\Receive I/Os/sec
\SQLServer:Broker/DBM Transport\Receive I/O bytes/sec
\SQLServer:Broker/DBM Transport\Receive I/O Len Avg
\SQLServer:Broker/DBM Transport\Message Fragment Sends/sec
\SQLServer:Broker/DBM Transport\Message Fragment P1 Sends/sec
\SQLServer:Broker/DBM Transport\Message Fragment P2 Sends/sec
\SQLServer:Broker/DBM Transport\Message Fragment P3 Sends/sec
\SQLServer:Broker/DBM Transport\Message Fragment P4 Sends/sec
\SQLServer:Broker/DBM Transport\Message Fragment P5 Sends/sec
\SQLServer:Broker/DBM Transport\Message Fragment P6 Sends/sec
\SQLServer:Broker/DBM Transport\Message Fragment P7 Sends/sec
\SQLServer:Broker/DBM Transport\Message Fragment P8 Sends/sec
\SQLServer:Broker/DBM Transport\Message Fragment P9 Sends/sec
\SQLServer:Broker/DBM Transport\Message Fragment P10 Sends/sec
\SQLServer:Broker/DBM Transport\Msg Fragment Send Size Avg
\SQLServer:Broker/DBM Transport\Message Fragment Receives/sec
\SQLServer:Broker/DBM Transport\Msg Fragment Recv Size Avg
\SQLServer:Broker/DBM Transport\Pending Msg Frags for Send I/O
\SQLServer:Broker/DBM Transport\Current Msg Frags for Send I/O
\SQLServer:Broker/DBM Transport\Pending Bytes for Send I/O
\SQLServer:Broker/DBM Transport\Current Bytes for Send I/O
\SQLServer:Broker/DBM Transport\Pending Msg Frags for Recv I/O
\SQLServer:Broker/DBM Transport\Current Bytes for Recv I/O
\SQLServer:Broker/DBM Transport\Pending Bytes for Recv I/O
\SQLServer:Broker/DBM Transport\Recv I/O Buffer Copies Count
\SQLServer:Broker/DBM Transport\Recv I/O Buffer Copies bytes/sec
\SQLServer:Broker Activation(*)\Tasks Started/sec
\SQLServer:Broker Activation(*)\Tasks Running
\SQLServer:Broker Activation(*)\Tasks Aborted/sec
\SQLServer:Broker Activation(*)\Task Limit Reached/sec
\SQLServer:Broker Activation(*)\Task Limit Reached
\SQLServer:Broker Activation(*)\Stored Procedures Invoked/sec
\SQLServer:Broker TO Statistics\Transmission Obj Gets/Sec
\SQLServer:Broker TO Statistics\Transmission Obj Set Dirty/Sec
\SQLServer:Broker TO Statistics\Transmission Obj Writes/Sec
\SQLServer:Broker TO Statistics\Avg. Length of Batched Writes
\SQLServer:Broker TO Statistics\Avg. Time to Write Batch (ms)
\SQLServer:Broker TO Statistics\Avg. Time Between Batches (ms)
\SQLServer:Wait Statistics(*)\Lock waits
\SQLServer:Wait Statistics(*)\Memory grant queue waits
\SQLServer:Wait Statistics(*)\Thread-safe memory objects waits
\SQLServer:Wait Statistics(*)\Log write waits
\SQLServer:Wait Statistics(*)\Log buffer waits
\SQLServer:Wait Statistics(*)\Network IO waits
\SQLServer:Wait Statistics(*)\Page IO latch waits
\SQLServer:Wait Statistics(*)\Page latch waits
\SQLServer:Wait Statistics(*)\Non-Page latch waits
\SQLServer:Wait Statistics(*)\Wait for the worker
\SQLServer:Wait Statistics(*)\Workspace synchronization waits
\SQLServer:Wait Statistics(*)\Transaction ownership waits
\SQLServer:Exec Statistics(*)\Extended Procedures
\SQLServer:Exec Statistics(*)\DTC calls
\SQLServer:Exec Statistics(*)\OLEDB calls
\SQLServer:Exec Statistics(*)\Distributed Query
\SQLServer:CLR\CLR Execution
\SQLServer:Catalog Metadata(*)\Cache Hit Ratio
\SQLServer:Catalog Metadata(*)\Cache Entries Count
\SQLServer:Catalog Metadata(*)\Cache Entries Pinned Count
\SQLServer:Deprecated Features(*)\Usage
\SQLServer:Workload Group Stats(*)\CPU usage %
\SQLServer:Workload Group Stats(*)\Queued requests
\SQLServer:Workload Group Stats(*)\Active requests
\SQLServer:Workload Group Stats(*)\Requests completed/sec
\SQLServer:Workload Group Stats(*)\Max request cpu time (ms)
\SQLServer:Workload Group Stats(*)\Blocked tasks
\SQLServer:Workload Group Stats(*)\Reduced memory grants/sec
\SQLServer:Workload Group Stats(*)\Max request memory grant (KB)
\SQLServer:Workload Group Stats(*)\Query optimizations/sec
\SQLServer:Workload Group Stats(*)\Suboptimal plans/sec
\SQLServer:Workload Group Stats(*)\Active parallel threads
\SQLServer:Resource Pool Stats(*)\CPU usage %
\SQLServer:Resource Pool Stats(*)\CPU usage target %
\SQLServer:Resource Pool Stats(*)\CPU control effect %
\SQLServer:Resource Pool Stats(*)\Compile memory target (KB)
\SQLServer:Resource Pool Stats(*)\Cache memory target (KB)
\SQLServer:Resource Pool Stats(*)\Query exec memory target (KB)
\SQLServer:Resource Pool Stats(*)\Memory grants/sec
\SQLServer:Resource Pool Stats(*)\Active memory grants count
\SQLServer:Resource Pool Stats(*)\Memory grant timeouts/sec
\SQLServer:Resource Pool Stats(*)\Active memory grant amount (KB)
\SQLServer:Resource Pool Stats(*)\Pending memory grants count
\SQLServer:Resource Pool Stats(*)\Max memory (KB)
\SQLServer:Resource Pool Stats(*)\Used memory (KB)
\SQLServer:Resource Pool Stats(*)\Target memory (KB)
\SQLServer:Resource Pool Stats(*)\Disk Read IO/sec
\SQLServer:Resource Pool Stats(*)\Disk Read IO Throttled/sec
\SQLServer:Resource Pool Stats(*)\Disk Read Bytes/sec
\SQLServer:Resource Pool Stats(*)\Avg Disk Read IO (ms)
\SQLServer:Resource Pool Stats(*)\Disk Write IO/sec
\SQLServer:Resource Pool Stats(*)\Disk Write IO Throttled/sec
\SQLServer:Resource Pool Stats(*)\Disk Write Bytes/sec
\SQLServer:Resource Pool Stats(*)\Avg Disk Write IO (ms)
\SQLServer:FileTable\FileTable db operations/sec
\SQLServer:FileTable\FileTable table operations/sec
\SQLServer:FileTable\FileTable item get requests/sec
\SQLServer:FileTable\Avg time to get FileTable item
\SQLServer:FileTable\FileTable item delete reqs/sec
\SQLServer:FileTable\Avg time delete FileTable item
\SQLServer:FileTable\FileTable item update reqs/sec
\SQLServer:FileTable\Avg time update FileTable item
\SQLServer:FileTable\FileTable item move reqs/sec
\SQLServer:FileTable\Avg time move FileTable item
\SQLServer:FileTable\FileTable item rename reqs/sec
\SQLServer:FileTable\Avg time rename FileTable item
\SQLServer:FileTable\FileTable enumeration reqs/sec
\SQLServer:FileTable\Avg time FileTable enumeration
\SQLServer:FileTable\FileTable file I/O requests/sec
\SQLServer:FileTable\Avg time per file I/O request
\SQLServer:FileTable\FileTable file I/O response/sec
\SQLServer:FileTable\Avg time per file I/O response
\SQLServer:FileTable\FileTable kill handle ops/sec
\SQLServer:FileTable\Avg time FileTable handle kill
\SQLServer:Batch Resp Statistics(*)\Batches >=000000ms & <000001ms
\SQLServer:Batch Resp Statistics(*)\Batches >=000001ms & <000002ms
\SQLServer:Batch Resp Statistics(*)\Batches >=000002ms & <000005ms
\SQLServer:Batch Resp Statistics(*)\Batches >=000005ms & <000010ms
\SQLServer:Batch Resp Statistics(*)\Batches >=000010ms & <000020ms
\SQLServer:Batch Resp Statistics(*)\Batches >=000020ms & <000050ms
\SQLServer:Batch Resp Statistics(*)\Batches >=000050ms & <000100ms
\SQLServer:Batch Resp Statistics(*)\Batches >=000100ms & <000200ms
\SQLServer:Batch Resp Statistics(*)\Batches >=000200ms & <000500ms
\SQLServer:Batch Resp Statistics(*)\Batches >=000500ms & <001000ms
\SQLServer:Batch Resp Statistics(*)\Batches >=001000ms & <002000ms
\SQLServer:Batch Resp Statistics(*)\Batches >=002000ms & <005000ms
\SQLServer:Batch Resp Statistics(*)\Batches >=005000ms & <010000ms
\SQLServer:Batch Resp Statistics(*)\Batches >=010000ms & <020000ms
\SQLServer:Batch Resp Statistics(*)\Batches >=020000ms & <050000ms
\SQLServer:Batch Resp Statistics(*)\Batches >=050000ms & <100000ms
\SQLServer:Batch Resp Statistics(*)\Batches >=100000ms
\SQLServer:HTTP Storage(*)\Read Bytes/Sec
\SQLServer:HTTP Storage(*)\Write Bytes/Sec
\SQLServer:HTTP Storage(*)\Total Bytes/Sec
\SQLServer:HTTP Storage(*)\Reads/Sec
\SQLServer:HTTP Storage(*)\Writes/Sec
\SQLServer:HTTP Storage(*)\Transfers/Sec
\SQLServer:HTTP Storage(*)\Avg. Bytes/Read
\SQLServer:HTTP Storage(*)\Avg. Bytes/Write
\SQLServer:HTTP Storage(*)\Avg. Bytes/Transfer
\SQLServer:HTTP Storage(*)\Avg. microsec/Read
\SQLServer:HTTP Storage(*)\Avg. microsec/Write
\SQLServer:HTTP Storage(*)\Avg. microsec/Transfer
\SQLServer:HTTP Storage(*)\Outstanding HTTP Storage IO
\SQLServer:HTTP Storage(*)\HTTP Storage IO retry/sec
'