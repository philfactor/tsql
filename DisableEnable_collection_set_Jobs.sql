-- https://www.mssqltips.com/sqlservertip/1400/disabling-or-enabling-sql-server-agent-jobs/

USE MSDB;
GO
UPDATE MSDB.dbo.sysjobs
SET Enabled = 1 -- 1 = Enable, 2 = Disable
WHERE [Name] LIKE 'collection_set_%';
GO