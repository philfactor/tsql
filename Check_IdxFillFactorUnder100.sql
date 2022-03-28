
-- https://zarez.net/?p=3209
SELECT DB_NAME() AS Database_Name
, sc.name AS Schema_Name
, o.name AS Table_Name
, o.type_desc
, i.name AS Index_Name
, i.type_desc AS Index_Type
, i.fill_factor
FROM sys.indexes i
INNER JOIN sys.objects o ON i.object_id = o.object_id
INNER JOIN sys.schemas sc ON o.schema_id = sc.schema_id
WHERE i.name IS NOT NULL
AND o.type = 'U'
AND fill_factor <> '0'
ORDER BY i.fill_factor DESC, o.name
