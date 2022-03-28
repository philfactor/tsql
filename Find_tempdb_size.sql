--https://sqlwhisper.wordpress.com/2013/03/16/tempdb-actual-current-size/

USE [tempdb];
GO
SELECT 
	Name,
	type_desc,
	Physical_Name, 
	((size*8)/1024) as SIZE_IN_MB, 
	((size*8)/1024/1024) as SIZE_IN_GB 
FROM 
	sys.master_files 
WHERE 
	database_id=2
	AND type_desc <> 'LOG'
	
-- also check
--https://www.mssqltips.com/sqlservertip/4829/tempdb-size-resets-after-a-sql-server-service-restart/