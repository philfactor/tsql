-- http://www.techbrothersit.com/2017/01/how-to-generate-script-to-refresh-all.html
-- 08/23/2021

SELECT 'sp_refreshview  ''' 
       + Schema_name(schema_id) + '.' + NAME + '''' 
       + Char(13) + Char(10) + ' GO' AS RefreshViewQuery 
FROM   sys.views 