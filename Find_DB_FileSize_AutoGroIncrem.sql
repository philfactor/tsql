-- https://social.msdn.microsoft.com/Forums/en-US/ada4c422-6036-4324-bd84-735d4086beef/find-datafiletransaction-log-file-auto-growth-amp-maxsize?forum=transactsql
-- Find_DB_FileSize_AutoGroIncrem.sql
-- 01/26/2017

SELECT   'Database Name' = DB_NAME(database_id)
 ,'FileName' = NAME
,FILE_ID
,'size' = CONVERT(NVARCHAR(15), CONVERT(BIGINT, size) * 8) + N' KB'
,'maxsize' = (
CASE max_size
WHEN - 1
THEN N'Unlimited'
ELSE CONVERT(NVARCHAR(15), CONVERT(BIGINT, max_size) * 8) + N' KB'
END
)
 ,'growth' = (
CASE is_percent_growth
WHEN 1
THEN CONVERT(NVARCHAR(15), growth) + N'%'
ELSE CONVERT(NVARCHAR(15), CONVERT(BIGINT, growth) * 8) + N' KB'
END
)
 ,'type_desc' = type_desc
FROM sys.master_files
ORDER BY database_id