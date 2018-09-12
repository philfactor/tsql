-- SQL Server 2008
-- https://msdn.microsoft.com/en-us/library/bb510747(v=sql.105).aspx

select * from sys.dm_os_process_memory


-- http://www.sqlservercentral.com/blogs/glennberry/2010/04/23/a-dmv-a-day-_1320_-day-23/

-- SQL Server Process Address space info (SQL 2008 and 2008 R2 only)
--(shows whether locked pages is enabled, among other things)
SELECT physical_memory_in_use_kb,locked_page_allocations_kb, 
       page_fault_count, memory_utilization_percentage, 
       available_commit_limit_kb, process_physical_memory_low, 
       process_virtual_memory_low
FROM sys.dm_os_process_memory;