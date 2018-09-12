-- 12/09/2016
-- checks to see which servers have 'max degree of parallelism' value set to ZER0, which means 'use all available processors'
-- most of the time, this is NOT optimum setting for perforrmance
-- Run script to determine optimimum maxdop setting at each server\instance level
	
SELECT name, value_in_use 
FROM sys.configurations
WHERE configuration_id = 1539 AND value_in_use = 0
--order by name