-- if this happens

--USE [master]
--GO
--/****** Object:  Login [AD\bh716288]    Script Date: 03/25/2013 22:30:19 ******/
--DROP LOGIN [AD\bh716288]
--GO

--Msg 15173, Level 16, State 1, Line 2
--Login 'AD\bh716288' has granted one or more permission(s). Revoke the permission(s) before dropping the login.

-- do this

Select * from sys.server_permissions 

where grantor_principal_id = 

(Select principal_id from sys.server_principals where name = N'AD\bh716288') 
