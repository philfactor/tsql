-- http://thomaslarock.com/2011/08/how-many-log-files-should-my-sql-server-database-have/

SELECT db_name(database_id) AS 'database', COUNT(*) AS '# Log files'
FROM sys.master_files
WHERE type = 1
GROUP BY database_id
HAVING COUNT(*) > 1