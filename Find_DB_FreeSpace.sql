/****************************************************************************************
* Object Name:	Find_DB_FreeSpace.sql
* Object Type:	External DMV script 
* Author:		Phil Streiff, MCDBA
* Date:			08/07/09
* Purpose:		Shows total size & free space of db in MB
****************************************************************************************/

-- Individual File Size query

SELECT 
	name AS 'File Name', 
	physical_name AS 'Physical Name', 
	size/128 AS 'Total Size in MB',
	size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS 'Available Space In MB', 
	*
FROM 
	sys.database_files;

-- shrink db file
--USE [RESERVES]
--GO
--DBCC SHRINKFILE (N'RESERVES_Data' , 20)
--GO

