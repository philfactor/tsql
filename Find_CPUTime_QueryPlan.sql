-- http://statisticsio.com/Home/tabid/36/articleType/ArticleView/articleId/169/categoryId/14/CXPACKET-MAXDOP-and-your-OLTP-system.aspx

select 
	r.cpu_time, 
	r.logical_reads, 
	r.session_id 
	into #temp
from 
	sys.dm_exec_sessions as s 
	inner join sys.dm_exec_requests as r 
	on s.session_id =r.session_id and s.last_request_start_time=r.start_time
where 
	is_user_process = 1  

waitfor delay '00:00:01' 

select 
	substring(h.text, (r.statement_start_offset/2)+1, ((case r.statement_end_offset when -1 
	then datalength(h.text)  else r.statement_end_offset end - r.statement_start_offset)/2) + 1) as text, 
	r.cpu_time-t.cpu_time as CPUDiff, 
	r.logical_reads-t.logical_reads as ReadDiff, 
	p.query_plan, 
	r.wait_type, 
	r.wait_time, 
	r.last_wait_type, 
	r.wait_resource, 
	r.command, 
	r.database_id, 
	r.blocking_session_id, 
	r.granted_query_memory, 
	r.session_id, 
	r.reads, 
	r.writes, 
	r.row_count, 
	s.[host_name], 
	s.program_name, 
	s.login_name
from 
	sys.dm_exec_sessions as s 
	inner join sys.dm_exec_requests as r 
	on s.session_id =r.session_id and s.last_request_start_time=r.start_time
	full outer join #temp as t on t.session_id=s.session_id
	CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) h
	cross apply sys.dm_exec_query_plan(r.plan_handle) p
order by 
	3 desc 

drop table #temp