-- https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/create-identical-symmetric-keys-on-two-servers?view=sql-server-ver15
-- https://chrisfleischhacker.wordpress.com/2015/03/20/create-identical-symmetric-keys-on-two-sql-servers/

-- On source server
OPEN SYMMETRIC KEY [SymKey]   
    DECRYPTION BY CERTIFICATE S3cCert;  
GO  
SELECT encryptbykey(key_guid('SymKey'), 'Reporting' )  
GO  
-- Results
-- 0x004737A6D0F9330C134EAD08C70B353A0100000032727EABF219B6DA4E70E4589F65D907A6E5C51F67534052A44DB45878FA4C4AEE8B35BC13E1C823A480EC8C6598FBAF

-- On destination server
USE [Reporting];
GO
OPEN SYMMETRIC KEY SymKey             
DECRYPTION BY CERTIFICATE S3cCert; 
GO
DECLARE @blob varbinary(8000);
SET @blob = CONVERT(varbinary(8000), (SELECT CONVERT(varchar(8000), decryptbykey('0x004737A6D0F9330C134EAD08C70B353A0100000032727EABF219B6DA4E70E4589F65D907A6E5C51F67534052A44DB45878FA4C4AEE8B35BC13E1C823A480EC8C6598FBAF'))));
GO

CLOSE SYMMETRIC KEY SymKey

/*
Msg 15581, Level 16, State 7, Line 6
Please create a master key in the database or open the master key in the session before performing this operation.
Msg 15315, Level 16, State 1, Line 13
The key 'SymKey' is not open. Please open the key before using it.
*/