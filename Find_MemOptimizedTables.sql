-- 08/11/2021
-- https://blog.sqlauthority.com/2019/06/02/how-to-list-all-memory-optimized-tables-in-sql-server-interview-question-of-the-week-227/

SELECT SCHEMA_NAME(Schema_id) SchemaName,
name TableName,
is_memory_optimized,
durability_desc,
create_date, modify_date
FROM sys.tables
GO