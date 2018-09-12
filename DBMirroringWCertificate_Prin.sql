-- DBMirroringWCertificate_Prin.sql
-- http://technet.microsoft.com/en-us/library/ms191140(v=sql.100).aspx

-- 1. create database master key
USE master;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '1_Strong_Password!';
GO

-- 2. make a certificate for server instance
USE master;
CREATE CERTIFICATE PVMXB852_cert 
   WITH SUBJECT = '852 certificate';
GO

-- 3. create a mirroring endpoint
CREATE ENDPOINT Endpoint_Mirroring
   STATE = STARTED
   AS TCP (
      LISTENER_PORT=5022
      , LISTENER_IP = ALL
   ) 
   FOR DATABASE_MIRRORING ( 
      AUTHENTICATION = CERTIFICATE PVMXB852_cert
      , ENCRYPTION = REQUIRED ALGORITHM AES
      , ROLE = ALL
   );
GO

-- 4. backup PVMXB852_cert, and copy to mirror host
BACKUP CERTIFICATE PVMXB852_cert TO FILE = 'I:\SQL_I\BU\PVMXB852_cert.cer';
GO

-- Configure principle host for inbound connections

-- 5. create login on principle host for mirror host
USE master;
CREATE LOGIN PVMXB854_login WITH PASSWORD = '1Sample_Strong_Password!@#';
GO

-- 6. create user for login
CREATE USER PVMXB854_user FOR LOGIN PVMXB854_login;
GO

-- 7. associate the certificate with the user
CREATE CERTIFICATE PVMXB854_cert
   AUTHORIZATION PVMXB854_user
   FROM FILE = 'I:\SQL_I\BU\PVMXB854_cert.cer'
GO

-- 8. Grant CONNECT permission on the login for the remote mirroring endpoint
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [PVMXB854_login];
GO

