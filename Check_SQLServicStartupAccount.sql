-- https://sqlandme.com/2013/08/20/sql-service-get-sql-server-service-account-using-t-sql/

DECLARE       @DBEngineLogin       VARCHAR(100)
DECLARE       @AgentLogin          VARCHAR(100)
 
EXECUTE       master.dbo.xp_instance_regread
              @rootkey      = N'HKEY_LOCAL_MACHINE',
              @key          = N'SYSTEM\CurrentControlSet\Services\MSSQLServer',
              @value_name   = N'ObjectName',
              @value        = @DBEngineLogin OUTPUT
 
EXECUTE       master.dbo.xp_instance_regread
              @rootkey      = N'HKEY_LOCAL_MACHINE',
              @key          = N'SYSTEM\CurrentControlSet\Services\SQLServerAgent',
              @value_name   = N'ObjectName',
              @value        = @AgentLogin OUTPUT
 
SELECT        [DBEngineLogin] = @DBEngineLogin, [AgentLogin] = @AgentLogin
GO

-- For SQL Server 2008R2+ use new DMV
SELECT servicename, service_account
FROM   sys.dm_server_services
GO