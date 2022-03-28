-- Check_Encrypted_DBs.sql
-- 02/11/2021
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-database-encryption-keys-transact-sql?redirectedfrom=MSDN&view=sql-server-ver15

USE [master];
GO
SELECT e.database_id, d.name, e.encryption_state, key_algorithm, key_length, encryptor_type
FROM sys.dm_database_encryption_keys e join sys.databases d on d.database_id = e.database_id
WHERE encryption_state = '3'


-- Alternatively

-- https://stackoverflow.com/questions/61513305/check-if-my-database-instance-on-sql-server-is-encrypted-by-tde
SELECT
    db.name,
    db.is_encrypted,
    dm.encryption_state,
    dm.percent_complete,
    dm.key_algorithm,
    dm.key_length
FROM
    sys.databases db
    LEFT OUTER JOIN sys.dm_database_encryption_keys dm
        ON db.database_id = dm.database_id;
GO