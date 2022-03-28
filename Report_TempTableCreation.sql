-- https://sqlperformance.com/2014/05/t-sql-queries/dude-who-owns-that-temp-table

DECLARE @delta INT = DATEDIFF(MINUTE, SYSUTCDATETIME(), SYSDATETIME());
 
;WITH xe AS
(
  SELECT 
    [obj_name]  = xe.d.value(N'(event/data[@name="object_name"]/value)[1]',N'sysname'),
    [object_id] = xe.d.value(N'(event/data[@name="object_id"]/value)[1]',N'int'),
    [timestamp] = DATEADD(MINUTE, @delta, xe.d.value(N'(event/@timestamp)[1]',N'datetime2')),
    SPID        = xe.d.value(N'(event/action[@name="session_id"]/value)[1]',N'int'),
    NTUserName  = xe.d.value(N'(event/action[@name="session_nt_username"]/value)[1]',N'sysname'),
    SQLLogin    = xe.d.value(N'(event/action[@name="server_principal_name"]/value)[1]',N'sysname'),
    HostName    = xe.d.value(N'(event/action[@name="client_hostname"]/value)[1]',N'sysname'),
    AppName     = xe.d.value(N'(event/action[@name="client_app_name"]/value)[1]',N'nvarchar(max)'),
    SQLBatch    = xe.d.value(N'(event/action[@name="sql_text"]/value)[1]',N'nvarchar(max)')
 FROM 
    sys.fn_xe_file_target_read_file(N'C:\temp\TempTableCreation*.xel',NULL,NULL,NULL) AS ft
    CROSS APPLY (SELECT CONVERT(XML, ft.event_data)) AS xe(d)
) 
SELECT 
  DefinedName         = xe.obj_name,
  GeneratedName       = o.name,
  o.[object_id],
  --xe.[timestamp],		-- optionally comment out unneeded information
  o.create_date,
  xe.SPID,
  --xe.NTUserName,		-- optionally comment out unneeded information
  xe.SQLLogin, 
  xe.HostName,
  ApplicationName     = xe.AppName,
  TextData            = xe.SQLBatch,
  row_count           = x.rc,
  reserved_page_count = x.rpc
FROM xe
INNER JOIN tempdb.sys.objects AS o
ON o.[object_id] = xe.[object_id]
AND o.create_date >= DATEADD(SECOND, -2, xe.[timestamp])
AND o.create_date <= DATEADD(SECOND,  2, xe.[timestamp])
INNER JOIN
(
  SELECT 
    [object_id],
    rc  = SUM(CASE WHEN index_id IN (0,1) THEN row_count END), 
    rpc = SUM(reserved_page_count)
  FROM tempdb.sys.dm_db_partition_stats
  GROUP BY [object_id]
) AS x
ON o.[object_id] = x.[object_id];