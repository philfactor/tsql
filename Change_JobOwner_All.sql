
-- https://exploresqlserver.wordpress.com/2016/11/15/script-to-update-owner-for-all-sql-agent-jobs-to-sa/

SET nocount ON

SELECT 'EXEC MSDB.dbo.sp_update_job ' + Char(13)
+ '@job_name = ' + Char(39) + j.[name] + Char(39)
+ ',' + Char(13) + '@owner_login_name = '
+ Char(39) + 'sd013023' + Char(39) + Char(13) + Char(13)
FROM   msdb.dbo.sysjobs j
INNER JOIN master.dbo.syslogins l
ON j.owner_sid = l.sid
WHERE  l.[name] <> 'sd013023'
ORDER  BY j.[name]