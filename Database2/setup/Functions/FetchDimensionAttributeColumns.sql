/********************************************************************************************
Author: JFS
Date: 2017-11-30

Description:
Generates and returns a TABLE containing a list of attribute columns used in a certain 
dimension tables. Audit columns i omitted.

Parameters:
	@DimensionTableSchema: The schema name of the dimensiontable from which the list of attributes should be generated
	@DimensionTableName: The table name of the dimensiontable from which the list of attributes should be generated

Returns: TABLE

Dependencies: Function setup.FetchDimensionAuditColumns
NOTE: Hardcoded omitting [DimensionName_Key] and [DW_BK_DimensionName] columns.
*********************************************************************************************/
CREATE FUNCTION [setup].[FetchDimensionAttributeColumns] (
	@DimensionTableSchema NVARCHAR(128)
	, @DimensionTableName NVARCHAR(128)

)
RETURNS @AttributeColumns TABLE (
	RowNumber INT
	, columnname NVARCHAR(128)
	, typename NVARCHAR(128)
	, max_length INT
	, precision INT
	, scale INT
	, is_nullable INT
)
AS
BEGIN
	INSERT @AttributeColumns
	SELECT
		ROW_NUMBER() OVER (ORDER BY c.column_id) AS RowNumber
		, c.name AS columnname
		, tp.name AS typename
		, c.max_length
		, c.precision
		, c.scale
		, c.is_nullable
	FROM sys.tables t
		INNER JOIN sys.schemas s 
			ON s.schema_id = t.schema_id
		INNER JOIN sys.columns c
			ON c.object_id = t.object_id
		INNER JOIN sys.types tp
			ON tp.user_type_id = c.user_type_id
	WHERE
		s.name = @DimensionTableSchema
		AND t.name = @DimensionTableName
		AND c.name NOT IN (SELECT ColumnName FROM setup.FetchDimensionAuditColumns())
		AND c.name NOT IN (@DimensionTableName + '_Key', 'DW_BK_' + @DimensionTableName)
	
	RETURN 
END