----- SQL UPTIME


SET NOCOUNT ON
USE master
GO

PRINT 'Server Name...............: ' + CONVERT(VARCHAR(30),@@SERVERNAME) 
PRINT 'Instance..................: ' + CONVERT(VARCHAR(30),@@SERVICENAME) 
PRINT 'Current Date Time.........: ' + CONVERT(VARCHAR(30),GETDATE(),113)
PRINT 'User......................: ' + USER_NAME()
GO
                
DECLARE @crdate DATETIME, 
            @hr VARCHAR(50), 
            @min VARCHAR(5)

SELECT @crdate=crdate 
FROM sysdatabases
WHERE NAME='tempdb'

SELECT @hr=(DATEDIFF ( mi, @crdate,GETDATE()))/60

IF ((DATEDIFF ( mi, @crdate,GETDATE()))/60)=0 
            SELECT @min=(DATEDIFF ( mi, @crdate,GETDATE())) 
ELSE SELECT @min=(DATEDIFF ( mi, @crdate,GETDATE()))-((DATEDIFF( mi, @crdate,GETDATE()))/60)*60 
            PRINT 'SQL Server "' + CONVERT(VARCHAR(20),SERVERPROPERTY('SERVERNAME'))+'" is Online for the past '+@hr+' hours & '+@min+' minutes' 
   
IF NOT EXISTS (SELECT 1 FROM master.dbo.sysprocesses WHERE program_name = N'SQLAgent - Generic Refresher') 
            BEGIN 
                        PRINT 'SQL Server is running but SQL Server Agent <<NOT>> running' 
            END 
ELSE 
            BEGIN 
                        PRINT 'SQL Server and SQL Server Agent both are running.' 
END  




select @@servername as 'DB Instance'

SELECT getdate() as CURRENTTIME, sqlserver_start_time
FROM sys.dm_os_sys_info;

