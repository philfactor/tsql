-- http://www.mssqltips.com/tip.asp?tip=1112
-- Find_Objects_In_Filegroup.sql
-- Find objects stored in a filegroup
-- 11/09/07
-- Modified by Phil Streiff

SELECT 
	SCHEMA_NAME([schema_id]) as 'schema',
	o.[name] as 'table_name', 
	o.[type], 
	i.[name], 
	i.[index_id], 
	f.[name]
FROM 
	sys.indexes i
	INNER JOIN sys.filegroups f
	ON i.data_space_id = f.data_space_id
	INNER JOIN sys.all_objects o
	ON i.[object_id] = o.[object_id]
WHERE 
	i.data_space_id = 1 --* New FileGroup*
	AND o.type = 'U'
ORDER BY
	'schema',
	'table_name'
GO