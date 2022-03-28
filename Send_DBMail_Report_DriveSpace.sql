-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-send-dbmail-transact-sql?view=sql-server-ver15

EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'DBA_ONSHORE_Notifications',
@recipients = 'philip.streiff@sprint.com',
@subject = 'TVMXD765 Drive Space',
@query = N'SELECT Drive, FreeSpace, SizeMB, PercentFree
FROM DBA.dbo.DriveSpace
ORDER BY Drive',
@attach_query_result_as_file = 1,
@query_attachment_filename = 'TVMXD765_DriveSpace.txt'