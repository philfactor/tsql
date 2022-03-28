-- From Juliano Montiero, 01/28/2020

--To disable the monitoring:
EXEC sp_instc_mon_set @instc_name = 'PVMXC679\MS2008_PROD', @enabled = 0, @time = 0

--To remove from SQLMonitor:
EXEC sp_del_object @instc_name = 'PVMXC679\MS2008_PROD'
