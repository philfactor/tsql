/******************************************************************************
* Object Name:	Find_NumRows_In_a_Table.sql
* Object Type:	External DDL Script
* Author:		Phil Streiff, MCDBA
* Date:			11/11/07
* Purpose:		Find number of rows in a table.
*				Faster alternative to select count(*) from table_name.
******************************************************************************/

SELECT OBJECT_NAME(object_id) TableName, 

SUM(Rows) NoOfRows --total up if there is a partition

FROM sys.partitions 

WHERE index_id < 2 --ignore the partitions from the non-clustered index if any

--AND OBJECT_NAME(object_id) IN (<TABLENAME>) --Restrict the Table Names

GROUP BY object_id

ORDER BY NoOfRows