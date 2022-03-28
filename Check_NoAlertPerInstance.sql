-- 01/22/2021
-- Check for SQL Server instances with no alerts created

USE [msdb];
GO
SELECT count(id) as '# alerts' 
FROM sysalerts
HAVING count(id) = 0 -- < 8