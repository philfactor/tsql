-- https://www.red-gate.com/simple-talk/sql/database-administration/questions-about-kerberos-and-sql-server-that-you-were-too-shy-to-ask/
-- Check authentication scheme NTLM/Kerberos

SELECT S.login_name, C.client_net_address, C.auth_scheme, s.host_name
FROM sys.dm_exec_connections AS C
JOIN sys.dm_exec_sessions AS S ON C.session_id = S.session_id;

-- # connections group by auth_scheme
SELECT COUNT (auth_scheme) as nb, auth_scheme --net_transport, client_net_address 
FROM sys.dm_exec_connections
GROUP BY auth_scheme

-- current connection
SELECT net_transport, auth_scheme   
FROM sys.dm_exec_connections   
WHERE session_id = @@SPID; 

-- auth schemes in use
USE master
GO
 
SELECT distinct auth_scheme FROM sys.dm_exec_connections 
GO