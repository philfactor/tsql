/****************************************************************/
/* SCRIPT DATABASE REPORTING FROM UNUSED SQL LAST RESET SERVICE */
/****************************************************************/
use master
go
SELECT DB_NAME() as 'dbname',
convert(varchar(255), t.name) AS 'Table',
SUM(i.user_seeks + i.user_scans + i.user_lookups)
AS 'Total accesses',
SUM(i.user_seeks) AS 'Seeks',
SUM(i.user_scans) AS 'Scans',
SUM(i.user_lookups) AS 'Lookups'
INTO ##tb_tables_used
FROM
sys.dm_db_index_usage_stats i RIGHT OUTER JOIN
sys.tables t ON (t.object_id = i.object_id)
GROUP BY
i.object_id,
t.name ORDER BY [Total accesses] DESC
go
delete ##tb_tables_used
go

exec sp_msforeachdb 'use ?;
insert into ##tb_tables_used
SELECT "?" as "dbname",
t.name AS "Table",
SUM(i.user_seeks + i.user_scans + i.user_lookups)
AS "Total accesses",
SUM(i.user_seeks) AS "Seeks",
SUM(i.user_scans) AS "Scans",
SUM(i.user_lookups) AS "Lookups"
FROM
sys.dm_db_index_usage_stats i RIGHT OUTER JOIN
sys.tables t ON (t.object_id = i.object_id)
GROUP BY
i.object_id,
t.name ORDER BY [Total accesses] DESC '
go

SELECT DATEDIFF(D, create_date, GETDATE()) as 'Running Days', CREATE_DATE AS 'Restarting from the'
FROM SYS.databases
WHERE name = 'TEMPDB'

select name as 'Databases without Use'
from sys.databases
where name not in ('model')
except
select dbname
from ##tb_tables_used
order by 1