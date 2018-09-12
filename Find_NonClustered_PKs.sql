
/****************************************************************************************
* Object Name:	Find_NonClustered_PKs.sql
* Object Type:	External DMV script
* Author:		Phil Streiff, MCDBA
* Date:			06/02/2008
* Comment:		Run script in user database to find Primary Keys that are Non-Clustered
*				instead of Clustered indexes.
****************************************************************************************/

SELECT 
	--DB_NAME([database_id]) as 'db_name'
	SCHEMA_NAME([schema_id]) as 'schema'
,	o.name as 'table'
,	i.index_id
,	i.name as 'idx_name'
,	i.type
,	i.type_desc
,	i.is_primary_key
FROM 
	sys.indexes i
	INNER JOIN sys.objects AS o ON o.object_id = i.object_id
WHERE
	objectproperty(o.object_id,'IsUserTable') = 1
	AND i.type <> 0 
	AND i.type_desc <> 'CLUSTERED' -- only display non-clustered indexes
	--AND o.type <> 'PK' -- exclude primary keys
	AND SCHEMA_NAME([schema_id]) <> 'sys'
	AND i.is_primary_key = '1'
ORDER BY
	'schema'
,	'table'