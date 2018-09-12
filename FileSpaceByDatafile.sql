-- http://www.sqlservercentral.com/Forums/Topic511228-146-1.aspx
-- FileSpaceByDatafile.sql
-- 06/16/2011 

select   sysfilegroups.groupid
,       Files.FileId
,       sysfilegroups.groupname
,       Files.FileName
,       Files.AllocatedMb
,       Files.SpaceUsedMb
,       Files.AllocatedMb - Files.SpaceUsedMb as SpaceFreeMb
from    dbo.sysfilegroups
JOIN    (
        SELECT  sysfiles.FileId
        ,       sysfiles.name           AS FileName
        ,       sysfiles.groupid                
        ,       (sysfiles.size * 8) / 1024      AS AllocatedMb
        ,       ( (CAST(FILEPROPERTY(sysfiles.name, 'SpaceUsed' ) AS int) * 8 ) / 1024)  AS SpaceUsedMb
        FROM    dbo.sysfiles
        ) as Files      
        on sysfilegroups.groupid = Files.groupid
order by sysfilegroups.groupid
,       Files.FileId

