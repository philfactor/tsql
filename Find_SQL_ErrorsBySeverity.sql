/******************************************
* Name: Find_SQL_ErrorsBySeverity.sql
* Date: 09/09/2016
* Author: Phil Streiff
* Purpose: Find SQL error messages by severity number
*
*******************************************/

SELECT
    message_id,
    language_id,
    severity,
    is_event_logged,
    text
  FROM sys.messages
  WHERE language_id = 1033 AND severity = '17';