-- find objects where specified user is set as the execute context
-- Solution for following ERROR when trying to drop database user:
-- Msg 15136, Level 16, State 1, Line 4
-- The database principal is set as the execution context of one or more procedures, functions, or event notifications and cannot be dropped.

USE [<target database>];
GO

select
	object_name(object_id) 
from 
	sys.sql_modules 
where 
	execute_as_principal_id = user_id('AD\$FUP_5RL_ProdSQLSVC')
