sp_helpfile
/*
USE CAPTAIN;
GO
-- Truncate the log by first changing the database recovery model to SIMPLE.
ALTER DATABASE CAPTAIN
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (ENAT_Log, 1); -- Logical Name of Log file
GO
-- Reset the database recovery model.
ALTER DATABASE Captain
SET RECOVERY FULL;
GO
*/


/*
USE Wireless;
GO
-- Truncate the log by first changing the database recovery model to SIMPLE.
ALTER DATABASE Wireless
SET RECOVERY SIMPLE;
GO
DBCC SHRINKFILE (Wireless_Log, 1);
DBCC SHRINKFILE (Wirelss_Log2, 1);
GO
-- Reset database recovery mode
ALTER DATABASE Wireless
SET RECOVERY BULK_LOGGED;
GO
*/