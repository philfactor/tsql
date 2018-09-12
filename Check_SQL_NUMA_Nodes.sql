--https://technet.microsoft.com/en-us/library/ms178144(v=sql.105).aspx

-- run this to find number of memory nodes available to SQL Server
SELECT DISTINCT memory_node_id
FROM sys.dm_os_memory_clerks

--If SQL Server returns only a single memory node (node 0), either you do not have hardware NUMA, or the hardware is configured 
--as interleaved (non-NUMA). If you think your hardware NUMA is configured incorrectly, contact your hardware vendor to enable NUMA. 
--SQL Server ignores NUMA configuration when hardware NUMA has four or less CPUs and at least one node has only one CPU.