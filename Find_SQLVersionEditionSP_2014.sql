-- https://msdn.microsoft.com/en-us/library/ms174396.aspx

SELECT 
	SERVERPROPERTY ('MachineName') as 'Host',
	SERVERPROPERTY ('InstanceName') as 'Instance',
	SERVERPROPERTY ('ProductVersion') as 'Version', 
	SERVERPROPERTY ('ProductLevel') as 'Level', 
	SERVERPROPERTY ('Edition') as 'Edition',
	SERVERPROPERTY ('EngineEdition') as 'EngineEdition',
	SERVERPROPERTY ('EditionID') as 'EditionID',
	SERVERPROPERTY ('ProductBuildType') as 'ProductBuildType',
	SERVERPROPERTY ('LicenseType') as 'LicenseType'