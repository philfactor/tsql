-- DetectLastDBShrinkOperation
-- http://sqlblog.com/blogs/jonathan_kehayias/archive/2009/05/13/when-was-the-last-time-a-database-or-file-was-shrunk.aspx

DECLARE @filename VARCHAR(MAX) 
SELECT @filename = CAST(value AS VARCHAR(MAX)) 
FROM fn_trace_getinfo(DEFAULT) 
WHERE property = 2 
  AND value IS NOT NULL 

SELECT gt.EventClass, 
       te.Name AS EventName,  
       gt.TEXTData, 
       gt.NTUserName, 
       gt.NTDomainName, 
       gt.HostName, 
       gt.ApplicationName, 
       gt.LoginName, 
       gt.SPID, 
       gt.StartTime, 
       gt.EndTime, 
       gt.ObjectName, 
       gt.DatabaseName, 
       gt.FileName 
FROM [fn_trace_gettable](@fileName, DEFAULT) gt 
JOIN sys.trace_events te ON gt.EventClass = te.trace_event_id 
WHERE EventClass = 116 -- to detect autoshrink, change where clause: WHERE EventClass IN (94, 95)
  AND TEXTData LIKE '%SHRINK%' 
ORDER BY StartTime;