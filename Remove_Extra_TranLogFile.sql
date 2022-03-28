

-- 1. Reset the database recovery model to FULL.
ALTER DATABASE [ICO]
SET RECOVERY FULL;
GO

-- 2. Backup database FULL
BACKUP DATABASE [ICO] TO  DISK = N'I:\SQL_I\BU\ICO_pjs_09032014' 
WITH NOFORMAT, NOINIT,  NAME = N'ICO-Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO

-- 3. backup transaction log
BACKUP LOG [ICO] TO DISK = 'I:\SQL_I\BU\ICO_pjs_09032014_2.trn'

-- 4. Reset database recovery model to SIMPLE
ALTER DATABASE [ICO]
SET RECOVERY SIMPLE;
GO

CHECKPOINT

-- 5. truncate transaction log
USE [ICO]
GO
DBCC SHRINKFILE (N'ICO_Log2' , EMPTYFILE)
GO

CHECKPOINT

-- 6. remove transaction log file
USE [ICO]
GO
ALTER DATABASE [ICO]  REMOVE FILE [ICO_Log2]
GO


-- tempdb on PSQLACSR0001\ACSR01
DBCC SHRINKFILE: Page 10:6808367 could not be moved because it is a work table page.
Msg 2555, Level 16, State 1, Line 5
Cannot move all contents of file "tempdev1" to other places to complete the emptyfile operation.
DBCC execution completed. If DBCC printed error messages, contact your system administrator.

Completion time: 2021-03-16T08:57:00.0174727-07:00
