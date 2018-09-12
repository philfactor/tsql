/****************************************************************************************
* Object Name:	Find_Tempdb_SpaceUsed.sql
* Object Type:	External DMV script
* Author:	Phil Streiff, MCDBA
* Date:		02/16/2008
* Source:	http://www.microsoft.com/technet/prodtechnol/sql/2005/tsprfprb.mspx#EBD
****************************************************************************************/

SELECT 
    SUM (user_object_reserved_page_count)*8 as user_objects_kb, 
    SUM (internal_object_reserved_page_count)*8 as internal_objects_kb, 
    SUM (version_store_reserved_page_count)*8  as version_store_kb, 
    SUM (unallocated_extent_page_count)*8 as freespace_kb 
FROM 
	sys.dm_db_file_space_usage 
WHERE 
	database_id = 2

