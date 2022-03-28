-- email from Roberta Santos 08/30/2019
-- PJ023519_SQL2017\_IUT

--Phil,

--Here is the process I followed:

-- Getting Certificate Files

-- Since the database is encrypted the SQLMonitor identify it and store the certificate files in the dbo.tde_certificates_backup table automatically.

-- 1. Check the certificate name on tde_certificates_backup table: 
USE SQLMonitor 
GO

SELECT * FROM dbo.tde_certificates_backup 

-- Make sure that certification name corresponding to last certificate version (by the time_stamp field)

-- 2. To restore certificates from SQLMonitor: 
USE SQLMonitor 
GO

EXEC [dbo].[sp_tde_files_extraction] @instc_name = 'SERVER\INSTANCE', @db_name = 'DB_NAME', @cert_name = 'CERT_NAME'

-- 3. Following the procedure INSTANCE_NAME.txt placed in the TDE Output folder to restore the encrypted database.
