-- Find databases located on a specific drive location
SELECT
    db.name AS DBName,
    type_desc AS FileType,
	mf.name AS 'Logical File Name',
    Physical_Name AS Location,
	--mf.size 
	(cast(mf.size as float)*8)/1024/1024 as FILE_SIZE_GB
FROM
    sys.master_files mf
INNER JOIN 
    sys.databases db ON db.database_id = mf.database_id
WHERE
	physical_name LIKE 'G:\EIT_ODS_Data8_Ext\Data\%%' -- replace with file path you want to check