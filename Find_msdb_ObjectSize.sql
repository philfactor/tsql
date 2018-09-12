-- http://www.mssqltips.com/tip.asp?tip=1461
-- Find_msdb_ObjectSize.sql

USE [msdb];
GO

SELECT object_name(i.object_id) as objectName,
i.[name] as indexName,
sum(a.total_pages) as totalPages,
sum(a.used_pages) as usedPages,
sum(a.data_pages) as dataPages,
(sum(a.total_pages) * 8) / 1024 as totalSpaceMB,
(sum(a.used_pages) * 8) / 1024 as usedSpaceMB, 
(sum(a.data_pages) * 8) / 1024 as dataSpaceMB
FROM sys.indexes i
INNER JOIN sys.partitions p
ON i.object_id = p.object_id
AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a
ON p.partition_id = a.container_id
GROUP BY i.object_id, i.index_id, i.[name]
ORDER BY sum(a.total_pages) DESC, object_name(i.object_id)
GO
 