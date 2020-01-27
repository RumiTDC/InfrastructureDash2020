/********************************************************************************************
Author: JFS
Date: 2017-11-30

Description:
Generates and returns a TABLE containing a list of audit columns used in dimension tables.
The list is generated from the EDW_Utility table meta.DWDimensionColumn

Returns: TABLE

NOTE: Cross database joins to EDW_Utility exists
*********************************************************************************************/
CREATE FUNCTION [setup].[FetchDimensionAuditColumns] ()
RETURNS @AuditColumns TABLE (
	RowNumber INT
	, ColumnName NVARCHAR(128)
	, DataType NVARCHAR(128)
	, DefaultValue NVARCHAR(128)
)
AS
BEGIN
	-- Fetch audit columns
	INSERT @AuditColumns 
		SELECT
			ROW_NUMBER() OVER (ORDER BY SortOrder) AS RowNumber
			, ColumnName
			, DataType
			, DefaultValue
		FROM EDW_Utility.meta.DWDimensionColumn
	
	RETURN 
END