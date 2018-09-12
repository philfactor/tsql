-- backup size trend for last 30 days
-- 2018/03/01
USE [msdb];
GO
SELECT TOP 30 
	name, 
	backup_start_date, 
	(backup_size/1073741824) as 'backup size (GB)' 
FROM 
	backupset
WHERE 
	database_name = 'TL_REPORTS'
ORDER BY 
	backup_start_date DESC