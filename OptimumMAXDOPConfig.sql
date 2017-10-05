-- from Denzil Ribeiro 2013
-- https://support.microsoft.com/en-us/kb/2806535

DECLARE
   @NumNumaNodes int , 
   @sockets int , 
   @logical_cpus int;
DECLARE
   @recommendedmaxdop int , 
   @CoresOrHyperthreadedCPU int;
SELECT @NumNumaNodes = COUNT( *
                            )
  FROM sys.dm_os_memory_nodes
  WHERE memory_node_id
        <> 
        64;
SELECT @sockets = cpu_count / hyperthread_ratio ,
	   @logical_cpus = cpu_count , 
       @CoresOrHyperthreadedCPU = hyperthread_ratio ,
       @recommendedMaxdop = cpu_count / @NumNumaNodes
  FROM sys.dm_os_sys_info;
IF @recommendedmaxdop
   > 
   8
    BEGIN
        SET @recommendedmaxdop = 8
    END;
SELECT @sockets AS Sockets ,
	   @logical_cpus AS LogicalCPUS ,
	   @CoresOrHyperthreadedCPU AS CoresOrHyperthreadedCPU , 
       @recommendedmaxdop AS RecommendedMaxdop;
