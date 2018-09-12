-- https://stackoverflow.com/questions/1883071/how-do-i-find-the-data-directory-for-a-sql-server-instance
-- regents answer

DECLARE @defaultDataLocation nvarchar(4000)
DECLARE @defaultLogLocation nvarchar(4000)

EXEC master.dbo.xp_instance_regread
    N'HKEY_LOCAL_MACHINE',
    N'Software\Microsoft\MSSQLServer\MSSQLServer',
    N'DefaultData', 
    @defaultDataLocation OUTPUT

EXEC master.dbo.xp_instance_regread
    N'HKEY_LOCAL_MACHINE',
    N'Software\Microsoft\MSSQLServer\MSSQLServer',
    N'DefaultLog', 
    @defaultLogLocation OUTPUT

SELECT @defaultDataLocation AS 'Default Data Location',
       @defaultLogLocation AS 'Default Log Location'