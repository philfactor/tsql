-- List databases Snapshot Isolation state

SELECT
	name, 
	snapshot_isolation_state_desc 
from 
	sys.databases 
	
--Alternatively, use Powershell:

PS SQLSERVER:\SQL\SHAREDSQL08\DEFAULT+sa\Databases\> get-childitem|select name,
snapshotisolationstate



