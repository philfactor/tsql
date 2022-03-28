There are other diagnostic tools you can access from SSMS like Activity Monitor and Performance Dashboard report (v17+). There is also sp_WhoIsActive tool you can run


GRANT VIEW SERVER STATE TO [GSM1900\Aurora_Support]
GRANT SHOWPLAN TO [GSM1900\Aurora_Support]

I’ve also granted execute permission on sp_WhoIsActive stored procedure to the above group.

The Performance Dashboard report is not just current snapshot, it collects information from history DMV’s and can be very useful for identifying tuning/optimization opportunities.

Performance Dashboard - SQL Server | Microsoft Docs
https://docs.microsoft.com/en-us/sql/relational-databases/performance/performance-dashboard?view=sql-server-ver15
How to collect performance and system information in SQL Server (sqlshack.com)
https://www.sqlshack.com/how-to-collect-performance-and-system-information-in-sql-server/
