-- https://www.mssqltips.com/sqlservertip/1601/script-to-retrieve-sql-server-database-backup-history-and-no-backups/

--------------------------------------------------------------------------------- 
--Database Backups for all databases For Previous 30 Days 
--------------------------------------------------------------------------------- 
SELECT 
CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
msdb.dbo.backupset.database_name, 
msdb.dbo.backupset.backup_start_date, 
msdb.dbo.backupset.backup_finish_date, 
msdb.dbo.backupset.expiration_date, 
CASE msdb..backupset.type 
WHEN 'D' THEN 'Database' 
WHEN 'L' THEN 'Log' 
END AS backup_type, 
(cast(msdb.dbo.backupset.backup_size as bigint) /1048576) AS 'backup_size (MB)', -- msdb.dbo.backupset.backup_size, 
msdb.dbo.backupmediafamily.logical_device_name, 
msdb.dbo.backupmediafamily.physical_device_name, 
msdb.dbo.backupset.name AS backupset_name, 
msdb.dbo.backupset.description 
FROM msdb.dbo.backupmediafamily 
INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
WHERE database_name = 'ARCS' and (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 30) and backupset.name IS NOT NULL
ORDER BY 
msdb.dbo.backupset.backup_finish_date 