
-- http://blogs.msdn.com/sqlcat/archive/2006/02/13/531339.aspx
-- rarely used indexes appear first
declare @dbid int
select @dbid = db_id()
SELECT
	SCHEMA_NAME([schema_id]) as 'schema_name', 
	object_name=object_name(s.object_id), 
	s.object_id, 
	index_name=i.name, 
	i.index_id, 
	user_seeks, 
	user_scans, 
	user_lookups, 
	user_updates,
	last_user_seek,
	last_user_scan 
FROM 
	sys.dm_db_index_usage_stats s,
    sys.indexes i,
	sys.objects o
WHERE 
	database_id = @dbid and objectproperty(s.object_id,'IsUserTable') = 1
	and i.object_id = s.object_id
	and i.index_id = s.index_id
	and o.object_id = s.object_id
	AND o.type <> 'PK' -- exclude primary keys
	AND i.type_desc = 'NONCLUSTERED' -- only display non-clustered indexes
	AND i.type <> 0
	AND SCHEMA_NAME([schema_id]) <> 'sys'
ORDER BY 
	(user_seeks + user_scans + user_lookups + user_updates) asc


