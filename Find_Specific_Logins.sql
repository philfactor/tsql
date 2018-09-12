-- Find_SpecificLogins.sql
-- Phil Streiff, MCDBA, MCITP
-- 09/09/2015

select 
	--name,
	loginname,
	dbname,
	isntgroup,
	isntuser,
	sysadmin,
	securityadmin,
	serveradmin,
	setupadmin,
	processadmin,
	diskadmin,
	dbcreator,
	bulkadmin

from 
	syslogins
where
	name = 'PERCEPTIVECLOUD\PerceptiveMS'