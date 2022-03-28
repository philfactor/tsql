-- https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/

SELECT database_id, name, convert(varchar, create_date, 23) AS 
'create_date', compatibility_level, state_desc 
FROM sys.databases
WHERE database_id > 4


