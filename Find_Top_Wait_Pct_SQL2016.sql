-- http://sqlmag.com/sql-server-2016/new-dynamic-management-views-sql-server-2016-part-2-dmexecsessionwaits

--======================================================================
-- CUMULATIVE INSTANCE WAITS
--======================================================================

WITH Waits AS
        (
        SELECT 
                WS.wait_type 
                , WS.wait_time_ms
                , WS.signal_wait_time_ms 
                , (WS.wait_time_ms - WS.signal_wait_time_ms) AS resource_wait_time_ms
                , WS.waiting_tasks_count 
                , CASE WS.waiting_tasks_count
                        WHEN 0 THEN 0
                        ELSE WS.[wait_time_ms]/WS.[waiting_tasks_count]
                END AS avg_wait_time_ms
                , 100. * WS.wait_time_ms / SUM(WS.wait_time_ms) OVER() AS pct
                , ROW_NUMBER() OVER(ORDER BY (WS.wait_time_ms - WS.signal_wait_time_ms) DESC) AS rn
        FROM sys.dm_os_wait_stats AS WS
        WHERE WS.wait_type 
                NOT IN (        -- filter out additional irrelevant waits
                                'BROKER_TASK_STOP', 'BROKER_RECEIVE_WAITFOR', 
                                'BROKER_TO_FLUSH', 'BROKER_TRANSMITTER', 'CHECKPOINT_QUEUE', 
                                'CHKPT', 'DISPATCHER_QUEUE_SEMAPHORE', 'CLR_AUTO_EVENT', 
                                'CLR_MANUAL_EVENT','FT_IFTS_SCHEDULER_IDLE_WAIT', 'KSOURCE_WAKEUP', 
                                'LAZYWRITER_SLEEP', 'LOGMGR_QUEUE', 'MISCELLANEOUS', 'ONDEMAND_TASK_QUEUE',
                                'REQUEST_FOR_DEADLOCK_SEARCH', 'SLEEP_TASK', 'TRACEWRITE',
                                'SQLTRACE_BUFFER_FLUSH', 'XE_DISPATCHER_WAIT', 'XE_TIMER_EVENT'
                                , 'DIRTY_PAGE_POLL', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP'
                                , 'HADR_FILESTREAM_IOMGR_IOCOMPLETION', 'BROKER_EVENTHANDLER'
                                , 'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP', 'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP'
                                , 'SP_SERVER_DIAGNOSTICS_SLEEP'
                                , 'HADR_WORK_QUEUE', 'HADR_NOTIFICATION_DEQUEUE', 'HADR_LOGCAPTURE_WAIT', 'HADR_CLUSAPI_CALL'
                                , 'HADR_TIMER_TASK', 'PREEMPTIVE_SP_SERVER_DIAGNOSTICS', 'PREEMPTIVE_HADR_LEASE_MECHANISM'
                                ,'PREEMPTIVE_OS_GETFILEATTRIBUTES', 'PREEMPTIVE_OS_CREATEFILE', 'PREEMPTIVE_OS_FILEOPS', 'HADR_SYNC_COMMIT'
                                , 'XE_LIVE_TARGET_TVF') 
                )
                                                
SELECT TOP 3 W1.wait_type
        , CAST(W1.wait_time_ms AS DECIMAL(20, 0)) AS wait_time_ms
        , CAST(W1.signal_wait_time_ms AS DECIMAL(20, 0)) AS signal_wait_time_ms
        , CAST(W1.resource_wait_time_ms AS DECIMAL(20, 0)) AS resource_wait_time_ms
        , W1.waiting_tasks_count
        , W1.avg_wait_time_ms
        , CAST(W1.pct AS DECIMAL(5, 2)) AS pct
        , CAST(SUM(W1.pct) OVER(ORDER BY (W1.wait_type) DESC)AS DECIMAL(5,2)) AS running_pct
FROM Waits AS W1
GROUP BY W1.rn
        , W1.wait_type
        , W1.wait_time_ms
        , W1.signal_wait_time_ms
        , W1.resource_wait_time_ms
        , W1.waiting_tasks_count
        , W1.avg_wait_time_ms
        , W1.pct
ORDER BY W1.pct DESC OPTION (MAXDOP 1);