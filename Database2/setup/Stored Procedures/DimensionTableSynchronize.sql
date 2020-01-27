/********************************************************************************************
Author: JFS
Date: 2017-11-30

Description:
Synchronized a dimension table with the dimension stage table. Meaning:
	- New columns are added
	- Deleted columns are dropped
	- Modified columns are altered
A change in column names in stage table will lead to the column being deleted and added as a new one
in the dimension table!

Columns that are changed so they now have a smaller max_lengt, precision or scale are changed acordingly so.
No check on wether this will load to truncation.

Parameters:
	@DimensionPrepTableSchema: The schema name of the stage table for the dimension table that is synchronized
	@DimensionSchemaName: The schema name of the dimension table that is synchronized
	@DimensionTableName: The table name of the dimension table that is synchronized

Dependencies:
	Function: setup.FetchDimensionAttributeColumns
	Function: setup.GenerateColumnSQL

	NOTE: Cross database joins to EDW_Utility database exists in dependencies!
*********************************************************************************************/
CREATE PROC [setup].[DimensionTableSynchronize] (
	@DimensionPrepTableSchema NVARCHAR(128)
	, @DimensionSchemaName NVARCHAR(128)
	, @DimensionTableName NVARCHAR(128)
)
AS
BEGIN
	-- Declare variables
	DECLARE @i INT = 1
	DECLARE @StrSQL NVARCHAR(MAX)
	DECLARE @RowNumber INT
	DECLARE @ColumnName NVARCHAR(128)
	DECLARE @DataType NVARCHAR(128)
	DECLARE @MaxLenght INT
	DECLARE @Precision INT
	DECLARE @Scale INT
	DECLARE @Operation NVARCHAR(128)

	-- Create local temporary table containing all columns from stage and dimension table
	-- Also define if columns should be added, dropped or altered
	SELECT
		ISNULL(STG.columnname, DIM.columnname) AS columnname
		, STG.typename
		, STG.max_length
		, STG.precision
		, STG.scale
		, CASE
			WHEN STG.columnname IS NULL THEN 'DROP'
			WHEN DIM.columnname IS NULL THEN 'ADD'
			WHEN STG.typename != DIM.typename OR STG.max_length != DIM.max_length OR STG.precision != DIM.precision OR STG.scale != DIM.scale THEN 'ALTER'
		END AS operation
	INTO #ColumAttributes
	FROM setup.FetchDimensionAttributeColumns(@DimensionPrepTableSchema, @DimensionTableName) STG
		FULL OUTER JOIN setup.FetchDimensionAttributeColumns(@DimensionSchemaName, @DimensionTableName) DIM
			ON STG.columnname = DIM.columnname

	-- Only select the columns that require to be added, deleted, or changed
	-- Store in new temporary table
	SELECT 
		ROW_NUMBER() OVER (ORDER BY columnname) AS RowNumber 
		, columnname
		, typename
		, max_length
		, precision
		, scale
		, operation
	INTO #ColumnAttributesChanged
	FROM #ColumAttributes 
	WHERE operation IS NOT NULL

	-- Loop through each column that needs to be processed.
	WHILE @i <= (SELECT COUNT(*) FROM #ColumnAttributesChanged)
	BEGIN
		SELECT @ColumnName = columnname, @DataType = typename, @MaxLenght = max_length, @Precision = precision, @Scale = scale, @Operation = operation
		FROM #ColumnAttributesChanged
		WHERE @i = RowNumber
		
		-- Process column acording to change needed
		IF @Operation = 'ADD' 
			SET @StrSQL = '
				ALTER TABLE [' + @DimensionSchemaName + '].[' + @DimensionTableName + ']
				ADD ' + setup.GenerateColumnSQL(@ColumnName, @DataType, @MaxLenght, @Precision, @Scale)
		ELSE IF @Operation = 'DROP'
			SET @StrSQL = '
				ALTER TABLE [' + @DimensionSchemaName + '].[' + @DimensionTableName + ']
				DROP COLUMN [' + @ColumnName + ']'
		ELSE IF @Operation = 'ALTER'
			SET @StrSQL = '
				ALTER TABLE [' + @DimensionSchemaName + '].[' + @DimensionTableName + ']
				ALTER COLUMN ' + setup.GenerateColumnSQL(@ColumnName, @DataType, @MaxLenght, @Precision, @Scale)

		-- Execute processing of column
		EXEC sp_executesql @StrSQL

		SET @i = @i + 1
	END
END