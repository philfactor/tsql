-- https://www.sqlshack.com/shrinking-your-database-using-dbcc-shrinkfile/

USE SQLShack
GO
 
DECLARE @FileName sysname = N'SQLShack';
DECLARE @TargetSize INT = (SELECT 1 + size*8./1024 FROM sys.database_files WHERE name = @FileName);
DECLARE @Factor FLOAT = .999;
 
WHILE @TargetSize > 0
BEGIN
    SET @TargetSize *= @Factor;
    DBCC SHRINKFILE(@FileName, @TargetSize);
    DECLARE @msg VARCHAR(200) = CONCAT('Shrink file completed. Target Size: ', 
         @TargetSize, ' MB. Timestamp: ', CURRENT_TIMESTAMP);
    RAISERROR(@msg, 1, 1) WITH NOWAIT;
    WAITFOR DELAY '00:00:01';
END;

/*
SELECT TYPE_DESC, NAME, size, max_size, growth, is_percent_growth 
FROM sys.database_files;
*/

--Check size
-- https://www.mssqltips.com/sqlservertip/4368/execute-sql-server-dbcc-shrinkfile-without-causing-index-fragmentation/
USE [PSCO]
GO
SELECT DB_NAME() AS DbName, 
name AS FileName, 
size/128.0 AS CurrentSizeMB, 
size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB, 
(size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0)/(size/128.0) * 100 AS FreeSpacePct -- added by Phil
FROM sys.database_files
WHERE type_desc = 'ROWS'
GO