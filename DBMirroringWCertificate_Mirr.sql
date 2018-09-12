-- DBMirroringWCertificate_Mirr
-- http://technet.microsoft.com/en-us/library/ms191140(v=sql.100).aspx

-- 1. create database master key
USE master;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Strong_Password_#2';
GO

-- 2. create certificate on mirror host
CREATE CERTIFICATE PVMXB854_cert 
   WITH SUBJECT = 'PVMXB854 certificate for database mirroring';
GO

-- 3. create mirroring endpoint for mirror host
CREATE ENDPOINT Endpoint_Mirroring
   STATE = STARTED
   AS TCP (
      LISTENER_PORT=5022
      , LISTENER_IP = ALL
   ) 
   FOR DATABASE_MIRRORING ( 
      AUTHENTICATION = CERTIFICATE PVMXB854_cert
      , ENCRYPTION = REQUIRED ALGORITHM AES
      , ROLE = ALL
   );
GO

-- 4. backup PVMXB854_cert, and copy to mirror host
BACKUP CERTIFICATE PVMXB854_cert TO FILE = 'I:\SQL_I\BU\PVMXB854_cert.cer';
GO

-- Configure mirror host for inbound connections

-- 5. create login on principle host for mirror host
USE master;
CREATE LOGIN PVMXB852_login WITH PASSWORD = '=Sample#2_Strong_Password2';
GO

-- 6. create user for login
CREATE USER PVMXB852_user FOR LOGIN PVMXB852_login;
GO

-- 7. associate the certificate with the user
CREATE CERTIFICATE PVMXB852_cert
   AUTHORIZATION PVMXB852_user
   FROM FILE = 'I:\SQL_I\BU\PVMXB852_cert.cer'
GO

-- 8. Grant CONNECT permission on the login for the remote mirroring endpoint
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [PVMXB852_login];
GO