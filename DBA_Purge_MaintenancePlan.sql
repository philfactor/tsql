-- SQL Server 2008
-- https://technet.microsoft.com/en-us/library/ms189411(v=sql.105).aspx

USE [msdb];
GO

DECLARE @oldest_time smalldatetime;
SET @oldest_time = DATEADD(dd, -30, GETDATE()) -- delete maintenance plan history older than 30 days

EXEC sp_maintplan_delete_log null, null, @oldest_time;

-- EXAMPLE

-- DREWC049\MS2008R2_DEV1
--select * from dbo.sysmaintplan_log
-- 427 rows before purge
-- purge rows older than 30 days with sp_maintplan_delete_log
-- 34 rows after purge
