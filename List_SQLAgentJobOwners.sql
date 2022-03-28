-- https://zarez.net/?p=505

SELECT J.name AS Job_Name
, L.name AS Job_Owner
FROM msdb.dbo.sysjobs_view J
INNER JOIN
master.dbo.syslogins L
ON J.owner_sid = L.sid
ORDER BY 'Job_Name'