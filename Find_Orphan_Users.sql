-- http://www.databasejournal.com/features/mssql/article.php/1578941
-- find and remove orphan users

--exec sp_change_users_login 'Report'

select u.name from master..syslogins l right join 
    sysusers u on l.sid = u.sid 
    where l.sid is null and issqlrole <> 1 and isapprole <> 1   
    and (u.name <> 'INFORMATION_SCHEMA' and u.name <> 'guest'  
    and u.name <> 'system_function_schema')

--sp_helpuser

--exec sp_revokedbaccess 'SQLAdmin'

--sp_changedbowner sa
--sp_changeobjectowner [relo_user.RECIPROCITY_RULE], dbo

--sp_revokelogin [AD\$sqlsvcacct]; -- windows account

--sp_droplogin 'orderaid' -- sql account

--EXEC tempdb.dbo.usp_OrphanLogins
--EXEC master.dbo.usp_remove_orphan_users

BDF
BusyCFA
WFM