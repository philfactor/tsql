-- Find_Tables_With_No_PK.sql
-- http://www.mssqltips.com/tip.asp?tip=1237
-- 06/03/08
-- Find tables that do not have a Primary Key

SELECT c.name 'schema', b.name 'table'
FROM sys.tables b  
INNER JOIN sys.schemas c ON b.schema_id = c.schema_id  
WHERE b.type = 'U' 
AND b.is_ms_shipped = '0'  -- add this filter to exclude system tables
AND NOT EXISTS 
(SELECT a.name  
FROM sys.key_constraints a  
WHERE a.parent_object_id = b.OBJECT_ID  
AND a.schema_id = c.schema_id  
AND a.type = 'PK')

ORDER BY 'schema'

