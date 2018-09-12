-- Deprecated_SQL_Features.sql
-- Phil Streiff, MCDBA
-- 03/20/2015

SELECT * FROM sys.dm_os_performance_counters
WHERE OBJECT_NAME like '%deprecated%'
order by cntr_value desc

-- OR --

SELECT * 
FROM sys.dm_os_performance_counters   
WHERE object_name = 'SQLServer:Deprecated Features'; -- replace SQLServer with MSSQL$MS2008_PROD

