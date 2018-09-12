-- 07/21/2016
-- when getting the following error from trying to change db owner
-- SP_CHANGEDBOWNER 'sa'
/*
Msg 15110, Level 16, State 1, Line 1
The proposed new database owner is already a user or aliased in the database.
*/

-- Here is the fix

SP_DROPUSER 'sa' 
GO
SP_CHANGEDBOWNER 'sa'
GO