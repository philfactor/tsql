

USE [<database_name>]; 
GO 
SELECT 
	name,
	type_desc,
	fill_factor
FROM 
	Sys.Indexes --WHERE Object_id=object_id('item') AND name IS NOT NULL; 
WHERE fill_factor > 0
GO
