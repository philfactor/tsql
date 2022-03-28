-- http://solihinho.wordpress.com/2008/07/21/database-space-allocated/

SET NOCOUNT ON 

IF OBJECT_ID('tempdb..#DBSTATS') IS NOT NULL
BEGIN
   DROP TABLE #DBSTATS
END 

CREATE TABLE #DBSTATS (
   dbname   sysname,
   lname    sysname,
   usage    varchar(20),
   [size]   decimal(9, 2) NULL ,
   [used]   decimal(9, 2) NULL
) 

IF OBJECT_ID('tempdb..#temp_log') IS NOT NULL
BEGIN
   DROP TABLE #temp_log
END 

CREATE TABLE #temp_log
(
   DBName          sysname,
   LogSize         real,
   LogSpaceUsed    real,
   Status          int
) 

IF OBJECT_ID('tempdb..#temp_sfs') IS NOT NULL
BEGIN
   DROP TABLE #temp_sfs
END 

CREATE TABLE #temp_sfs
(
   fileid          int,
   filegroup       int,
   totalextents    int,
   usedextents     int,
   name            varchar(1024),
   filename        varchar(1024)
) 

DECLARE @dbname sysname
       ,@sql varchar(8000) 

IF OBJECT_ID('tempdb..#temp_db') IS NOT NULL
BEGIN
    DROP TABLE #temp_db
END 

SELECT name INTO #temp_db
   FROM master.dbo.sysdatabases
   WHERE DATABASEPROPERTY(name,'IsOffline') = 0
   AND has_dbaccess(name) = 1
   AND dbid > 4 -- exclude system databases
   ORDER BY name 

WHILE (1 = 1)
BEGIN
   SET @dbname = NULL 

   SELECT TOP 1 @dbname = name
   FROM #temp_db
   ORDER BY name 

   IF @dbname IS NULL
      GOTO _NEXT 

   SET @sql = ' USE ' + @dbname + ' 

      TRUNCATE TABLE #temp_sfs 

      INSERT INTO #temp_sfs
         EXECUTE(''DBCC SHOWFILESTATS'') 

      INSERT INTO #DBSTATS (DBNAME, LNAME, USAGE, [SIZE], [USED])
         SELECT db_name(), NAME, ''Data''
         , totalextents * 64.0 / 1024.0
         , usedextents * 64.0 / 1024.0
         FROM #temp_sfs 

      INSERT INTO #DBSTATS (DBNAME, LNAME, USAGE, [SIZE], [USED])
         SELECT db_name(), name, ''Log'', null, null
         FROM sysfiles
         WHERE status & 0x40 = 0x40' 

    EXEC(@sql) 

    DELETE FROM #temp_db WHERE name = @dbname
END 

_NEXT: 

INSERT INTO #Temp_Log
   EXECUTE ('DBCC SQLPERF(LOGSPACE)') 

UPDATE #DBSTATS
   SET SIZE = B.LogSize
   , USED = LogSize * LogSpaceUsed / 100
FROM #DBSTATS A
INNER JOIN #Temp_Log B
    ON (A.DBNAME = B.DBNAME)AND(A.Usage = 'LOG') 

SELECT dbname AS [database name],
   lname AS [logical db file name],
   usage,
   [size] AS [space allocated (MB)],
   used AS[space used (MB)],
   [size] - used  AS [free space (MB)],
   cast(used/[size]*100 AS numeric(9,2)) AS [space used %],
   cast(100-(used/[size]*100) AS numeric(9,2)) AS [free space %]
FROM #DBSTATS
-- uncomment next line to specify single database
-- WHERE dbname = 'StreamingDb'
ORDER BY dbname, usage 

DROP TABLE #DBSTATS
DROP TABLE #temp_db
DROP TABLE #temp_sfs
DROP TABLE #temp_log 

SET NOCOUNT OFF
