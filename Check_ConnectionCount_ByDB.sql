-- get the current connection count
-- databases that have connection count of 0 for extended periods are not being used.
USE [master];
GO

SELECT @@ServerName AS SERVER
	,NAME AS dbname
	,COUNT(STATUS) AS number_of_connections
	,GETDATE() AS TIMESTAMP
FROM sys.databases sd
LEFT JOIN sysprocesses sp ON sd.database_id = sp.dbid
WHERE database_id > 4
	AND STATE = '0' -- only databases in ONLINE status
GROUP BY NAME
HAVING COUNT(STATUS) = '0'
ORDER BY
	-- number_of_connections
	dbname
