-- http://whoisactive.com/docs/09_deciding/

EXEC sp_WhoIsActive
    @filter_type = 'database',
    @filter = 'ODS_Serialization'