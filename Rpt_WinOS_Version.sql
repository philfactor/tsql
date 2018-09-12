-- Find_WinOS_Version.sql
-- http://msdn.microsoft.com/en-us/library/hh204565.aspx

SELECT 
	windows_release, 
	windows_service_pack_level, 
	windows_sku, 
	os_language_version
FROM 
	sys.dm_os_windows_info;
	
-- ALTERNATIVELY

-- OS information in @@version 
SELECT OSVersion =RIGHT(@@version, LEN(@@version)- 3 -charindex (' ON ', 
@@VERSION)) 	
