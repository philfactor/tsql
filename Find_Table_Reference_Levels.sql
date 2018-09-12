-- Start of Script - Find_Table_Reference_Levels.sql
/*
Find Table Reference Levels

This script finds table references and ranks them by level in order
to be able to load tables with FK references in the correct order.
Tables can then be loaded one level at a time from lower to higher.
This script also shows all the relationships for each table
by tables it references and by tables that reference it.

Level 0 is tables which have no FK relationships.

Level 1 is tables which reference no other tables, except
themselves, and are only referenced by higher level tables
or themselves.

Levels 2 and above are tables which reference lower levels
and may be referenced by higher levels or themselves.

*/

declare @r table (
PK_TABLE nvarchar(200),
FK_TABLE nvarchar(200),
primary key clustered (PK_TABLE,FK_TABLE))

declare @rs table (
PK_TABLE nvarchar(200),
FK_TABLE nvarchar(200),
primary key clustered (PK_TABLE,FK_TABLE))

declare @t table (
REF_LEVEL int,
TABLE_NAME nvarchar(200) not null primary key clustered )

declare @table table (
TABLE_NAME nvarchar(200) not null primary key clustered )
set nocount off

print 'Load tables for database '+db_name()

insert into @table
select
	TABLE_NAME = a.TABLE_SCHEMA+'.'+a.TABLE_NAME
from
	INFORMATION_SCHEMA.TABLES a
where
	a.TABLE_TYPE = 'BASE TABLE'	and
	a.TABLE_SCHEMA+'.'+a.TABLE_NAME <> 'dbo.dtproperties'
order by
	1

print 'Load PK/FK references'
insert into @r
select	distinct
	PK_TABLE = 
	b.TABLE_SCHEMA+'.'+b.TABLE_NAME,
	FK_TABLE = 
	c.TABLE_SCHEMA+'.'+c.TABLE_NAME
from
	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS a
	join
	INFORMATION_SCHEMA.TABLE_CONSTRAINTS b
	on
	a.CONSTRAINT_SCHEMA = b.CONSTRAINT_SCHEMA and
	a.UNIQUE_CONSTRAINT_NAME = b.CONSTRAINT_NAME
	join
	INFORMATION_SCHEMA.TABLE_CONSTRAINTS c
	on
	a.CONSTRAINT_SCHEMA = c.CONSTRAINT_SCHEMA and
	a.CONSTRAINT_NAME = c.CONSTRAINT_NAME
order by
	1,2

print 'Make copy of PK/FK references'
insert into @rs
select 
	*
from
	@r
order by
	1,2

print 'Load un-referenced tables as level 0'
insert into @t
select
	REF_LEVEL = 0,
	a.TABLE_NAME
from
	@table a
where
	a.TABLE_NAME not in
	(
	select PK_TABLE from @r union all 
	select FK_TABLE from @r
	)
order by
	1

-- select * from @r
print 'Remove self references'
delete from @r
where
	PK_TABLE = FK_TABLE

declare @level int
set @level = 0

while @level < 100
	begin
	set @level = @level + 1

	print 'Delete lower level references'
	delete from @r
	where
		PK_TABLE in 
		( select TABLE_NAME from @t )
		or
		FK_TABLE in 
		( select TABLE_NAME from @t )

	print 'Load level '+convert(varchar(20),@level)+' tables'

	insert into @t
	select
		REF_LEVEL =@level,
		a.TABLE_NAME
	from
		@table a
	where
		a.TABLE_NAME not in
		( select FK_TABLE from @r )
		and
		a.TABLE_NAME not in
		( select TABLE_NAME from @t )
	order by
		1

	if not exists (select * from  @r )
		begin
		print 'Done loading table levels'
		print ''
		break
		end

	end


print 'Count of Tables by level'
print ''

select
	REF_LEVEL,
	TABLE_COUNT = count(*)
from 
	@t
group by
	REF_LEVEL
order by
	REF_LEVEL

print 'Tables in order by level and table name'
print 'Note: Null REF_LEVEL nay indicate possible circular reference'
print ''
select
	b.REF_LEVEL,
	TABLE_NAME = convert(varchar(40),a.TABLE_NAME)
from 
	@table a
	left join
	@t b
	on a.TABLE_NAME = b.TABLE_NAME
order by
	b.REF_LEVEL,
	a.TABLE_NAME

print 'Tables and Referencing Tables'
print ''
select
	b.REF_LEVEL,
	TABLE_NAME = convert(varchar(40),a.TABLE_NAME),
	REFERENCING_TABLE =convert(varchar(40),c.FK_TABLE)
from 
	@table a
	left join
	@t b
	on a.TABLE_NAME = b.TABLE_NAME
	left join
	@rs c
	on a.TABLE_NAME = c.PK_TABLE
order by
	a.TABLE_NAME,
	c.FK_TABLE


print 'Tables and Tables Referenced'
print ''
select
	b.REF_LEVEL,
	TABLE_NAME = convert(varchar(40),a.TABLE_NAME),
	TABLE_REFERENCED =convert(varchar(40),c.PK_TABLE)
from 
	@table a
	left join
	@t b
	on a.TABLE_NAME = b.TABLE_NAME
	left join
	@rs c
	on a.TABLE_NAME = c.FK_TABLE
order by
	a.TABLE_NAME,
	c.PK_TABLE


-- End of Script
