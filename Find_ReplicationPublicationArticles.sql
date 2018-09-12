-- https://stackoverflow.com/questions/2539858/list-all-tables-that-are-currently-published-for-replication-ms-sql
-- compiles list of replication publications and associated articles

USE [distribution];
GO

SELECT
     P.[publication]   AS [Publication Name]
    ,A.[publisher_db]  AS [Database Name]
    ,A.[article]       AS [Article Name]
    ,A.[source_owner]  AS [Schema]
    ,A.[source_object] AS [Object]
FROM
    [distribution].[dbo].[MSarticles] AS A
    INNER JOIN [distribution].[dbo].[MSpublications] AS P
        ON (A.[publication_id] = P.[publication_id])
ORDER BY
    P.[publication], A.[article];