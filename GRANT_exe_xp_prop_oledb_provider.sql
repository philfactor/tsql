-- http://www.kodyaz.com/t-sql/sqlserver-linked-server-execute-permission-denied-on-xp-prop-oledb-provider.aspx

USE [master]
GO
CREATE USER [ROBOPROV] FOR LOGIN [ROBOPROV]
GO
USE [master]
GO
ALTER USER [ROBOPROV] WITH DEFAULT_SCHEMA=[dbo]
GO


USE [master];
GO
grant execute on xp_prop_oledb_provider to ROBOPROV