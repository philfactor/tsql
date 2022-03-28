-- https://www.timradney.com/what-is-page-life-expectancy-ple-in-sql-server/

SELECT  @@servername AS INSTANCE
,[object_name]
,[counter_name]
, UPTIME_MIN = CASE WHEN[counter_name]= 'Page life expectancy'
          THEN (SELECT DATEDIFF(MI, MAX(login_time),GETDATE())
          FROM   master.sys.sysprocesses
          WHERE  cmd='LAZY WRITER')
      ELSE ''
END
, [cntr_value] AS PLE_SECS
,[cntr_value]/ 60 AS PLE_MINS
,[cntr_value]/ 3600 AS PLE_HOURS
,[cntr_value]/ 86400 AS PLE_DAYS
FROM  sys.dm_os_performance_counters
WHERE   [object_name] LIKE '%Manager%'
          AND[counter_name] = 'Page life expectancy'
		  

-- https://www.brentozar.com/archive/2020/06/page-life-expectancy-doesnt-mean-jack-and-you-should-stop-looking-at-it/
-- https://sqlperformance.com/2014/10/sql-performance/knee-jerk-page-life-expectancy
-- https://www.sqlskills.com/blogs/paul/page-life-expectancy-isnt-what-you-think/	  
-- https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/ms191475(v=sql.105)


-- alternative
SELECT*
FROM sys.dm_os_performance_counters
WHERE [counter_name] = 'Page life expectancy'