-- Create_Operator_Offshore.sql

-- Create Operator
USE [msdb]
GO

/****** Object:  Operator [SQLServerSupportTeam]    Script Date: 11/30/2018 10:43:00 ******/
EXEC msdb.dbo.sp_add_operator @name=N'SQLServerSupportTeam', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'ProductionSupportDataServices-SQLServerDBAs@sprint.com', 
		@category_name=N'[Uncategorized]'
GO

-- Assign Failsafe Operator
USE [msdb]
GO
EXEC master.dbo.sp_MSsetalertinfo @failsafeoperator=N'SQLServerSupportTeam', 
		@notificationmethod=1
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_set_sqlagent_properties @email_save_in_sent_folder=1, 
		@databasemail_profile=N'DBA_Notifications', 
		@use_databasemail=1
GO
