-- SQL Server 2014 system information

select 
	cpu_count,
	hyperthread_ratio,

	(physical_memory_kb/1024) as 'Memory (MB)'
from [sys].[dm_os_sys_info]