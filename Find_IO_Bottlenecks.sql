/****************************************************************************************
* Object Name:	Find_IO_Bottlenecks.sql
* Object Type:	External DMV script
* Author:		Phil Streiff, MCDBA
* Date:			02/16/2008
* Source:		http://www.microsoft.com/technet/prodtechnol/sql/2005/tsprfprb.mspx#EBD
****************************************************************************************/

SELECT  
	wait_type
,   waiting_tasks_count
,   wait_time_ms 
FROM    
	sys.dm_os_wait_stats   
WHERE    
	wait_type like 'PAGEIOLATCH%'
ORDER BY 
	wait_type 

-- transaction logging related IO waits
--SELECT  
--	wait_type
--,   waiting_tasks_count
--,   wait_time_ms 
--FROM    
--	sys.dm_os_wait_stats   
--WHERE    
--	wait_type in ('LOGBUFFER','WRITELOG')   
--ORDER BY 
--	wait_type 

