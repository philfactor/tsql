/******************************************************************************
* Object Name:		Find_Datafile_Size_Location.sql	
* Object Type:		external script
* Author:			Phil Streiff, MCDBA
* Date:				01/24/2007
* Purpose:			Gather inventory of all databases & logs on a 
* 					SQL Server instance
* Dependencies:		Run in master database. Requires read access to 
* 					system tables.
*******************************************************************************/
USE [master]
GO

SELECT 
	sysdatabases.name as 'db_name'  
,	(select 'file_type' =  
	CASE
		WHEN sysaltfiles.groupid between 2 and 20 THEN 'data - FG'
		WHEN sysaltfiles.groupid = 1 THEN 'data - prim'
		WHEN sysaltfiles.groupid = 0 THEN 'log'
	END) as 'file_type'	
,	(sysaltfiles.size * 8 / 1024) as 'file_size(MB)' -- file size in MB
,	sysaltfiles.name as 'logical_file_name'
,	sysaltfiles.filename as 'phys_file_name'
FROM 
	dbo.sysdatabases
JOIN
	dbo.sysaltfiles ON
	(dbo.sysdatabases.dbid=dbo.sysaltfiles.dbid)
WHERE
	sysdatabases.dbid not in ('1','2','3','4')
	--and sysaltfiles.filename like 'S%'
ORDER BY
	dbo.sysdatabases.name
,	dbo.sysaltfiles.groupid DESC
