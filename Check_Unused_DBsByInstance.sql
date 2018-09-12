-- https://social.msdn.microsoft.com/Forums/sqlserver/en-US/6aed7969-af50-41ca-9058-9a1bcac09bc0/find-unused-databases?forum=sqldatabaseengine


declare @results table
(
	dbName varchar(1000),
	lastRead datetime,
	lastWrite datetime
);
insert into @results
exec sp_MSforeachdb '
use ?;

WITH agg AS
(
    SELECT 
        last_user_seek,
        last_user_scan,
        last_user_lookup,
        last_user_update
    FROM
        sys.dm_db_index_usage_stats
    WHERE
        database_id = DB_ID()
)
SELECT ''?'' dbName,
    last_read = MAX(last_read),
    last_write = MAX(last_write)
FROM
(
    SELECT last_user_seek, NULL FROM agg
    UNION ALL
    SELECT last_user_scan, NULL FROM agg
    UNION ALL
    SELECT last_user_lookup, NULL FROM agg
    UNION ALL
    SELECT NULL, last_user_update FROM agg
) AS x (last_read, last_write);'

select dbName, lastRead, lastWrite
from @results