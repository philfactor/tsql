-- Find_DisabledIndexes.sql
-- 07/07/2015

select
    sys.objects.name AS 'table name',
    sys.indexes.name AS 'index name'
from sys.indexes
    inner join sys.objects on sys.objects.object_id = sys.indexes.object_id
where sys.indexes.is_disabled = 1
order by
    sys.objects.name,
    sys.indexes.name