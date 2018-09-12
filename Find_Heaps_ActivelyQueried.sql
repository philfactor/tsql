-- https://basitaalishan.com/tag/active-tables-without-clustered-index/

DECLARE @MinTableRowsThreshold [int];
 
SET @MinTableRowsThreshold = 100000;
 
;WITH    [TablesWithoutClusteredIndexes] ( [db_name], [table_name], [table_schema], [row_count] )
          AS ( SELECT   DB_NAME() ,
                        t.[name] ,
                        SCHEMA_NAME(t.[schema_id]) ,
                        SUM(ps.[row_count])
               FROM     [sys].[tables] t
                        INNER JOIN [sys].[dm_db_partition_stats] ps
                        ON ps.[object_id] = t.[object_id]
                        INNER JOIN [sys].[dm_db_index_usage_stats] us
                        ON ps.[object_id] = us.[object_id]
               WHERE    OBJECTPROPERTY(t.[object_id], N'TableHasClustIndex') = 0
                        AND ps.[index_id] < 2
            AND COALESCE(us.[user_seeks] ,
                         us.[user_scans] ,
                         us.[user_lookups] ,
                         us.[user_updates]) IS NOT NULL
               GROUP BY t.[name] ,
                        t.[schema_id] )
    SELECT  *
    FROM    [TablesWithoutClusteredIndexes]
    WHERE   [row_count] > @MinTableRowsThreshold;