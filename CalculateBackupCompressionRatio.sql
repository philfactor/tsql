-- http://technet.microsoft.com/en-us/library/bb964719(v=sql.110).aspx#CompressionRatio
-- CalculateBackupCompressionRatio.sql

USE [msdb];
GO

SELECT 
	name as 'database_name',
	recovery_model, 
	backup_start_date as 'start_date', 
	backup_size/compressed_backup_size as 'compression_ratio' 
FROM 
	backupset
WHERE 
	backup_start_date > '2014-09-02'
	AND database_name NOT IN ('master','model','msdb','tempdb')
	AND type <> 'L';

-- select * from msdb..backupset
