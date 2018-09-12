


SELECT 
  sp.class_desc, 
  sp.permission_name, 
  sp.state_desc, 
  p.name as grantee_name, 
  p.type_desc as grantee_type 
FROM sys.server_permissions sp 
    INNER JOIN sys.server_principals p 
         ON p.principal_id = sp.grantee_principal_id 
WHERE grantor_principal_id = ( 
    SELECT principal_id FROM sys.server_principals WHERE name = N'AD\lxg1684' 
)