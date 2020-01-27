/********************************************************************************************
Author: JFS
Date: 2018-01-03

Description:
Drops and recreates unique index on business key column on dimension prep table if needed. Meaning if the unique 
index does not exists, or if it exists but with other column(s) than the business key. 

Parameters:
	@DimensionPrepTableSchema: The prep schema name of the dimensiontable on which the index should be created
	@DimensionTableName: The table name of the dimensiontable from which the list of attributes should be generated
*********************************************************************************************/
CREATE PROCEDURE [setup].[DimensionTablePrepUniqueIndex] (
	@DimensionPrepTableSchema NVARCHAR(128)
	, @DimensionTableName NVARCHAR(128)
)
AS
BEGIN
	-- Declare and setup variables
	DECLARE @NumberOfColumnsInIndex INT
	DECLARE @IndexCreateSQL NVARCHAR(MAX) = '
		DROP INDEX IF EXISTS [IX_DW_BK_Prep_' + @DimensionTableName + '] ON [' + @DimensionPrepTableSchema + '].[' + @DimensionTableName + '];

		CREATE UNIQUE NONCLUSTERED INDEX [IX_DW_BK_Prep_' + @DimensionTableName + '] 
		ON [' + @DimensionPrepTableSchema + '].[' + @DimensionTableName + '] (
			[DW_BK_' + @DimensionTableName + '] ASC
		);'

	-- Fetch number of columns in the unique index on the dimension prep table
	SET @NumberOfColumnsInIndex = (
		SELECT COUNT(*) AS NumOfColumns
		FROM sys.indexes I
			INNER JOIN sys.tables T
				ON T.object_id = I.object_id
			INNER JOIN sys.schemas S
				ON S.schema_id = T.schema_id
			INNER JOIN sys.index_columns IC
				ON (
					IC.index_id = I.index_id 
					AND IC.object_id = I.object_id
				)
			INNER JOIN sys.columns C
				ON (
					C.column_id = IC.column_id 
					AND C.object_id = IC.object_id
				)
			INNER JOIN sys.index_columns IC2	
				ON (
					IC2.object_id = I.object_id
					AND IC2.index_id = I.index_id
				)
		WHERE
			S.name = @DimensionPrepTableSchema
			AND T.name = @DimensionTableName
			AND C.name = 'DW_BK_' + @DimensionTableName
			AND I.name = 'IX_DW_BK_Prep_' + @DimensionTableName
			AND I.is_unique = 1
	)

	-- Create index if needed
	IF @NumberOfColumnsInIndex != 1 
		EXEC sp_executesql @IndexCreateSQL 
		
END