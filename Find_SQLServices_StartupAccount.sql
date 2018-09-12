-- https://www.sqlservercentral.com/Forums/Topic354182-8-1.aspx
-- List Service startup accounts for each SQL Service
-- Works for versions SQL2008 and earlier

Set nocount on
Set xact_abort on
Declare @registrypath varchar(200)
, @namedinstanceind char(1)
, @instancename varchar(128) 
, @sqlserversvcaccount varchar(128)
, @sqlagentsvcaccount varchar(128)
, @dtcsvcaccount varchar(128)
, @sqlsearchsvcaccount varchar(128)
, @sqlserverstartup varchar(128)
, @sqlagentstartup varchar(128)
, @dtcstartup varchar(128)
, @sqlsearchstartup varchar(128)
Create table #registryentry (value varchar(50), data varchar(50))
If @@servername is null
Or (charindex('\',@@servername)=0)
set @namedinstanceind = 'n'
Else
Begin
set @namedinstanceind = 'y'
set @instancename = right( @@servername , len(@@servername) - charindex('\',@@servername))
End

-- sql server 
Set @registrypath = 'system\currentcontrolset\services\'
If @namedinstanceind = 'n'
set @registrypath = @registrypath + 'mssqlserver'
Else
set @registrypath = @registrypath + 'mssql$' + @instancename
Insert #registryentry 
Exec master..xp_regread 'hkey_local_machine' , @registrypath,'objectname'
Select @sqlserversvcaccount = data from #registryentry
Delete from #registryentry
Insert #registryentry 
Exec master..xp_regread 'hkey_local_machine' , @registrypath,'start'
Select @sqlserverstartup = data from #registryentry
Delete from #registryentry

-- sql agent
Set @registrypath = 'system\currentcontrolset\services\'
If @namedinstanceind = 'n'
set @registrypath = @registrypath + 'sqlserveragent'
Else
set @registrypath = @registrypath + 'sqlagent$' + @instancename
Insert #registryentry 
Exec master..xp_regread 'hkey_local_machine' , @registrypath,'objectname'
Select @sqlagentsvcaccount = data from #registryentry
Delete from #registryentry
Insert #registryentry 
Exec master..xp_regread 'hkey_local_machine' , @registrypath,'start'
Select @sqlagentstartup = data from #registryentry
Delete from #registryentry

-- distributed transaction coordinator
Set @registrypath = 'system\currentcontrolset\services\msdtc'
Insert #registryentry 
Exec master..xp_regread 'hkey_local_machine' , @registrypath,'objectname'
Select @dtcsvcaccount = data from #registryentry
Delete from #registryentry
Insert #registryentry 
Exec master..xp_regread 'hkey_local_machine' , @registrypath,'start'
Select @dtcstartup = data from #registryentry
Delete from #registryentry


-- search (sql server )
Set @registrypath = 'system\currentcontrolset\services\mssearch'
Insert #registryentry 
Exec master..xp_regread 'hkey_local_machine' , @registrypath,'objectname'
Select @sqlsearchsvcaccount = data from #registryentry
Delete from #registryentry
Insert #registryentry 
Exec master..xp_regread 'hkey_local_machine' , @registrypath,'start'
Select @sqlsearchstartup = data from #registryentry
Delete from #registryentry


Select cast( serverproperty ('machinename') as nvarchar(128) ) as machinename
, coalesce ( cast( serverproperty ('instancename') as nvarchar(128) ) , 'default') as instancename
, @sqlserversvcaccount as sqlserversvcaccount
, @sqlagentsvcaccount as sqlagentsvcaccount
, @dtcsvcaccount as dtcsvcaccount
, @sqlsearchsvcaccount as sqlsearchsvcaccount
, @sqlserverstartup as sqlserverstartup
, @sqlagentstartup as sqlagentstartup
, @dtcstartup as dtcstartup
, @sqlsearchstartup as sqlsearchstartup 

