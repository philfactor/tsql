-- https://www.mssqltips.com/sqlservertip/2634/potential-security-exploit-using-control-server-permissions-in-sql-server/

SELECT login.name, perm.permission_name, perm.state_desc
FROM sys.server_permissions perm
JOIN sys.server_principals login
ON perm.grantee_principal_id = login.principal_id
WHERE permission_name = 'CONTROL SERVER';