--https://dba.stackexchange.com/questions/31776/sql-server-2012-database-backup-successfully-report-but-no-backup-file

/*
Find Where DB Backups Went Physical Location
For last two days.  
backupset.type  
D --> FULL
I --> DIff or incrimental 
L --> Log backups
*/

DECLARE @dbname     sysname
SET @dbname = ''

SELECT  
     @@servername [ServerName]
    ,master.sys.sysdatabases.name [DatabaseName]
    ,msdb.dbo.backupset.backup_start_date [Backup Date]
    ,msdb.dbo.backupset.user_name
    ,datediff(second, msdb.dbo.backupset.backup_start_date,
    msdb.dbo.backupset.backup_finish_date) [Duration-seconds]
    ,msdb.dbo.backupmediafamily.physical_device_name [File Location]    
    ,msdb.dbo.backupset.type
FROM
    msdb.dbo.backupmediafamily,
    master.sys.sysdatabases
    LEFT OUTER JOIN
    msdb.dbo.backupset 
    ON master.sys.sysdatabases.name = msdb.dbo.backupset.database_name  
WHERE 
    msdb.dbo.backupset.type in( 'D', 'I', 'L')
AND msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id
and msdb.dbo.backupset.backup_start_date > getdate() - 2
AND master.sys.sysdatabases.name not in ('pubs','northwind', 'tempdb','adventureworks')
AND master.sys.sysdatabases.name like '%' + @dbname + '%'
ORDER BY    
    master.sys.sysdatabases.name
    ,msdb.dbo.backupset.backup_start_date 
    ,msdb.dbo.backupset.backup_finish_date
    ,msdb.dbo.backupmediafamily.physical_device_name
    ,msdb.dbo.backupset.type