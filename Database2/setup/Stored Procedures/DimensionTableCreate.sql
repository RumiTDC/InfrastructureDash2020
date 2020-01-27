/********************************************************************************************
Author: JFS
Date: 2017-11-30

Description:
Creates a dimension table based on the attributes in the stage table, and the audit columns
defined in EDW_Utility.meta.DWDimensionColumn.

Parameters:
	@DimensionPrepTableSchema: The schema name of the stage table for the dimension table that is created
	@DimensionSchemaName: The schema name of the dimension table that is created
	@DimensionTableName: The table name of the dimension table that is created

Dependencies:
	Function: setup.FetchDimensionAttributeColumns
	Function: setup.FetchDimensionAuditColumns
	Function: setup.GenerateColumnSQL

	NOTE: Cross database joins to EDW_Utility database exists in dependencies!
*********************************************************************************************/
CREATE PROC [setup].[DimensionTableCreate]
	@DimensionPrepTableSchema NVARCHAR(128)
	, @DimensionSchemaName NVARCHAR(128)
	, @DimensionTableName NVARCHAR(128)
AS
BEGIN
	-- Declare variables
	DECLARE @StrSQL NVARCHAR(MAX)
	DECLARE @SurrogateKey NVARCHAR(MAX)
	DECLARE @AuditColumnList NVARCHAR(MAX) = ''
	DECLARE @AttributeColumnList NVARCHAR(MAX) = ''
	DECLARE @i INT = 1
	DECLARE @NumOfColumns INT
	DECLARE @ColumnName NVARCHAR(128)
	DECLARE @DataType NVARCHAR(128)
	DECLARE @DefaultValue NVARCHAR(128)
	DECLARE @MaxLenght INT
	DECLARE @Precision INT
	DECLARE @Scale INT
	DECLARE @IsNullable INT 

	-- Count the number of audit columns needed in the table
	SET @NumOfColumns = (SELECT COUNT(*) FROM setup.FetchDimensionAuditColumns())

	-- Loop through each audit column, and generate a SQL string that will hold a comma separated list
	-- of the audit columns and their data type, used for table creation.
	WHILE @i <= @NumOfColumns
	BEGIN
		SELECT @ColumnName = ColumnName, @DataType = DataType, @DefaultValue = DefaultValue FROM setup.FetchDimensionAuditColumns() WHERE RowNumber = @i

		SET @AuditColumnList = @AuditColumnList + ', ' + @ColumnName + ' ' + @DataType + CASE WHEN @DefaultValue IS NOT NULL THEN ' DEFAULT ' + @DefaultValue ELSE '' END
		SET @i = @i + 1
	END

	-- Count the numbers of attribute columns in the table
	SET @i = 1
	SET @NumOfColumns = (SELECT COUNT(*) FROM setup.FetchDimensionAttributeColumns(@DimensionPrepTableSchema, @DimensionTableName))

	-- Loop through each attribute column, and generate a SQL string that will hold a comma separated list
	-- of the attribute columns and their data type, used for table creation.
	WHILE @i <= @NumOfColumns
	BEGIN
		SELECT 
			@ColumnName = columnname 
			, @DataType = typename
			, @MaxLenght = max_length
			, @Precision = precision
			, @Scale = scale
			, @IsNullable = is_nullable
		FROM setup.FetchDimensionAttributeColumns(@DimensionPrepTableSchema, @DimensionTableName) WHERE RowNumber = @i

		SET @AttributeColumnList = @AttributeColumnList + ', ' + setup.GenerateColumnSQL(@ColumnName, @DataType, @MaxLenght, @Precision, @Scale)
		SET @i = @i + 1
	END

	-- Put together final SQL string that is executed to create the table
	SET @StrSQL = '
		CREATE TABLE [' + @DimensionSchemaName + '].[' + @DimensionTableName + '] (
			[' + @DimensionTableName + '_Key] BIGINT NOT NULL
			, [DW_BK_' + @DimensionTableName + '] NVARCHAR(400) NOT NULL
			' + @AuditColumnList + '
			' + @AttributeColumnList + '
			, CONSTRAINT [IX_PK_' + @DimensionTableName + '] PRIMARY KEY CLUSTERED (
				[' + @DimensionTableName + '_Key] ASC
			)
		)'

	-- Create table
	EXEC sp_executesql @StrSQL
	PRINT 'Dimension table [' + @DimensionSchemaName + '].[' + @DimensionTableName + '] created'
END