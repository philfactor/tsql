-- https://msdn.microsoft.com/en-us/library/ms174396.aspx
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/serverproperty-transact-sql?view=sql-server-ver15

SELECT 
	SERVERPROPERTY ('MachineName') as 'Host',
	SERVERPROPERTY ('InstanceName') as 'Instance',
	SERVERPROPERTY ('ProductVersion') as 'Version', 
	SERVERPROPERTY ('ProductUpdateLevel') as 'Cumulative Update', -- added 05/11/2020
	SERVERPROPERTY ('ProductLevel') as 'Level', 
	SERVERPROPERTY ('Edition') as 'Edition',
	SERVERPROPERTY ('EngineEdition') as 'EngineEdition',
	SERVERPROPERTY ('EditionID') as 'EditionID',
	SERVERPROPERTY ('ProductBuildType') as 'ProductBuildType',
	SERVERPROPERTY ('LicenseType') as 'LicenseType'