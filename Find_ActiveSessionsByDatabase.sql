-- find active sessions by database

EXEC sp_WhoIsActive
	@filter_type = database_name,
    @filter = 'tempdb';