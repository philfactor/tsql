-- http://blogs.msdn.com/b/sql_pfe_blog/archive/2009/12/23/how-and-why-to-enable-instant-file-initialization.aspx

DBCC TRACEON(3004,3605,-1) 
GO 

CREATE DATABASE TestFileZero 
GO 

EXEC sp_readerrorlog 
GO 

DROP DATABASE TestFileZero 
GO 

DBCC TRACEOFF(3004,3605,-1) 

-- If output has entries at the end which include Zeroing mdf/ndf (data) and ldf (log) entries then Instant File Initialization IS NOT enabled.

-- If output has entries at the end which include Zeroing only the ldf (log) files, then Instant File Initialization IS enabled.