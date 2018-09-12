-- http://blogs.msdn.com/sqltips/archive/2005/09/14/466387.aspx

select case
         when cpu_count / hyperthread_ratio > 8 then 8
         else cpu_count / hyperthread_ratio
       end as optimal_maxdop_setting
from sys.dm_os_sys_info;

--select * from sys.dm_os_sys_info

--sp_configure