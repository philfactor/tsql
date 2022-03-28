--http://technet.microsoft.com/en-us/library/ms174396(v=sql.100).aspx

SELECT 
	SERVERPROPERTY ('MachineName') as 'Host',
	SERVERPROPERTY ('InstanceName') as 'Instance',
	SERVERPROPERTY ('ProductVersion') as 'Version', 
	SERVERPROPERTY ('ProductLevel') as 'Level', 
	SERVERPROPERTY ('Edition') as 'Edition'	
ORDER BY
	'Host'
	
-- 2019
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/serverproperty-transact-sql?view=sql-server-ver15

SELECT
	SERVERPROPERTY ('ServerName') as 'ServerName',
  CASE 
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '8%' THEN 'SQL2000'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '9%' THEN 'SQL2005'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '10.0%' THEN 'SQL2008'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '10.5%' THEN 'SQL2008 R2'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '11%' THEN 'SQL2012'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '12%' THEN 'SQL2014'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '13%' THEN 'SQL2016'     
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '14%' THEN 'SQL2017' 
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '15%' THEN 'SQL2019' 
     ELSE 'unknown'
  END AS MajorVersion,
	SERVERPROPERTY('ProductLevel') AS 'ProductLevel',
	SERVERPROPERTY ('ProductBuildType') as 'ProductBuildType',
	SERVERPROPERTY('ProductVersion') AS 'ProductVersion',
	SERVERPROPERTY('Edition') AS Edition,
	SERVERPROPERTY ('ProductUpdateLevel') as 'Cumulative Update', -- added 05/11/2020
	SERVERPROPERTY ('ProductUpdateReference') as 'KBArticle'
	
-- alternative
xp_msver