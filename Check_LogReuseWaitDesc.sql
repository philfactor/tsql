-- http://www.sqlskills.com/blogs/paul/worrying-cause-log-growth-log_reuse_wait_desc/

USE [master];
GO
select name, log_reuse_wait_desc 
from sys.databases
where name = 'spmp'

-- If output like this:
--name      log_reuse_wait_desc
----------- ------------------------------------------------------------
--SPMP      ACTIVE_TRANSACTION

-- Then try issuing a CHECKPOINT command or DBCC SHRINKFILE('mylogfile') to clear ACTIVE_TRANSACTION
