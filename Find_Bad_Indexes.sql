-- http://glennberrysqlperformance.spaces.live.com/?_c11_BlogPart_BlogPart=blogview&_c=BlogPart&partqs=amonth%3d11%26ayear%3d2007
-- Find_Bad_Indexes.sql
-- Possible bad Indexes (writes > reads)

DECLARE @dbid int
SELECT @dbid = db_id()

SELECT 
	SCHEMA_NAME([schema_id]) as 'schema'
,	'table_name' = object_name(s.object_id)
,	'index_name' =i.name
	-- i.index_id
,	i.type_desc as 'idx_type'
--,	i.is_primary_key
,	'Total Writes' =  user_updates, 'Total Reads' = user_seeks + user_scans + user_lookups
,	'Difference' = user_updates - (user_seeks + user_scans + user_lookups)
,	'% Difference' = (user_updates - (user_seeks + user_scans + user_lookups))*100/user_updates
--,	'% Difference' = (user_updates-(user_seeks + user_scans + user_lookups))/user_updates*100
--NullIf(Income,0) as ColumnName 
FROM 
	sys.dm_db_index_usage_stats AS s 
    INNER JOIN sys.indexes AS i
    ON s.object_id = i.object_id
    AND i.index_id = s.index_id
	INNER JOIN sys.objects AS o
	ON o.object_id = s.object_id
WHERE 
	objectproperty(s.object_id,'IsUserTable') = 1
    AND s.database_id = @dbid
    AND user_updates > (user_seeks + user_scans + user_lookups)
	AND i.type_desc = 'NONCLUSTERED'
	AND o.type <> 'PK' -- exclude primary keys
ORDER BY 
	'% Difference' DESC,
	'table_name' DESC
	--'Difference' DESC, 'Total Writes' DESC, 'Total Reads' ASC;
