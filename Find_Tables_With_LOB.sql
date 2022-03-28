-- https://eitanblumin.com/2020/04/07/troubleshooting-long-running-shrink-operations/

/*
Author: Eitan Blumin | https://www.eitanblumin.com
Create Date: 2020-03-18
Description:
  This script will detect tables in your database that may cause DBCC SHRINK operations
  to run really slow:
    – Tables with LOB_DATA or ROW_OVERFLOW_DATA
    – Heap tables with non-clustered indexes
    – Heap tables with partitions
  
  You may adjust the @TableSizeThresholdMB parameter to filter the tables based on their size.
*/
DECLARE
	@TableSizeThresholdMB INT = 500


;WITH TabsCTE
AS
(
SELECT  DISTINCT
	'Table with LOB or ROW-OVERFLOW data' AS Issue,
	p.object_id
FROM    sys.system_internals_allocation_units au
JOIN    sys.partitions p ON au.container_id = p.partition_id
WHERE type_desc <> 'IN_ROW_DATA' AND total_pages > 8
AND p.rows > 0

UNION ALL

SELECT
	'Heap with Non-clustered indexes',
	p.object_id
FROM	sys.partitions AS p
WHERE	p.index_id = 0
AND p.rows > 0
AND EXISTS (SELECT NULL FROM sys.indexes AS ncix WHERE ncix.object_id = p.object_id AND ncix.index_id > 1)

UNION ALL

SELECT DISTINCT
	'Partitioned Heap',
	p.object_id
FROM	sys.partitions AS p
WHERE	p.index_id = 0
AND p.rows > 0
AND p.partition_number > 1
)
SELECT t.*,
OBJECT_SCHEMA_NAME(t.object_id) table_schema,
OBJECT_NAME(t.object_id) table_name,
SUM(p.rows) AS RowCounts,
CAST(ROUND((SUM(a.used_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Used_MB,
CAST(ROUND((SUM(a.total_pages) - SUM(a.used_pages)) / 128.00, 2) AS NUMERIC(36, 2)) AS Unused_MB,
CAST(ROUND((SUM(a.total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_MB
FROM TabsCTE AS t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id 
GROUP BY t.Issue, t.object_id
HAVING SUM(a.used_pages) / 128.00 >= @TableSizeThresholdMB
ORDER BY Used_MB DESC


/*
Author: Eitan Blumin | https://www.eitanblumin.com
Create Date: 2020-03-18
Last Update: 2020-06-22
Description:
  This script will detect currently running sessions in your database which are running DBCC SHRINK commands.
  It will also output the name of any tables and indexes the session is currently locking.
  
  Use this query to find out what causes a SHRINK to run for too long.
  You may need to run it multiple times to "catch" the relevant info.
*/
SELECT DISTINCT
	req.session_id,
	req.start_time,
	req.command,
	req.status,
	req.wait_type,
	req.last_wait_type,
	req.reads,
	req.cpu_time,
	req.blocking_session_id,
	blockertext.text AS blocker_sql_batch,
	ISNULL(req.database_id, rsc_dbid) AS dbid,
	rsc_objid AS ObjId,
	OBJECT_SCHEMA_NAME(rsc_objid, rsc_dbid) AS SchemaName,
	OBJECT_NAME(rsc_objid, rsc_dbid) AS TableName,
	rsc_indid As IndexId,
	indexes.name AS IndexName
FROM sys.dm_exec_requests AS req
LEFT JOIN master.dbo.syslockinfo ON req_spid = req.session_id AND rsc_objid <> 0
LEFT JOIN sys.indexes ON syslockinfo.rsc_objid = indexes.object_id AND syslockinfo.rsc_indid = indexes.index_id
LEFT JOIN sys.dm_exec_connections AS blocker ON req.blocking_session_id = blocker.session_id
OUTER APPLY sys.dm_exec_sql_text(blocker.most_recent_sql_handle) as blockertext
WHERE req.command = 'DbccFilesCompact'
