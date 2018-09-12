/****************************************************************************************
*	Object Name:	Find_Unused_Indexes.sql
*	Object Type:	External DMV script
*	Author:			Phil Streiff, MCDBA
*	Date:			08/26/2007
*	Purpose:		Find table indexes that have no user seeks, scans or lookups
*					Execute in user database
****************************************************************************************/

SELECT 
	--DB_NAME([database_id]) as 'db_name'
	SCHEMA_NAME([schema_id]) as 'schema'
,	o.name as 'table_name'
,	i.name as 'idx_name'
,	i.type_desc as 'idx_type'
,	user_seeks
,	user_scans
,	user_lookups
,	user_updates
,	last_user_seek
,	last_user_scan 
FROM 
	sys.dm_db_index_usage_stats s
	INNER JOIN sys.objects AS o ON o.object_id = s.object_id
	INNER JOIN sys.indexes AS i ON s.object_id = i.object_id
	AND s.index_id = i.index_id
WHERE
	objectproperty(s.object_id,'IsUserTable') = 1
	AND i.type <> 0 
	AND i.type_desc = 'NONCLUSTERED' -- only display non-clustered indexes
	AND o.type <> 'PK' -- exclude primary keys
	AND SCHEMA_NAME([schema_id]) <> 'sys'
ORDER BY 
	(user_seeks + user_scans + user_lookups + user_updates) ASC