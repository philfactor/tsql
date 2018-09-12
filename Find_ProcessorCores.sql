

xp_cmdshell "wmic cpu get NumberofCores, NumberofLogicalProcessors"

-- alternative

select 
	cpu_count/hyperthread_ratio AS sockets,
	hyperthread_ratio,
	cpu_count  
from 
	sys.dm_os_sys_info
	
-- alternative
SELECT cpu_count/hyperthread_ratio AS sockets
FROM sys.dm_os_sys_info