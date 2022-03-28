--https://dba.stackexchange.com/questions/208376/how-do-i-automatically-enable-or-disable-report-jobs-at-aoag-failover

DECLARE @DB nvarchar(25)
DECLARE @MSG nvarchar(200)
SET @DB = 'SSTAT'

If sys.fn_hadr_is_primary_replica ( @DB ) = 1  
BEGIN 
    EXEC msdb.dbo.sp_update_job @job_name='TRAMS_TRS_TKT_TABLES_CLEANUP',@enabled = 1
    EXEC msdb.dbo.sp_update_job @job_name='Update TSA Ticket Counts',@enabled = 1
	EXEC msdb.dbo.sp_update_job @job_name='UpdateWorkForceCountsTable',@enabled = 1
    SET @MSG = '"' + @DB + '" is PRIMARY. Enabled TRP jobs'
    PRINT @MSG
END 
ELSE
BEGIN
    EXEC msdb.dbo.sp_update_job @job_name='TRAMS_TRS_TKT_TABLES_CLEANUP',@enabled = 0
    EXEC msdb.dbo.sp_update_job @job_name='Update TSA Ticket Counts',@enabled = 0
	EXEC msdb.dbo.sp_update_job @job_name='UpdateWorkForceCountsTable',@enabled = 0
    SET @MSG = '"' + @DB + '" is not PRIMARY. Disabled TRP jobs'
    PRINT @MSG
END