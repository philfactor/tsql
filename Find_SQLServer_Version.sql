-- http://technet.microsoft.com/en-us/library/ms174396(v=sql.100).aspx

-- SQL2008
SELECT SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')

-- SQL2005
SELECT  SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')

-- SQL2000
SELECT  SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')

select SERVERPROPERTY('','','','','','')