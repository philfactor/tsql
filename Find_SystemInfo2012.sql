/****************************************************************************************
* Object Name:	Find_SystemInfo2012.sql
* Object Type:	DMV
* Author:		Phil Streiff, MCDBA
* Date:			09/08/2015
* Purpose:		Show CPU, memory and OS system resources for server on SQL2005/2008 instances
****************************************************************************************/
USE [master];
GO
SELECT 
	cpu_count
,	hyperthread_ratio
,	(cpu_count * hyperthread_ratio) AS 'logical_processors'
,	physical_memory_kb / 1024 AS 'mem_MB'
,	virtual_memory_kb / 1024 AS 'virtual_mem_MB'
--,	max_workers_count
--,	os_error_mode
--,	os_priority_class
FROM 
	sys.dm_os_sys_info 
