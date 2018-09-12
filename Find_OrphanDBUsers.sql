
-- identify orphan users

-- http://www.databasejournal.com/features/mssql/article.php/1578941

-- find Orphaned DB User Accounts that do not have corresponding Server Login
-- run in each user database

select u.name from master..syslogins l right join 
sysusers u on l.sid = u.sid 
where l.sid is null and issqlrole <> 1 and isapprole <> 1   
and (u.name <> 'INFORMATION_SCHEMA' and u.name <> 'guest'  
and u.name <> 'system_function_schema')

-- after identifying orphaned users with above script 
-- run sp_change_users_login 'auto_fix', 'UserName'
-- where 'UserName' is the name of each user ID'ed above
-- OR drop db users that do not have Login
--sp_revokelogin [AD\$sqlsvcacct]; -- windows account
--sp_droplogin 'orderaid' -- sql account

-- Phil Streiff, MCDBA