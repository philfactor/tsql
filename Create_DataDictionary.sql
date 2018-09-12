create table #dd (
 table_id int NULL,
 table_name nvarchar(128) NULL,
 column_order int NULL,
 column_name varchar(60) NULL,
 column_datatype varchar(20) NULL,
 column_length int NULL,
 column_description varchar(500) NULL
)

DECLARE @table_name nvarchar(128)

DECLARE tablenames_cursor CURSOR FOR 
SELECT name FROM sysobjects where type = 'U' and status > 1 order by name

OPEN tablenames_cursor
FETCH NEXT FROM tablenames_cursor INTO @table_name
WHILE @@FETCH_STATUS = 0
BEGIN
 insert #dd select 
  o.[id] as 'table_id', 
  o.[name] as 'table_name',
  0 as 'column_order',
  NULL as 'column_name',
  NULL as 'column_datatype',
  NULL as 'column_length',
  Cast(e.value as varchar(500)) as 'column_description' 
 from sysobjects o 
 left join ::FN_LISTEXTENDEDPROPERTY(N'MS_Description',
 N'user',N'dbo',N'table', @table_name, null, default) e on o.name = e.objname

 -- added 11/14/2006
 COLLATE Latin1_General_CI_AS 
 -- end added
 where o.name = @table_name

 insert #dd select 
  o.[id] as 'table_id', 
  o.[name] as 'table_name',
  c.colorder as 'column_order',
  c.[name] as 'column_name',
  t.[name] as 'column_datatype',
  c.[length] as 'column_length',
  Cast(e.value as varchar(500)) as 'column_description' 
 from sysobjects o inner join syscolumns c on o.id = c.id inner join systypes t on c.xtype = t.xtype
 left join ::FN_LISTEXTENDEDPROPERTY(N'MS_Description',
 N'user',N'dbo',N'table', @table_name, N'column', null) e on c.name = e.objname
 
 -- added 11/14/2006
 COLLATE Latin1_General_CI_AS
 -- end added
 where o.name = @table_name
 order by c.colorder

   FETCH NEXT FROM tablenames_cursor INTO @table_name
END

CLOSE tablenames_cursor
DEALLOCATE tablenames_cursor

select * from #dd
drop table #dd

Return
Go
