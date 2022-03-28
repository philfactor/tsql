-- https://dba.stackexchange.com/questions/194592/t-sql-to-find-database-name-and-if-filestream-is-enabled-for-specific-database

-- copied script
SELECT db.NAME       AS DBName, 
       type_desc     AS FileType, 
       physical_name AS Location 
FROM   sys.master_files mf 
       INNER JOIN sys.databases db 
               ON db.database_id = mf.database_id 
WHERE  type_desc = 'FILESTREAM'

-- my modified script
SELECT db.NAME       AS DBName,
	   suser_sname( db.owner_sid )  AS Owner,
	   db.create_date AS CreateDate,
       type_desc     AS FileType, 
       physical_name AS Location 
FROM   sys.master_files mf 
       INNER JOIN sys.databases db 
               ON db.database_id = mf.database_id 
WHERE  type_desc = 'FILESTREAM' 
ORDER BY CreateDate 