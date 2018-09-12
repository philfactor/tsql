-- CheckUserObjectInSysDBs.sql
-- Phil Streiff, MCDBA, MCITP
-- 04/23/2015

-- USE [master];
-- GO

SELECT *
FROM   [sys].[objects]
WHERE  SCHEMA_NAME([schema_id]) != 'sys'
       AND [is_ms_shipped] = 0
       AND [parent_object_id] NOT IN (SELECT [object_id]
                                      FROM   [sys].[objects]
                                      WHERE  SCHEMA_NAME([schema_id]) = 'sys'
                                             OR [is_ms_shipped] = 1);
