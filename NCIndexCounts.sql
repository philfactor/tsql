/*============================================================================
File:     NCIndexCounts.sql
 
  Summary:  Nonclustered index counts (multiple result sets)
 
  SQL Server Versions: 2005 onwards
------------------------------------------------------------------------------
Written by Paul S. Randal, SQLskills.com
 
  (c) 2011, SQLskills.com. All rights reserved.
 
For more scripts and sample code, check out https://www.SQLskills.com
 
You may alter this code for your own *non-commercial* purposes. You may
republish altered code as long as you include this copyright and give due
credit, but you must obtain prior permission before blogging this code.
 
THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF
ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED
TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
PARTICULAR PURPOSE.
============================================================================*/
 
IF EXISTS (SELECT * FROM msdb.sys.objects WHERE [name] = 'SQLskillsPaulsIndexCounts')
DROP TABLE msdb.dbo.SQLskillsPaulsIndexCounts;
GO
CREATE TABLE msdb.dbo.SQLskillsPaulsIndexCounts (
SchemaID INT,
ObjectID INT,
BaseType CHAR (10),
IndexCount SMALLINT);
GO
 
EXEC sp_MSforeachdb
N'IF EXISTS (SELECT 1 FROM (SELECT DISTINCT [name]
FROM sys.databases WHERE [state_desc] = ''ONLINE''
AND [database_id] > 4
AND [name] != ''pubs''
AND [name] != ''Northwind''
AND [name] != ''distribution''
AND [name] NOT LIKE ''ReportServer%''
AND [name] NOT LIKE ''Adventure%'') AS names WHERE [name] = ''?'')
BEGIN
USE [?]
INSERT INTO msdb.dbo.SQLskillsPaulsIndexCounts
SELECT o.[schema_id], o.[object_id], ''Heap'', 0
FROM sys.objects o
WHERE o.[type_desc] IN (''USER_TABLE'', ''VIEW'')
AND o.[is_ms_shipped] = 0
AND EXISTS (
SELECT *
FROM sys.indexes
WHERE [index_id] = 0
AND [object_id] = o.[object_id]);
 
INSERT INTO msdb.dbo.SQLskillsPaulsIndexCounts
SELECT o.[schema_id], o.[object_id], ''Clustered'', 0
FROM sys.objects o
WHERE o.[type_desc] IN (''USER_TABLE'', ''VIEW'')
AND o.[is_ms_shipped] = 0
AND EXISTS (
SELECT *
FROM sys.indexes
WHERE [index_id] = 1
AND [object_id] = o.[object_id]);
 
UPDATE msdb.dbo.SQLskillsPaulsIndexCounts
SET [IndexCount] = (
SELECT COUNT (*)
FROM sys.indexes i
WHERE i.object_id = [ObjectID]
AND i.[is_hypothetical] = 0)
 
IF EXISTS (SELECT * FROM msdb.dbo.SQLskillsPaulsIndexCounts)
SELECT
''?'' AS [Database],
SCHEMA_NAME ([SchemaID]) AS [Schema],
OBJECT_NAME ([ObjectID]) AS [Table],
[BaseType],
(CASE
WHEN [IndexCount] = 0 THEN 0
ELSE [IndexCount]-1 END)
AS [NCIndexes]
FROM msdb.dbo.SQLskillsPaulsIndexCounts
ORDER BY [BaseType] DESC, IndexCount;
 
TRUNCATE TABLE msdb.dbo.SQLskillsPaulsIndexCounts;
END';
GO
 
DROP TABLE msdb.dbo.SQLskillsPaulsIndexCounts;
GO