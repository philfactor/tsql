-- find install data of sql instance
-- 03/21/2013

-- Option 1
SELECT create_date as 'SQL Server Install Date' 
FROM sys.server_principals WHERE name='NT AUTHORITY\SYSTEM'

-- Option 2
SELECT @@SERVERNAME SERVERNAME, CREATE_DATE ‘INSTALALTIONDATE’
FROM SYS.SERVER_PRINCIPALS
WHERE SID = 0X010100000000000512000000