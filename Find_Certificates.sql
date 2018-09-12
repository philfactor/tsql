

USE master
GO

-- this provides the list of certificates
SELECT * FROM sys.certificates
WHERE name NOT LIKE '##%'

