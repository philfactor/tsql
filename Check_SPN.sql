-- https://www.sqlserverscience.com/configuration/enable-kerberos-authentication-without-rebooting-sql-server/

/*
    Description:    Check Active Directory for SQL Server SPN entries,
                    and script SETSPN commands, if required.
    by:             Max Vernon
*/

SET NOCOUNT ON;

DECLARE @ServerPort varchar(255);
DECLARE @MachineName varchar(255);
DECLARE @ServerName varchar(255);
DECLARE @InstanceName varchar(255);
DECLARE @UserName varchar(255);
DECLARE @cmd varchar(255);
DECLARE @domain varchar(255);
DECLARE @SPNName varchar(255);
DECLARE @SPNPort varchar(255);
DECLARE @SkipSPNName bit;
DECLARE @SkipSPNPort bit;
SET @SkipSPNName = 0;
SET @SkipSPNPort = 0;

DECLARE @t TABLE (
    txtOut nvarchar(255)
);

/*
    Get the TCP/IP Port the server is using
*/
SELECT @ServerPort = CONVERT(varchar(255), local_tcp_port)
FROM sys.dm_exec_connections dec
WHERE dec.session_id = @@SPID;

/*
    Get machine name -> if this server is clustered, return the name of the cluster virtual machine
        , server name -> this is in the format of MACHINE\INSTANCE
        , and instance name -> this will be JUST the INSTANCE name, taken from server name above.
*/
SET @MachineName = CONVERT(varchar(255), SERVERPROPERTY('MachineName'));
SET @ServerName = CONVERT(varchar(255), SERVERPROPERTY('ServerName'));
IF @MachineName = @ServerName --default instance
BEGIN
    SET @InstanceName = '';
END
ELSE
BEGIN
    SET @InstanceName = ':' + SUBSTRING(@ServerName, CHARINDEX('\', @ServerName) + 1, LEN(@ServerName) - CHARINDEX('\', @ServerName));
END

/*
    get the name of the service account SQL Server is using
*/
SET @cmd = 'WHOAMI'
DELETE FROM @t;
INSERT INTO @t (txtOut)
EXEC xp_cmdshell @cmd;
SELECT @UserName = t.txtOut
FROM @t t
WHERE t.txtOut IS NOT NULL;

/*
    Get the DNS Domain Name of the server
*/
SET @cmd = 'net config workstation | find /i "workstation domain dns name"'
DELETE FROM @t;
INSERT INTO @t (txtOut)
EXEC xp_cmdshell @cmd;
SELECT @domain = SUBSTRING(t.txtOut, 38, LEN(t.txtOut) - 37)
FROM @t t
WHERE t.txtOut IS NOT NULL;

/*
    SETSPN Using the Instance Name
*/
SET @SPNName = 'SETSPN -A ' + 'MSSQLSvc/' + @MachineName + '.' + @domain + @InstanceName + ' ' + @UserName;

/*
    SETSPN Using the Instance Port
*/
SET @SPNPort = 'SETSPN -A ' + 'MSSQLSvc/' + @MachineName + '.' + @domain + ':' + @ServerPort + ' ' + @UserName;

/*
    Check to see if the SPNs have been registered
*/

SET @cmd = 'SETSPN -L ' + @UserName + ' | FIND /I "MSSQLSvc/' + @MachineName + '.' + @domain + @InstanceName + '"';

DELETE FROM @t;
INSERT INTO @t (txtOut)
EXEC xp_cmdshell @cmd;

IF (SELECT COUNT(1) FROM @t t WHERE t.txtOut IS NOT NULL) = 1 SET @SkipSPNName = 1;

SET @cmd = 'SETSPN -L ' + @UserName + ' | FIND /I "MSSQLSvc/' + @MachineName + '.' + @domain + ':' + @ServerPort + '"';

DELETE FROM @t;
INSERT INTO @t (txtOut)
EXEC xp_cmdshell @cmd;

IF (SELECT COUNT(1) FROM @t t WHERE t.txtOut IS NOT NULL) = 1 SET @SkipSPNPort = 1;

IF EXISTS (SELECT 1 FROM @t t WHERE t.txtOut = N'''SETSPN'' is not recognized as an internal or external command,')
BEGIN
    DECLARE @msg nvarchar(100);
    SET @msg = N'''SETSPN'' is not recognized as an internal or external command,';
    RAISERROR (@msg, 14, 1);
END
ELSE
BEGIN
    IF @SkipSPNName = 0 
        PRINT (@SPNName)
    ELSE
        PRINT (N'SPN for instance already exists.');
    IF @SkipSPNPort = 0 
        PRINT (@SPNPort)
    ELSE
        PRINT (N'SPN for port already exists.');
END