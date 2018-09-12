-- 05/22/2018
-- Phil Streiff
-- SQL Server 2008
USE [master];
GO
select session_id, net_transport, client_net_address, client_tcp_port, encrypt_option 
from sys.dm_exec_connections