-- Find_Heap_Index.sql
-- http://weblogs.sqlteam.com/dmauri/archive/2005/10/31/8195.aspx

SELECT 
    SCHEMA_NAME([schema_id]) as 'schema',  
	o.name as 'table_name', 
	i.object_id,
	i.index_id,
    i.type_desc,
	i.is_primary_key,
	i.is_unique_constraint,
    'space_used_in_kb' = (page_count * 8.0),
    'space_used_in_mb' = (page_count * 8.0 / 1024.0) 
FROM 
    sys.indexes i
INNER JOIN
    sys.dm_db_index_physical_stats(db_id(), object_id('.'), null, null, null) p ON i.[object_id] = p.[object_id] 
	AND i.[index_id] = p.[index_id]
INNER JOIN
	sys.objects o ON i.object_id = o.object_id
WHERE
	i.type_desc = 'HEAP'
ORDER BY
	space_used_in_mb DESC