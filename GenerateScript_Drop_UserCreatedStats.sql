-- https://blog.sqlauthority.com/2018/01/28/drop-user-created-statistics-sql-server-interview-question-week-158/

-- change query output from 'results to grid' to 'results to text' prior to running script

SELECT DISTINCT 'DROP STATISTICS '
+ SCHEMA_NAME(ob.Schema_id) + '.'
+ OBJECT_NAME(s.object_id) + '.' +
s.name DropStatisticsStatement
FROM sys.stats s
INNER JOIN sys.Objects ob ON ob.Object_id = s.object_id
WHERE SCHEMA_NAME(ob.Schema_id) <> 'sys'
AND Auto_Created = 0 AND User_Created = 1