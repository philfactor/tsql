SELECT o.id, o.name
FROM sys.syscomments as c
JOIN sys.sysobjects as o
ON o.id = c.id
WHERE xtype='P' --stored procs
--AND Name LIKE 'usp_%' --my prefix
AND LOWER(text) NOT LIKE '%set nocount on%'
GROUP BY o.name, o.id

ORDER BY o.Name

