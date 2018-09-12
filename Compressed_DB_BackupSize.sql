-- Compressed_DB_BackupSize.sql
-- 03/17/2015

SELECT
	MAX(backup_start_date) 'backup_start_date', 
	database_name,
	(SELECT MAX(BakDet.backup_size/1048576) -- 1048576 bytes-per-megabyte
	FROM msdb..backupset AS BakDet
	WHERE Bak.database_name = BakDet.database_name
	AND has_backup_checksums = '1') AS BakSizeMB,
	(SELECT MAX(BakDet.compressed_backup_size/1048576) -- 1048576 bytes-per-megabyte
	FROM msdb..backupset AS BakDet
	WHERE Bak.database_name = BakDet.database_name
	AND has_backup_checksums = '1') AS CompressBakSizeMB
FROM
	msdb..backupset AS Bak	
GROUP BY 
	database_name
	
ORDER BY
	database_name 

--SELECT * from msdb..backupset
--WHERE database_name = 'AspNetDb' AND has_backup_checksums = '1'		