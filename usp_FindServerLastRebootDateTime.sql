-- https://www.mssqltips.com/sqlservertip/6098/find-the-last-windows-server-reboot-time-and-last-sql-server-restart/

USE master
GO

-- =================================================================================
-- Author:         Eli Leiba
-- Create date:    2019-06
-- Procedure Name: dbo.usp_FindServerLastRebootDateTime
-- Description:    This procedure finds the last OS reboot date and time and  
--                 last restart date and time of the SQL Server service.
-- ==================================================================================
CREATE PROCEDURE dbo.usp_FindServerLastRebootDateTime 
AS
BEGIN
   DECLARE @rebootDT NVARCHAR (20)
   DECLARE @SQLServiceLastRestrartDT NVARCHAR (20)
   DECLARE @dosStmt NVARCHAR (200)
   DECLARE @dosResult TABLE (line NVARCHAR (500))
 
   SET NOCOUNT ON
 
   SET @dosStmt = 'wmic os get lastbootuptime'
 
   INSERT INTO @dosResult EXEC sys.xp_cmdShell @dosStmt
 
   SELECT @rebootDT = CONCAT (
         SUBSTRING (line, 1, 4),'-',
         SUBSTRING (line, 5, 2),'-',
         SUBSTRING (line, 7, 2),' ',
         SUBSTRING (line, 9, 2),':',
         SUBSTRING (line, 11, 2),':',
         SUBSTRING (line, 13, 2)
         )
   FROM @dosResult
   WHERE CHARINDEX ('.', line, 1) > 0
 
   SELECT @SQLServiceLastRestrartDT = CONVERT(NVARCHAR (11), create_date, 23) + ' ' + CONVERT(VARCHAR (8), create_date, 108)
   FROM sys.databases
   WHERE rtrim(ltrim(upper([name]))) = 'TEMPDB'
   
   SELECT @rebootDT as OSServerRebootDateTime, @SQLServiceLastRestrartDT as SQLServiceRestartDateTime
   
   SET NOCOUNT OFF
END
GO