-- 2019/10/25

-- syslogins
USE [master];
GO
SELECT sid, status, createdate, name, dbname, hasaccess, loginname
FROM syslogins
WHERE isntname = '0' and dbname in ('SSTAT','SSTATSA')



-- sysusers
USE [SSTAT];
GO
select sid, status, createdate, name
FROM sysusers
WHERE hasdbaccess = '1' and issqluser = '1'