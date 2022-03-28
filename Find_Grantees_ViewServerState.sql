

use master;
set nocount on
select 
'grantee' = ssprin.[name]
, 'state_desc' = ssperm.[state_desc] 
, 'permission' = ssperm.[permission_name] 
from 
sys.server_permissions ssperm join sys.server_principals ssprin 
on ssperm.grantee_principal_id = ssprin.principal_id
WHERE ssperm.[permission_name] = 'VIEW SERVER STATE'