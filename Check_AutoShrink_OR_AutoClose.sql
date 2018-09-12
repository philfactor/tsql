



SELECT [name] AS DatabaseName
, CONVERT(varchar(10),DATABASEPROPERTYEX([Name] , 'IsAutoClose')) AS AutoClose
, CONVERT(varchar(10),DATABASEPROPERTYEX([Name] , 'IsAutoShrink')) AS AutoShrink
FROM master.dbo.sysdatabases
WHERE CONVERT(varchar(10),DATABASEPROPERTYEX([Name] , 'IsAutoClose'))= '1'
	OR
CONVERT(varchar(10),DATABASEPROPERTYEX([Name] , 'IsAutoShrink')) = '1'