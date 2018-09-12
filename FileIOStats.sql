-- http://www.databasejournal.com/features/mssql/article.php/3796551/SQL-Server-Database-File-IO-Report.htm


DECLARE @DBID smallint
DECLARE @FILEID smallint
DECLARE @DBNAME sysname
DECLARE @FILENAME nvarchar(260)
 
CREATE TABLE #FileIOStats 
(name sysname,
filename nvarchar(260),
drive_letter char(1),
NumberReads bigint, 
NumberWrites bigint, 
BytesRead bigint, 
BytesWritten bigint, 
IoStallMS bigint)
 
DECLARE ALLFILES CURSOR FOR
SELECT dbid, fileid, [name], [filename] FROM [master].[dbo].[sysaltfiles] 
 
OPEN ALLFILES
FETCH NEXT FROM ALLFILES INTO @DBID, @FILEID, @DBNAME, @FILENAME
 
WHILE (@@FETCH_STATUS = 0)
BEGIN
 
                INSERT INTO #FileIOStats
                SELECT @DBNAME, @FILENAME, left(@FILENAME, 1), NumberReads, NumberWrites, BytesRead, BytesWritten, IoStallMS 
                FROM ::fn_virtualfilestats(@DBID, @FILEID) 
 
                FETCH NEXT FROM ALLFILES INTO @DBID, @FILEID, @DBNAME, @FILENAME
END
 
CLOSE ALLFILES
DEALLOCATE ALLFILES
 
SELECT * FROM #FileIOStats
DROP TABLE #FileIOStats
