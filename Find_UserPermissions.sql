-- https://www.sqlservercentral.com/Forums/1235858/List-All-Permissions-a-User-Has-in-SQL-Server

select sys.schemas.name 'Schema'
, sys.objects.name Object
, sys.database_principals.name username
, sys.database_permissions.type permissions_type
, sys.database_permissions.permission_name
, sys.database_permissions.state permission_state
, sys.database_permissions.state_desc
, state_desc + ' ' + permission_name + ' on ['+ sys.schemas.name + '].[' + sys.objects.name + '] to [' + sys.database_principals.name + ']' COLLATE LATIN1_General_CI_AS 
from sys.database_permissions 
left outer join sys.objects on sys.database_permissions.major_id = sys.objects.object_id 
left outer join sys.schemas on sys.objects.schema_id = sys.schemas.schema_id 
left outer join sys.database_principals on sys.database_permissions.grantee_principal_id = sys.database_principals.principal_id 
WHERE sys.database_principals.name = '<specified_user>'
order by 1, 2, 3, 5 