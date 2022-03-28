/*Truncate Staging*/
TRUNCATE TABLE tracking.dbo.sql_access_list_stg

DECLARE @wingrplogins table
(acct_name sysname,
acct_type varchar(10),
act_priv varchar(10),
login_name sysname,
perm_path sysname)

DECLARE @DBID AS INT /*Used to assign DB you're searching*/
DECLARE @DB AS VARCHAR(max) /*Name of DB you are searching*/
DECLARE @SQL AS NVARCHAR(max) /*SQL to execute that inserts permissions into STG*/

DECLARE @group sysname

DECLARE grecscan cursor for
select name from sys.server_principals
where type = 'G' and name not like 'NT%'

SET @DBID = (
               SELECT MIN(database_id)
               FROM [sys].[databases]
               )
SET @DB = (
               SELECT name
               FROM [sys].[databases]
               WHERE database_id = @DBID
               )
SET @SQL = (N'INSERT INTO tracking.dbo.sql_access_list_stg (name) Select name FROM ' + @DB + N'.sys.database_principals where type_desc = ''WINDOWS_USER'' and name <>''NT AUTHORITY\SYSTEM''')

SELECT @DBID --Used for testing

SELECT @DB --Used for testing

SELECT @SQL --Used for testing

/*While DBID isn't null this code loops through and collects windows users for each database found in sys.databases inserting them into tracking.dbo.sql_access_list_stg*/
WHILE @DBID IS NOT NULL
BEGIN
        EXEC sp_executesql @SQL

        SET @DBID = (
                       SELECT MIN(database_id)
                       FROM [sys].[databases]
                       WHERE database_id > @DBID
                       )
        SET @DB = (
                       SELECT name
                       FROM [sys].[databases]
                       WHERE database_id = @DBID
                       )
        SET @SQL = (N'INSERT INTO tracking.dbo.sql_access_list_stg (name) Select name FROM ' + @DB + N'.sys.database_principals where type_desc = ''WINDOWS_USER'' and name <>''NT AUTHORITY\SYSTEM''')
        
END

open grecscan
fetch next from grecscan into @group

while @@FETCH_STATUS = 0
begin
     insert into @wingrplogins
     exec xp_logininfo @group,'members'
     fetch next from grecscan into @group
end
close grecscan
deallocate grecscan

INSERT INTO tracking.dbo.sql_access_list_stg (name) Select login_name FROM @wingrplogins

/*Transaction will truncate prod tables then insert unique users from STG I did add exclusions here for vetted application accounts as these will not show csg00002 in LDAP*/
BEGIN TRANSACTION

TRUNCATE TABLE Tracking.dbo.sql_access_list

/*inserts unique adids into tracking.dbo.sql_access_list*/
INSERT INTO Tracking.dbo.sql_access_list (name)
SELECT DISTINCT name
FROM tracking.dbo.sql_access_list_stg
WHERE name NOT IN (
              	'AD\SREGSUSR'
               	,'AD\$prodcntl'
               	,'NT SERVICE\SQLServerReportingServices'
	,'NT SERVICE\SQLAgent$MS2017_PROD'
	,'NT SERVICE\MSSQL$MS2017_PROD'
	,'NT SERVICE\MsDtsServer140'
	,'NT AUTHORITY\NETWORK SERVICE'
	,'NT AUTHORITY\LOCAL SERVICE'
	,'AD\SQL-DB-Admins (Onshore)'
                ,'AD\$FUP_CblsqlPROD'
	,'AD\PVMXE094$'
	,'AD\PVMXE095$'
	,'AD\PVMXE097$'
               ,'dbo'
               )

TRUNCATE TABLE Tracking.dbo.sql_access_list_csg_status

/*Inserts CSG status into tracking.dbo.sql_access_list_csg_status*/
INSERT INTO Tracking.dbo.sql_access_list_csg_status (
        name
        ,CSG
        )
SELECT a.name
        ,CSG.CSG
FROM Tracking.dbo.sql_access_list a WITH (NOLOCK)
LEFT JOIN (
        SELECT 'AD\' + sAMAccountName AS ADID
               ,'CSG00002' AS CSG
        FROM OPENQUERY(IDMData, 'Select mail, sAMAccountName, displayname
               FROM ''LDAP://IDMDATA/OU=People,O=Sprint,C=US'' 
               Where ObjectCategory = ''Person'' 
                       and fonConSecGrp =''00002''') AS LDAP
        ) AS CSG ON a.name = CSG.ADID

COMMIT TRANSACTION

/*If there are any non CSG00002 users email distro to alert that action needs to be taken. This could likely be replaced by a process that auto disables the accounts in a later version*/
IF (
               SELECT COUNT(*)
               FROM Tracking.dbo.sql_access_list_csg_status csg_status
               WHERE csg_status.CSG IS NULL
               ) > 0
BEGIN
        DECLARE @msg AS NVARCHAR(4000)
        DECLARE @subject AS NVARCHAR(255)
        DECLARE @to AS NVARCHAR(4000)
        DECLARE @cc AS NVARCHAR(4000)
        DECLARE @date AS VARCHAR(25)
        DECLARE @BlindCC AS NVARCHAR(4000)
        DECLARE @BODY AS VARCHAR(MAX)

        /* SET @TO='SFWDBS-SQLSRVRDBA-ONSHORE@sprint.com' */
        SET @TO = 'SFWDBS-SQLSRVRDBA-ONSHORE@sprint.com'
        SET @CC = ''
        SET @BlindCC = ''
        SET @date = GETDATE()
        SET @subject = N'CSG AUDIT ALERT PVMXE096 (ACTION REQUIRED) - ' + @date
        --    Create the body
        SET @body = cast((
                               SELECT td = cast(NAME AS VARCHAR(100)) + '</td><td>' + cast(GETDATE() AS VARCHAR(20))
                               FROM (
                                      SELECT NAME
                                      FROM Tracking.dbo.sql_access_list_csg_status csg_status
                                      WHERE csg_status.CSG IS NULL
                                      ) AS d
                               ORDER BY NAME DESC
                               FOR XML path('tr')
                                      ,type
                               ) AS VARCHAR(max))
        SET @body = '<table cellpadding="2" cellspacing="2" border="1">' + '<tr><th>ADID</th><th>Date</th></tr>' + replace(replace(@body, '&lt;', '<'), '&gt;', '>') + '</table>'
        SET @msg = (
                       N'
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML xmlns:o = "urn:schemas-microsoft-com:office:office"><HEAD>
<META content="MSHTML 6.00.2800.1498" name=GENERATOR></HEAD>

<BODY>

<FONT size=6>
<P><SPAN class=213494715-28102004><U><STRONG>CSG AUDIT ALERT PVMXE096 ACTION REQUIRED.</STRONG></U></P>
<FONT size=3>All,<P>
The following users have been given access to PVMXE096 and are not CSG00002 VETTED. REVOKE ACCESS IMMEDIATELY! ' + @date + '.  Please contact SFWDBS-SQLSRVRDBA-ONSHORE@sprint.com with any questions or further requests.  <b>
<P>' + @BODY + 
                       '<P>
        Thanks!</b>
<br><br>
<P>
<font color="FF0000">IMPORTANT: This message (including any attachments) may contain material, non-public information, or proprietary information and is for the intended recipients only. If you are not the intended recipient, notify the sender and delete this message. Any disclosure, copying, or use of this information is strictly prohibited and may subject you to legal liability.
</font><P>
               <BR><B><FONT face=Interstate-Bold color=#ffcc00 size=4>Sprint Nextel</FONT><br>
        <FONT face=Interstate-Bold size=5></FONT></B> <FONT face=Interstate-Regular>IT Data Management</FONT> 
        <UL><UL><UL>
        <I><FONT face=Interstate-RegularCondensed>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</FONT>
        </I> </P></UL></UL></UL>
        
        </BODY></HTML>
        '
                       )

        EXEC msdb..sp_send_dbmail @profile_name = 'DBA_Notifications'
               ,@recipients = @to
               ,@Copy_Recipients = @CC
               ,@Blind_Copy_Recipients = @BlindCC
               ,@subject = @subject
               ,@body = @msg
               ,@body_format = 'HTML'
               ,@importance = 'HIGH'
               ,@sensitivity = 'Normal'
END
ELSE
        /*Do this if everyone is vetted*/
        SELECT GETDATE()
