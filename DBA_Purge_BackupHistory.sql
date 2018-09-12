-- SQL Server 2008
-- https://technet.microsoft.com/en-us/library/ms188328(v=sql.105).aspx

USE [msdb];
GO

declare @oldest_date smalldatetime;
set @oldest_date = dateadd(dd, -90,getdate()) -- delete backup history older than 90 days

EXEC sp_delete_backuphistory @oldest_date; 