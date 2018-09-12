-- Find_Files_In_FileGroup.sql
-- 01/04/2011

select 
	fg.data_space_id 'FG_ID',
	fg.name 'FG_NAME', 
	f.name 'LOGICAL_NAME',
	f.filename 'FILE_NAME',
	f.size 'SIZE'	
from 
	sys.filegroups fg
	JOIN sys.sysfiles f
	ON fg.data_space_id = f.groupid
--where
--	f.filename = 'N:\N001\Data\FN_MONTHLY_Monthly_Acts_Deacts_By_Corp_201007.ndf'
ORDER BY
	f.size desc	
