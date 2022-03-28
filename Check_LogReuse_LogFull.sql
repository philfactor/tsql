

DECLARE @DatabaseName VARCHAR(50);
 SET @DatabaseName = 'SSTATSA'
 SELECT name, recovery_model_desc, log_reuse_wait_desc
   FROM sys.databases
   WHERE name = @DatabaseName