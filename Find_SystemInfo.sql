/****************************************************************************************
* Object Name:	Find_SystemInfo.sql
* Object Type:	DMV
* Author:		Phil Streiff, MCDBA
* Date:			02/02/09
* Purpose:		Show CPU, memory and OS system resources for server on SQL2005/2008 instances
****************************************************************************************/
USE [master];
GO
SELECT 
	cpu_count
,	hyperthread_ratio
,	(cpu_count * hyperthread_ratio) AS 'logical_processors'
,	physical_memory_in_bytes / 1048576 AS 'mem_MB'
,	virtual_memory_in_bytes / 1048576 AS 'virtual_mem_MB'
--,	max_workers_count
--,	os_error_mode
--,	os_priority_class
FROM 
	sys.dm_os_sys_info 

	
-- alternative (same thing basically)
USE [master];
GO
SELECT 
	cpu_count
,	hyperthread_ratio
,	(cpu_count * hyperthread_ratio) AS 'logical_processors'
,	physical_memory_in_bytes / (1024 * 1024) AS 'mem_MB'
,	virtual_memory_in_bytes / (1024 * 1024) AS 'virtual_mem_MB'
--,	max_workers_count
--,	os_error_mode
--,	os_priority_class
FROM 
	sys.dm_os_sys_info 
