-- https://blog.dbi-services.com/delete-an-orphan-user-database-under-ssisdb/

-- 1. Find objects create by user
/*Folder Permissions*/
SELECT fo.*,p.name
FROM internal.folder_permissions fo
INNER JOIN sys.database_principals p on fo.[sid] = p.[sid]
WHERE p.name = 'GSM1900\LErnest1'
/*Project Permissions*/
SELECT pr.*,p.name
FROM internal.project_permissions pr
INNER JOIN sys.database_principals p on pr.[sid] = p.[sid]
WHERE p.name = 'GSM1900\LErnest1'
/*Environment Permissions*/
SELECT en.*,p.name
FROM internal.environment_permissions en
INNER JOIN sys.database_principals p on en.[sid] = p.[sid]
WHERE p.name = 'GSM1900\LErnest1'
/*Operation Permissions*/
SELECT op.*,p.name
FROM internal.operation_permissions op
INNER JOIN sys.database_principals p on op.[sid] = p.[sid]
WHERE p.name = 'GSM1900\LErnest1'

-- 2. delete rows created by user 
DELETE internal.operation_permissions WHERE sid = 0x0105000000000005150000003DE3084D728FB40A828BA628CE683300

-- 3. Drop user
USE [SSISDB]
GO
/****** Object:  User [GSM1900\LErnest1]    Script Date: 6/26/2021 5:12:32 AM ******/
DROP USER [GSM1900\LErnest1]
GO