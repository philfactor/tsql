DECLARE @tableHTML  NVARCHAR(MAX) ;  
  
SET @tableHTML =  
    N'<H1>Disk Space Report - P</H1>' +  
    N'<table border="1">' +  
    N'<tr><th>Drive</th><th>Free Space MB</th>' +  
    N'<th>Name</th><th>Size MB</th><th>Percent Free</th>' +  </tr>' +  
    CAST ( ( SELECT td = Drive,       '',  
                    td = FreeSpace, '',  
                    td = SizeMB, '',  
                    td = PercentFree, ''                     
              FROM DBA.dbo.DriveSpace                
              FOR XML PATH('tr'), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N'</table>' ;  
  
EXEC msdb.dbo.sp_send_dbmail @recipients='philip.streiff@sprint.com',  
    @subject = 'Work Order List',  
    @body = @tableHTML,  
    @body_format = 'HTML' ;  
	
	
	
****************UPDATED***********************

DECLARE @tableHTML  NVARCHAR(MAX) ;  
  
SET @tableHTML =  
    N'<H2>Drive Space Report - PLSWXA003</H2>' +  
    N'<table border="1">' +  
    N'<tr><th>Drive</th><th>Free Space MB</th>' +  
    N'<th>Total Size MB</th><th>Percent Free</th></tr>' +  
    CAST ( ( SELECT td = Drive,       '',
					[td/@align]='right',  
                    td = format([FreeSpace], 'N0'), '', 
					[td/@align]='right', 
                    td = format([SizeMB], 'N0'), '',
					[td/@align]='right',  
                    td = PercentFree, ''                     
              FROM DBA.dbo.DriveSpace
			  ORDER BY Drive                
              FOR XML PATH('tr'), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N'</table>' ;  
  
EXEC msdb.dbo.sp_send_dbmail @recipients='philip.streiff@sprint.com',  
    @subject = 'Drive Space Report - PLSWXA003',  
    @body = @tableHTML,  
    @body_format = 'HTML' ; 
	

2nd attempt errored:
Msg 14641, Level 16, State 1, Procedure msdb.dbo.sp_send_dbmail, Line 81 [Batch Start Line 0]
Mail not queued. Database Mail is stopped. Use sysmail_start_sp to start Database Mail.