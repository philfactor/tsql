-- https://www.sqlservercentral.com/blogs/finding-untrusted-foreign-keys-and-constraints

CREATE TABLE #constraints_detaills (dbname NVARCHAR (100), 
									untrusted_keyname NVARCHAR (1000), 
									constraints_type NVARCHAR (500)
									)
CREATE TABLE #temp (
					id INT IDENTITY(1,1),
					dbname NVARCHAR (100),
					status_fk int,
					status_cc int
					)
INSERT INTO #temp
SELECT name,0,0 FROM sys.databases WHERE database_id not in (1,2,3,4,32727)
SET NOCOUNT ON
DECLARE @id INT
DECLARE @dbname NVARCHAR (100)
DECLARE @sql_fk VARCHAR (MAX)
DECLARE @sql_cc VARCHAR (MAX)
WHILE EXISTS(SELECT TOP 1 dbname FROM #temp WHERE status_fk = 0 AND status_cc = 0)
BEGIN
SELECT @id	= id, @dbname = dbname
FROM #temp  WHERE status_fk = 0 AND status_cc = 0
SET @sql_fk = 'USE '+@dbname +' SELECT '''+@dbname +''',
			  ''['' + s.name + ''].['' + o.name + ''].['' + i.name + '']'' AS keyname, 
			  ''Foreign Keys''
			  FROM sys.foreign_keys i
			  INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
			  INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
			  WHERE i.is_not_trusted = 1 AND i.is_not_for_replication = 0;'
SET @sql_cc = 'USE '+@dbname + ' SELECT '''+@dbname +''', 
			  ''['' + s.name + ''].['' + o.name + ''].['' + i.name + '']'' AS keyname, 
			  ''Check Constraints''
			  FROM sys.check_constraints i
			  INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
			  INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
              WHERE i.is_not_trusted = 1 AND i.is_not_for_replication = 0 AND i.is_disabled = 0;'
INSERT INTO #constraints_detaills
EXEC (@sql_fk)
INSERT INTO #constraints_detaills
EXEC (@sql_cc)
                                   
UPDATE #temp
SET status_fk = 1, status_cc = 1
WHERE id = @id AND status_fk = 0 AND status_cc = 0
END
SELECT * FROM #constraints_detaills
DROP TABLE #temp
DROP TABLE #constraints_detaills