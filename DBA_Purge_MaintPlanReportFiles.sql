-- http://www.sqlservercentral.com/Forums/Topic1007495-391-1.aspx

--for first parameter (0) = FileBackup and (1) = FileReport 
-- 1 at the end means include first level subfolders in the delete

declare @deldate datetime
set @deldate = convert(nvarchar(20), dateadd(day, -30, getdate()),120)

--delete backup files from specified folder including sub folders
--change BAK to either TRN or DIF to remove other file types

--delete bak files from folder specified including sub folders
EXECUTE master.dbo.xp_delete_file 0,N'I:\SQL_I\BU',N'bak',@DelDate, 1

--delete txt files from folder specified including sub folders
EXECUTE master.dbo.xp_delete_file 1,N'E:\Program Files\Microsoft SQL Server\MSSQL10_50.MS2008R2_DEV\MSSQL\Log',N'txt',@deldate,1

-- this works on DVMX0338 but not on DDAWC005

-- http://sqlblog.com/blogs/andy_leonard/archive/2009/03/11/xp-delete-file.aspx

-- View TSQL
--EXECUTE master.dbo.xp_delete_file 1,N'E:\SQL_E\MSSQL2008\MSSQL10.MS2008_PROD\MSSQL\Log',N'txt',N'2016-10-04T17:03:29'