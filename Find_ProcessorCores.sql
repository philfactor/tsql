

xp_cmdshell "wmic cpu get NumberofCores, NumberofLogicalProcessors"

-- alternative

select 
	cpu_count/hyperthread_ratio AS sockets,
	hyperthread_ratio,
	cpu_count,
	(physical_memory_kb/1024) as 'Memory (MB)'
from 
	sys.dm_os_sys_info
	
