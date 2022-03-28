-- 09/21/2021
-- Check SQL Log for Login failures

EXEC sp_readerrorlog 0, 1, 'Login failed'