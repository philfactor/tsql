/****************************************************************************************
*	Object Name:	Find_AvgIdx_Frag_Ovr_30.sql
*	Object Type:	External DMV script
*	Author:			Phil Streiff, MCDBA
*	Date:			06/24/2007
*	Purpose:		Identify indexes which are fragmented in excess of 30%
*	Dependency:		MS SQL Server 2005 System DMV's sys.dm_index_physical_stats, 
*					sys_indexes, sys_objects.
*	Usage:			Identify by user database to diagnose table index health. 
*	Comments:		All databases must be online for script to work.
****************************************************************************************/

SELECT
	DB_NAME([database_id]) as 'db_name'
,	SCHEMA_NAME([schema_id]) as 'schema'
,	OBJECT_NAME(sys.dm_db_index_physical_stats.object_id) as 'table_name'
	--,	sys.indexes.object_id	
	--,	sys.indexes.index_id as 'idx_id'
,	sys.indexes.name as 'idx_name'
,	sys.indexes.type_desc as 'idx_type'
	--,	index_depth 
	--,	index_level
,	avg_fragmentation_in_percent
,	fragment_count
,	avg_fragment_size_in_pages
,	page_count
	--,avg_page_space_used_in_percent,record_count,ghost_record_count,version_ghost_record_count
	--,min_record_size_in_bytes,max_record_size_in_bytes,avg_record_size_in_bytes,forwarded_record_count
FROM 
	sys.dm_db_index_physical_stats (NULL, NULL, NULL, NULL, NULL)
JOIN
	sys.indexes on (sys.dm_db_index_physical_stats.object_id + sys.dm_db_index_physical_stats.index_id = sys.indexes.object_id + sys.indexes.index_id)
JOIN	
	sys.objects on (sys.dm_db_index_physical_stats.object_id = sys.objects.object_id) 
WHERE
	--sys.indexes.object_id = sys.objects.object_id 
	--sys.indexes.index_id = sys.dm_db_index_physical_stats.index_id 
	sys.indexes.type_desc <> 'HEAP'
	--AND database_id = '7' -- 7=Captain0516 db
	AND avg_fragmentation_in_percent > 30
ORDER BY
	'table_name'
,	'schema'
