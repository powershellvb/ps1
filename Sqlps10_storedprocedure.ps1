﻿


#---------------------------------------------------------------
#   CREATE PROCEDURE
#---------------------------------------------------------------

sp_configure 'Show Advanced Options', 1
GO
RECONFIGURE
GO
sp_configure 'Ad Hoc Distributed Queries', 1
GO
RECONFIGURE
GO


#---------------------------------------------------------------
#   CREATE PROCEDURE
#---------------------------------------------------------------

CREATE TABLE dbo.MyFamily(ID INT IDENTITY(1,1),Name VARCHAR(50))

#---------------------------------------------------------------
#    get PROCEDURE  Text
#---------------------------------------------------------------
## --
select * from sys.objects  where type='P'

sp_helptext sp_who
##- 
use msdb
sys.sql_modules m
join sys.objects o on o.object_id=m.object_id

#---------------------------------------------------------------
#   Search Text in Stored Procedure in SQL
#---------------------------------------------------------------
SELECT DISTINCT o.name AS Object_Name,o.type_desc
FROM sys.sql_modules m 
INNER JOIN sys.objects o 
ON m.object_id=o.object_id
WHERE m.definition Like '%[ABD]%'
WHERE m.definition Like '%\[ABD\]%' ESCAPE '\'