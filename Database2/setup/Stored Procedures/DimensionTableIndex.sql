/********************************************************************************************
Author: JFS
Date: 2018-02-11

Description:
Drops and recreates unique index on relevant merge columns on dimension table if it does not exists.

Parameters:
	@DimensionTableSchema: The schema name of the dimensiontable on which the index should be created
	@DimensionTableName: The table name of the dimensiontable from which the list of attributes should be generated
	@UseCase: The template use case; 1 = Truncate / load, 2 = Insert/update, 3 = SCD2
*********************************************************************************************/
CREATE PROCEDURE [setup].[DimensionTableIndex] (
	@DimensionTableSchema NVARCHAR(128)
	, @DimensionTableName NVARCHAR(128)
	, @UseCase INT
)
AS
BEGIN
	DECLARE @IndexExists BIT
	DECLARE @IndexCreateSQL NVARCHAR(MAX)

	-- Check if index exists
	SET @IndexExists = (
		SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS IndexExists
		FROM sys.indexes I
			INNER JOIN sys.tables T
				ON T.object_id = I.object_id
			INNER JOIN sys.schemas S
				ON S.schema_id = T.schema_id
		WHERE
			S.name = @DimensionTableSchema
			AND T.name = @DimensionTableName
			AND I.name = 'IX_DW_Merge_' + @DimensionTableName
	)

	-- Define index based on use case
	IF @UseCase = 2
		SET @IndexCreateSQL = '
			DROP INDEX IF EXISTS [IX_DW_Merge_' + @DimensionTableName + '] ON [' + @DimensionTableSchema + '].[' + @DimensionTableName + '];

			CREATE NONCLUSTERED INDEX [IX_DW_Merge_' + @DimensionTableName + '] 
			ON [' + @DimensionTableSchema + '].[' + @DimensionTableName + '] (
				[' + @DimensionTableName + '_Key] ASC
			)
			INCLUDE (
				[DW_Hash]
			);'
	IF @UseCase = 3
		SET @IndexCreateSQL = '
			DROP INDEX IF EXISTS [IX_DW_Merge_' + @DimensionTableName + '] ON [' + @DimensionTableSchema + '].[' + @DimensionTableName + '];

			CREATE NONCLUSTERED INDEX [IX_DW_Merge_' + @DimensionTableName + '] 
			ON [' + @DimensionTableSchema + '].[' + @DimensionTableName + '] (
				[DW_BK_' + @DimensionTableName + '] ASC
				, [DW_Hash] ASC
			);'

	IF @UseCase IN (2, 3) AND @IndexExists = 0 
		EXEC sp_executesql @IndexCreateSQL 
END