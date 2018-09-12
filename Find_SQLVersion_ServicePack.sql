--http://technet.microsoft.com/en-us/library/ms174396(v=sql.100).aspx

SELECT 
	SERVERPROPERTY ('MachineName') as 'Host',
	SERVERPROPERTY ('InstanceName') as 'Instance',
	SERVERPROPERTY ('ProductVersion') as 'Version', 
	SERVERPROPERTY ('ProductLevel') as 'Level', 
	SERVERPROPERTY ('Edition') as 'Edition'	
ORDER BY
	'Host'