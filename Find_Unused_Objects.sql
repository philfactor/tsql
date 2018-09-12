

SELECT DISTINCT
	o.schema_id
,	o.name
,	o.object_id
,	count(qs.execution_count) AS 'Count'
--,	sum(qs.execution_count) AS 'Execution Count'

FROM
	sys.dm_exec_query_stats qs
	CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
JOIN
	sys.objects o on (qt.objectid = o.object_id)
WHERE 
	qt.dbid = 7 -- Change this for the database you are interested in
GROUP BY
	o.schema_id
,	o.name
,	o.object_id
ORDER BY
	--'Execution Count' DESC
	'Count' DESC

--sp_MSTablespace [dbo.captActiveTasks]


