-- https://social.msdn.microsoft.com/Forums/sqlserver/en-US/bf0afcbe-1125-408c-99fb-42827a06ef97/update-job-owner-for-all-sql-agent-jobs?forum=sqldatabaseengine

DECLARE @name_holder VARCHAR(1000)
DECLARE My_Cursor CURSOR
FOR
SELECT j.name FROM msdb..sysjobs j INNER JOIN Master.dbo.syslogins l ON j.owner_sid = l.sid where l.name <> 'roboprovide'
OPEN My_Cursor
FETCH NEXT FROM My_Cursor INTO @name_holder
WHILE (@@FETCH_STATUS <> -1)
BEGIN
exec msdb..sp_update_job
        @job_name = @name_holder,
        @owner_login_name = 'roboprovide'
FETCH NEXT FROM My_Cursor INTO @name_holder
END 
CLOSE My_Cursor
DEALLOCATE My_Cursor

-- just list owner of each job
select s.name,l.name as 'owner'
from  msdb..sysjobs s 
left join master.sys.syslogins l on s.owner_sid = l.sid
order by s.name