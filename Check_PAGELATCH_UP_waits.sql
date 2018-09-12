-- Find PAGELATCH_UP wait types & calculate average wait per task
-- 08/09/2018

SELECT GETDATE() AS 'curr_datetime'
	,wait_type
	,waiting_tasks_count
	,wait_time_ms
	,max_wait_time_ms
	,(wait_time_ms / waiting_tasks_count) AS 'avg_wait_time'
FROM sys.dm_os_wait_stats
WHERE wait_type IN ('PAGELATCH_UP')