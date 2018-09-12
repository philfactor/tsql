-- https://social.msdn.microsoft.com/Forums/en-US/b1ecc4ed-1c0e-4104-9198-f41395940364/how-to-get-free-space-information-of-data-drive-and-log-drive-on-sql-server?forum=sqlgetstarted

declare @svrName_DISK varchar(255)
declare @sql_DISK varchar(400)
declare @servername_DISK varchar(255)
set @servername_DISK = @@SERVERNAME
set @svrName_DISK = SUBSTRING(@servername_DISK,1,CHARINDEX('\',@servername_DISK)-1)
set @sql_DISK = 'powershell.exe -c "Get-WmiObject -ComputerName ' + QUOTENAME(@svrName_DISK,'''') + ' -Class Win32_Volume -Filter ''DriveType = 3'' | select name,capacity,freespace | foreach{$_.name+''|''+$_.capacity/1048576+''%''+$_.freespace/1048576+''*''}"'
IF OBJECT_ID('tempdb.dbo.#output_DISK', 'U') IS NOT NULL
drop table #output_DISK    
CREATE TABLE #output_DISK
(line varchar(255))
IF OBJECT_ID('tempdb.dbo.#output_DISK_Space', 'U') IS NOT NULL
drop table #output_DISK_Space    
CREATE TABLE #output_DISK_Space
(DriveName varchar(255),
Capacity decimal(28,2),
FreeSpace decimal(28,2),
[%Free] decimal(28,2))

insert #output_DISK
EXEC xp_cmdshell @sql_DISK
insert into #output_DISK_Space
select rtrim(ltrim(SUBSTRING(line,1,CHARINDEX('|',line) -1))) as drivename
   ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('|',line)+1,
   (CHARINDEX('%',line) -1)-CHARINDEX('|',line)) )) as Float),0) as 'capacity(MB)'
   ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('%',line)+1,
   (CHARINDEX('*',line) -1)-CHARINDEX('%',line)) )) as Float),0) as 'freespace(MB)',   
   (round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('%',line)+1,
   (CHARINDEX('*',line) -1)-CHARINDEX('%',line)) )) as Float),0) / round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('|',line)+1,
   (CHARINDEX('%',line) -1)-CHARINDEX('|',line)) )) as Float),0))*100
from #output_DISK
where line like '[A-Z][:]%'
select * from #output_DISK_Space
