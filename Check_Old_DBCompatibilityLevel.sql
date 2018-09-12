-- http://blogs.sqlsentry.com/aaronbertrand/bad-habits-old-compatibility-levels/
-- Check_Old_DBCompatibilityLevel.sql
-- 09/22/2015

DECLARE @v TINYINT;
 
SET @v = PARSENAME(CONVERT(SYSNAME,SERVERPROPERTY(N'ProductVersion')),4) + '0';
 
SELECT name, [compatibility_level]
  FROM sys.databases
  WHERE [compatibility_level] < @v
  ORDER BY [compatibility_level];
 
-- note: this will break when we hit compat level 260 (but so will sys.databases)