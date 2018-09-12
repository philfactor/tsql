-- https://blog.sqlauthority.com/2014/04/10/sql-server-finding-jobs-shrinking-database-files-notes-from-the-field-023/

DECLARE @search VARCHAR(100)
SET @Search = 'shrink'
SELECT A.[job_id],
B.[name],
[step_id],
[step_name],
[command],
[database_name] FROM [msdb].[dbo].[sysjobsteps] A
JOIN [msdb].dbo.sysjobs B ON A.job_id = B.[job_id] WHERE command LIKE '%' + @Search + '%'
ORDER BY [database_name],
B.[name],
[step_id]