-- use to check for databases that have maxsize set to a fixed, 'restricted' value, instead of default of 'unrestricted'

USE [master];
GO
SELECT dbid, name, size, maxsize, growth 
FROM sys.sysaltfiles
WHERE maxsize NOT IN ('-1','268435456') --AND groupid <> '0'
ORDER BY name