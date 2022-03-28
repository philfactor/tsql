-- https://www.mssqltips.com/sqlservertip/3654/how-to-modify-sql-server-database-mail-accounts/

-- 1. Run below script to gather DBMail properties
SELECT [sysmail_server].[account_id]
              ,[sysmail_account].[name] AS [Account Name]
      ,[servertype]
      ,[servername] AS [SMTP Server Address]
      ,[Port]
FROM [msdb].[dbo].[sysmail_server]
  INNER JOIN [msdb].[dbo].[sysmail_account]
ON [sysmail_server].[account_id]=[sysmail_account].[account_id]


-- output
account_id  Account Name            servertype    SMTP Server Address        Port
----------- ----------------------- ------------- -------------------------- -----------
1           TVMXE312\MS2017_TEST    SMTP          mailhost.corp.sprint.com   25



-- 2. Run below SP to change any info of mail account. Replace XXXX & XX with your correct SMTP IP address and port no.
EXECUTE msdb.dbo.sysmail_update_account_sp
    @account_name = 'TVMXE312\MS2017_TEST'
    ,@description = 'Mail account for administrative e-mail.'
    ,@mailserver_name = 'mail.t-mobile.com'
    ,@mailserver_type = 'SMTP'
    ,@port = 25


-- DMZ mailhost
idc-lsdc-mailhost.corp.sprint.com