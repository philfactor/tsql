-- https://www.sqlservercentral.com/blogs/four-ways-to-find-free-space-in-sql-server-database

USE [ODS_AdvancedPlanning];
GO
SELECT DB_NAME() AS DbName,
name ASFileName,
size/128.0 AS CurrentSizeMB,
size/128.0 -CAST(FILEPROPERTY(name,'SpaceUsed')AS INT)/128.0 AS FreeSpaceMB 
FROM sys.database_files;