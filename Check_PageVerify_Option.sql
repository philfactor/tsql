-- https://support.microsoft.com/en-us/help/2078345/-the-database-page-verify-checksum-option-can-help-detect-database-con
-- Get value of page verify option for all databases
SELECT name, page_verify_option_desc
FROM sys.databases
WHERE page_verify_option_desc <> 'CHECKSUM'