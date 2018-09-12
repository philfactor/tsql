-- https://blogs.msdn.microsoft.com/sql_pfe_blog/2010/02/09/last-known-good-backupdbcc/
-- 12/12/2016

SET NOCOUNT ON  
GO  
USE master  
GO  

-- Trace flag to make DBCC Page command results available in the current connection
DBCC TRACEON(3604)  
GO  

      CREATE TABLE #DBCC_table (  
            ParentObject nvarchar(4000) null,  
            Object nvarchar(4000) null,  
            Field nvarchar(4000) null,  
            VALUE nvarchar(4000) null  
      )  
      CREATE TABLE #LastDBCC_table (  
            [Database Name] nvarchar(4000) null,  
            [Last Known Good DBCC] nvarchar(4000) null  
      )  
      DECLARE @cmd varchar(4000)  
      DECLARE @DB_NAME nvarchar(500)  
      DECLARE @DB_ID int  
      DECLARE LastDBCC_cursor CURSOR FOR  
            SELECT name, [dbid] FROM sysdatabases  
            ORDER BY dbid  
      OPEN LastDBCC_cursor  
     -- Perform the first fetch.  
      FETCH NEXT FROM LastDBCC_cursor into @DB_NAME, @DB_ID  
     -- Check @@FETCH_STATUS to see if there are any more rows to fetch.  
      WHILE @@FETCH_STATUS = 0  
      BEGIN  
     -- This is executed as long as the previous fetch succeeds.  
      SET @cmd = 'dbcc page('+ convert(varchar,@DB_ID)+',1,9,3) with tableresults'  
      insert into #DBCC_table execute (@cmd)  
      insert into #LastDBCC_table  
      select distinct @DB_NAME, VALUE  
      from #DBCC_table  
      where Field = 'dbi_dbccLastKnownGood'  
      if @@ROWCOUNT = 0  
            insert into [#LastDBCC_table] select @DB_NAME, 'Not implemented'  
      FETCH NEXT FROM LastDBCC_cursor into @DB_NAME, @DB_ID  
      delete #DBCC_table  
      END  

      CLOSE LastDBCC_cursor  
      DEALLOCATE LastDBCC_cursor  
      select T1.[Database Name],  
            CASE  
                  WHEN (max(T1.[Last Known Good DBCC]) = '1900-01-01 00:00:00.000') then 'Not Yet Ran'  
                  ELSE max(T1.[Last Known Good DBCC])  
            END as [Last Known Good DBCC],  
            --max(T1.[Last Known Good DBCC]) as [Last Known Good DBCC],  
            COALESCE(convert(varchar(50),MAX(T2.backup_finish_date),21),'Not Yet Taken') AS [Last BackUp Taken]  
      from #LastDBCC_table T1 LEFT OUTER JOIN msdb.dbo.backupset T2  
      ON T2.database_name = T1.[Database Name]  
      GROUP BY T1.[Database Name]  
      ORDER BY T1.[Database Name]  

      DROP TABLE #LastDBCC_table  
      DROP TABLE #DBCC_table  
      DBCC traceoff(3604)  
GO 
