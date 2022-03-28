

-- http://www.graytechnology.com/Blog/post.aspx?id=e21cbab0-8ae2-478e-a027-1b3b14e7d0b9

SELECT 'drop statistics [' + object_name(i.[object_id]) + '].['+ i.[name] + ']'
FROM sys.stats as i
WHERE OBJECTPROPERTY(i.[object_id],'IsUserTable') = 1 AND i.[name] LIKE '_dta%'
ORDER BY i.name 
 
--If you receive the below error change the script to drop index: 

--Msg 3739, Level 11, State 1, Line 1 

--Cannot DROP the index  because it is not a statistics collection.  
