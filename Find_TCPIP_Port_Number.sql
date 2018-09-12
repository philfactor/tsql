DECLARE @test varchar(15),@value_name varchar(15),@RegistryPath varchar(200)

IF (charindex('\',@@SERVERNAME)<>0) -- Named Instance
BEGIN
 SET @RegistryPath = 'SOFTWARE\Microsoft\Microsoft SQL Server\' + RIGHT(@@SERVERNAME,LEN(@@SERVERNAME)-CHARINDEX('\',@@SERVERNAME)) + '\MSSQLServer\SuperSocketNetLib\Tcp'
END
ELSE -- Default Instance 
BEGIN
  SET @RegistryPath = 'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer\SuperSocketNetLib\Tcp'
END

EXEC master..xp_regread @rootkey='HKEY_LOCAL_MACHINE' ,@key=@RegistryPath,@value_name='TcpPort',@value=@test OUTPUT

Print 'The Port Number is '+ char(13)+ @test  

