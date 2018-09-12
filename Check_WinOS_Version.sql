-- Check_WinOS_Version.sql
-- http://msdn.microsoft.com/en-us/library/hh204565.aspx
-- works on SQL instances updated to SP3 version
-- does NOT work on SQL instances on RTM version

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

---------------------------------------------------------------------------------------------------
-- Windows Server 2003 (Beta?)								5.2.3763
-- Windows Server 2003										5.2.3790 (24.04.2003)
-- Windows Server 2003, Service Pack 1						5.2.3790.1180
-- Windows Server 2003										5.2.3790.1218
--------------------------------------------------------------------------------------------------
-- Windows Server 2008										6.0.6001 (27.02.2008)
-- Windows Server 2008 R2, RTM (Release to Manufacturing)	6.1.7600.16385 (22.10.2009)
-- Windows Server 2008 R2, SP1								6.1.7601
--------------------------------------------------------------------------------------------------
-- Windows Server 2012										6.2.9200 (04.09.2012)
-- Windows Server 2012 R2									6.3.9200 (18.10.2013)
--------------------------------------------------------------------------------------------------
-- https://msdn.microsoft.com/en-us/library/ms724832(v=vs.85).aspx