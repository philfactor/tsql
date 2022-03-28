
-- http://stackoverflow.com/questions/216007/how-to-determine-total-number-of-open-active-connections-in-ms-sql-server-2005

-- number of connections per DB
SELECT 
    DB_NAME(dbid) as DBName, 
    COUNT(dbid) as NumberOfConnections,
    loginame as LoginName
FROM
    sys.sysprocesses
WHERE 
    dbid > 0
GROUP BY 
    dbid, loginame
    

