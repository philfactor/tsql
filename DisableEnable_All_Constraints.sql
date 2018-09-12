-- https://blog.sqlauthority.com/2013/04/29/sql-server-disable-all-the-foreign-key-constraint-in-database-enable-all-the-foreign-key-constraint-in-database/
-- Disable_All_Logins.sql
-- Useful for disabling constraints so that tables with FK's can be emptied with delete command 

-- Disable all the constraint in database
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

-- Delete table to empty contents

-- Enable all the constraint in database
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
