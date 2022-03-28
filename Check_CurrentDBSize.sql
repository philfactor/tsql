-- https://www.sqlshack.com/how-to-determine-free-space-and-file-size-for-sql-server-databases/

SELECT DB_NAME(database_id) AS database_name, 
    type_desc, 
    name AS FileName, 
    size/128.0 AS CurrentSizeMB
FROM sys.master_files
WHERE database_id > 6 AND type IN (0,1)