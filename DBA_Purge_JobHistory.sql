-- SQL Server 2008
-- https://technet.microsoft.com/en-us/library/ms175044(v=sql.105).aspx

USE [msdb];
GO

DECLARE @CleanupDate datetime; 
SET @CleanupDate = DATEADD(dd,-30,GETDATE()) -- delete job history older than 30 days

EXEC sp_purge_jobhistory @oldest_date = @CleanupDate;