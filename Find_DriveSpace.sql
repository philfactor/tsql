-- http://www.sqlservercentral.com/scripts/DISK/72323/

/*
Author:		Nicholas Williams
Date:            	2009 sometime 
Description:   	Provides information on the drive capacities for a particular instance.
                	Requires xp_cmdshell to be active, and the fsutil windows utility. (Present on Windows Server 2003+) user must have sa permissions. uses a (fast) cursor.... yeah, i know... :(
                	Results are returned in MB. 
                	 xp_cmdshell enabler:
                   		 sp_configure 'show advanced options',1
                  		 GO
                    		RECONFIGURE
                    		GO
                    		sp_configure 'xp_cmdshell',1
                    		GO
                    		RECONFIGURE
*/

SET NOCOUNT ON
DECLARE 
     @vcName     CHAR(1)
CREATE TABLE #tbl_disks
    (
     Drive    CHAR(1)
    ,[Space]    INT
    )

CREATE TABLE ##tbl_Volumes
    (
     Drive    CHAR(1)
    ,Info    VARCHAR(2000)
    )

CREATE TABLE ##tbl_Volumes2
    (
     Info    VARCHAR(2000)
    )

INSERT INTO #tbl_disks
EXEC master.dbo.xp_fixeddrives 

DECLARE file_cursor CURSOR FOR
SELECT Drive FROM #tbl_disks
ORDER BY Drive
OPEN file_cursor

 FETCH NEXT FROM file_cursor
 INTO @vcName

WHILE @@FETCH_STATUS = 0
BEGIN 

EXEC
    ('
    INSERT INTO ##tbl_Volumes (Drive)
    VALUES ('''+@vcName+''')

    INSERT INTO ##tbl_Volumes2
    EXEC master.dbo.xp_cmdshell ''fsutil volume diskfree '+@vcName+':''

    UPDATE ##tbl_Volumes 
    SET Info = v2.Info
    FROM ##tbl_Volumes2 v2
    WHERE v2.Info LIKE ''%Total # of bytes%''
    AND ##tbl_Volumes.Drive = '''+@vcName+'''

    TRUNCATE TABLE ##tbl_Volumes2
    ')

 FETCH NEXT FROM file_cursor
 INTO @vcName

END
CLOSE file_cursor
DEALLOCATE file_cursor

SELECT 
     CAST(@@SERVERNAME as VARCHAR(35)) ServerName
    ,v.Drive
    ,(CAST((SUBSTRING(v.Info,(CHARINDEX(':',v.Info,1)+1), (LEN(v.Info)-(CHARINDEX(':',v.Info,1))))) as DECIMAL(38,5)))/(1024*1024) TotalVolume
    ,d.[Space] FreeSpace
    ,(CAST((SUBSTRING(v.Info,(CHARINDEX(':',v.Info,1)+1), (LEN(v.Info)-(CHARINDEX(':',v.Info,1))))) as DECIMAL(38,5)))/(1024*1024) - (d.[Space]) as SpaceUsed
    ,CAST((d.[Space] / ((CAST((SUBSTRING(v.Info,(CHARINDEX(':',v.Info,1)+1), (LEN(v.Info)-(CHARINDEX(':',v.Info,1))))) as DECIMAL(38,5)))/(1024*1024) / 100)) AS INT) PercentFreeSpace 
FROM ##tbl_Volumes v
INNER JOIN #tbl_disks d ON v.Drive = d.Drive

PRINT 'Results are returned in MB, unless otherwise specified'

DROP TABLE #tbl_disks
DROP TABLE ##tbl_Volumes
DROP TABLE ##tbl_Volumes2
SET NOCOUNT OFF

