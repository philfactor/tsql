-- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-certificates-transact-sql
-- Check for external certificates by excluding names beginning with ##

select * from sys.certificates 
where name not like '##%%'