-- https://www.mssqltips.com/sqlservertip/4112/minimum-permissions-for-sql-server-truncate-table/
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/grant-object-permissions-transact-sql?view=sql-server-ver15

USE [SQLHRIS];
GO
GRANT ALTER ON OBJECT::dbo.HRISDATA_BK TO robohr;
GO 