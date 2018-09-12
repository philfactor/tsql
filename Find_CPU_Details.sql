
-- 1. Undocumented extended stored procedure
EXEC xp_readerrorlog 0,1,N'cores'

-- 2. Query system veiw
SELECT cpu_count
FROM [sys].[dm_os_sys_info]

-- 3. More details information returned than above query
-- This works on SQL2008, but not on SQL2012
SELECT cpu_count AS [Logical CPU Count], hyperthread_ratio AS [Hyperthread Ratio],
cpu_count/hyperthread_ratio AS [Physical CPU Count], 
physical_memory_in_bytes/1048576 AS [Physical Memory (MB)]
FROM sys.dm_os_sys_info OPTION (RECOMPILE);

-- 4. Returns information about system manufacturer
EXEC sys.xp_readerrorlog 0,1,"Manufacturer"