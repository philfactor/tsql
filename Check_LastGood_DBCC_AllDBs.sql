-- https://www.brentozar.com/archive/2015/08/getting-the-last-good-dbcc-checkdb-date/#comment-2335257
-- 12/12/2016

CREATE TABLE #DBInfo (ParentObject VARCHAR(255), [Object] VARCHAR(255), Field VARCHAR(255), [Value] VARCHAR(255))
CREATE TABLE #Value (DatabaseName VARCHAR(255), LastDBCCCheckDB DATETIME)
-- Insert results of DBCC DBINFO into temp table, transform into simpler table with database name and datetime of last known good DBCC CheckDB
EXECUTE sp_MSforeachdb '
INSERT INTO #DBInfo EXECUTE ("DBCC DBINFO ( ""?"" ) WITH TABLERESULTS");
INSERT INTO #Value (DatabaseName, LastDBCCCheckDB) (SELECT "?", [Value] FROM #DBInfo WHERE Field = "dbi_dbccLastKnownGood");
TRUNCATE TABLE #DBInfo;
'
SELECT DISTINCT * FROM #Value WHERE DatabaseName NOT IN ('tempdb','model','master','msdb')

--drop table #DBInfo
--drop table #Value
