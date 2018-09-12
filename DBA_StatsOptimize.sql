DECLARE @mydb sysname
DECLARE db_cursor CURSOR
    FOR select name from sys.databases where database_id > 4 and state_desc = 'ONLINE' AND source_database_id IS NULL
OPEN db_cursor
FETCH NEXT FROM db_cursor into @mydb;

WHILE @@FETCH_STATUS = 0
BEGIN

exec ConditionalUpdateStats
@dbname = @mydb,
@StatSample = NULL,
@IncludeMSObjects = 0,
@StandAloneStatsOnly = 0,
@PercentageChangeBeforeUpdate = 15,
@LogToTable = 'Y'
FETCH NEXT FROM db_cursor into @mydb;
END
CLOSE db_cursor
Deallocate db_cursor

Delete from StatsLog where CompletedDate < getdate()-30

-- replace with this

exec ConditionalUpdateStats
@dbname = LTEDWEricsson,
@StatSample = NULL,
@IncludeMSObjects = 0,
@StandAloneStatsOnly = 0,
@PercentageChangeBeforeUpdate = 15,
@LogToTable = 'Y'

Delete from StatsLog where CompletedDate < getdate()-30