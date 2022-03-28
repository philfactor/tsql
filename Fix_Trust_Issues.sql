
-- https://www.sentryone.com/blog/melissaconnors/does-your-database-have-trust-issues

-- check constraints
SELECT N'ALTER TABLE ' 
    + QUOTENAME(s.name) + N'.' + QUOTENAME(o.name) 
    + N' WITH CHECK CHECK CONSTRAINT ' 
    + QUOTENAME(c.name) + N';' AS CCsToFix
FROM sys.check_constraints c
INNER JOIN 
sys.objects o ON c.parent_object_id = o.object_id
INNER JOIN 
sys.schemas s ON o.schema_id = s.schema_id
WHERE c.is_not_trusted = 1 
AND c.is_not_for_replication = 0 
AND c.is_disabled = 0
ORDER BY CCsToFix;

-- foreign keys
SELECT N'ALTER TABLE ' + QUOTENAME(s.name) 
  + N'.' + QUOTENAME(o.name) + N' WITH CHECK CHECK CONSTRAINT ' 
  + QUOTENAME(f.name) + N';' AS FKstoFix
FROM    sys.foreign_keys f
INNER JOIN 
 sys.objects o ON f.parent_object_id = o.object_id
INNER JOIN 
 sys.schemas s ON o.schema_id = s.schema_id
WHERE f.is_not_trusted = 1 
 AND f.is_not_for_replication = 0
 ORDER BY FKstoFix;
 
 
