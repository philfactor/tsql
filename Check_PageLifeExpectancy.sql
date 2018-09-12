-- https://blog.sqlauthority.com/2010/12/13/sql-server-what-is-page-life-expectancy-ple-counter/

SELECT [object_name],
[counter_name],
[cntr_value] FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Manager%'
AND [counter_name] = 'Page life expectancy'