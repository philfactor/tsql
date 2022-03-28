-- https://serverfault.com/questions/31554/how-to-check-progress-of-dbcc-shrinkfile

-------------------------------
--Track DBCC shrink status
-------------------------------
select
a.session_id
, command
, b.text
, percent_complete
, done_in_minutes = a.estimated_completion_time / 1000 / 60
, min_in_progress = DATEDIFF(MI, a.start_time, DATEADD(ms, a.estimated_completion_time, GETDATE() ))
, a.start_time
, estimated_completion_time = DATEADD(ms, a.estimated_completion_time, GETDATE() )
from sys.dm_exec_requests a
CROSS APPLY sys.dm_exec_sql_text(a.sql_handle) b
where command like '%dbcc%'

-- alternative
select 
[status],
start_time,
convert(varchar,(total_elapsed_time/(1000))/60) + 'M ' + convert(varchar,(total_elapsed_time/(1000))%60) + 'S' AS [Elapsed],
convert(varchar,(estimated_completion_time/(1000))/60) + 'M ' + convert(varchar,(estimated_completion_time/(1000))%60) + 'S' as [ETA],
command,
[sql_handle],
database_id,
connection_id,
blocking_session_id,
percent_complete
from  sys.dm_exec_requests
where estimated_completion_time > 1
order by total_elapsed_time desc