-- https://social.msdn.microsoft.com/Forums/sqlserver/en-US/31c3643f-c79b-41a3-b12a-1825a6575ef7/checking-if-xpcmdshell-is-enabled-or-not?forum=transactsql

SELECT CONVERT(INT, ISNULL(value, value_in_use)) AS config_value
FROM  sys.configurations
WHERE  name = 'xp_cmdshell' ;