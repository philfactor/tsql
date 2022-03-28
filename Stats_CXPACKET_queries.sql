-- queries provided by MS engineer on 4/28/2021

-- identify processes with query parallelism (CXPACKET) wait type
SELECT st.text AS [SQL Text], c.connection_id, w.session_id, 
  w.wait_duration_ms, w.wait_type, w.resource_address, 
  w.blocking_session_id, w.resource_description, c.client_net_address, c.connect_time
FROM sys.dm_os_waiting_tasks AS w
INNER JOIN sys.dm_exec_connections AS c ON w.session_id = c.session_id 
CROSS APPLY (SELECT * FROM sys.dm_exec_sql_text(c.most_recent_sql_handle)) AS st 
              WHERE w.session_id > 50 AND w.wait_duration_ms > 0
ORDER BY c.connection_id, w.session_id

-- identify stats update dates
SELECT object_id AS [TableId], index_id AS [IndexId], OBJECT_NAME(object_id) AS [TableName], name AS [IndexName], stats_date(object_id,index_id) stat_update_date, INDEXPROPERTY(object_id, name,'IsAutoStatistics') is_system_generated_stats
FROM sys.indexes WITH (NOLOCK) 
ORDER BY stat_update_date -- desc or asc
OPTION(MAXDOP 1)

-- identify stats update dates with details
SELECT DISTINCT
OBJECT_NAME(s.[object_id]) AS TableName,
c.name AS ColumnName,
s.name AS StatName,
STATS_DATE(s.[object_id], s.stats_id) AS LastUpdated,
DATEDIFF(d,STATS_DATE(s.[object_id], s.stats_id),getdate()) DaysOld,
dsp.modification_counter,
s.auto_created,
s.user_created,
s.no_recompute,
s.[object_id],
s.stats_id,
sc.stats_column_id,
sc.column_id
FROM sys.stats s
JOIN sys.stats_columns sc
ON sc.[object_id] = s.[object_id] AND sc.stats_id = s.stats_id
JOIN sys.columns c ON c.[object_id] = sc.[object_id] AND c.column_id = sc.column_id
JOIN sys.partitions par ON par.[object_id] = s.[object_id]
JOIN sys.objects obj ON par.[object_id] = obj.[object_id]
CROSS APPLY sys.dm_db_stats_properties(sc.[object_id], s.stats_id) AS dsp
WHERE OBJECTPROPERTY(s.OBJECT_ID,'IsUserTable') = 1
AND (s.auto_created = 1 OR s.user_created = 1)
ORDER BY DaysOld asc;