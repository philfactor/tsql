-- http://blogs.msdn.com/sqltips/archive/2005/09/16/469136.aspx
-- Find Primary Keys in SQL2005 databa

select s.name as TABLE_SCHEMA, t.name as TABLE_NAME
     , k.name as CONSTRAINT_NAME, k.type_desc as CONSTRAINT_TYPE
     , c.name as COLUMN_NAME, ic.key_ordinal AS ORDINAL_POSITION
  from sys.key_constraints as k
  join sys.tables as t
    on t.object_id = k.parent_object_id
  join sys.schemas as s
    on s.schema_id = t.schema_id
  join sys.index_columns as ic
    on ic.object_id = t.object_id
   and ic.index_id = k.unique_index_id
  join sys.columns as c
    on c.object_id = t.object_id
   and c.column_id = ic.column_id
 order by TABLE_SCHEMA, TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME, ORDINAL_POSITION;
