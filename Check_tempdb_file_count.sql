-- use this script to check number of tempdb data files. Default is ONE tempdb file.
-- 12/16/2016
-- start with minimum of 4 tempdb files, equally sized & fixed MB autogrowth increment instead of % autogrowth increment.
-- if possible, separate tempdb data files from tempdb log files.
-- if possible, move tempdb files away from system drive or binaries drive where other system db's are located.

USE [tempdb];
GO
SELECT COUNT(*) AS 'count_tempdb_files' 
FROM sysfiles
WHERE groupid = '1'