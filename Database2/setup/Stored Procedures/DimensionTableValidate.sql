/********************************************************************************************
Author: JFS
Date: 2017-11-30

Description:
Validates a dimension table based on the dimension stage table. If no dimension table exists it is created.
If dimension table exists it is synchronized with the stage table.

Also executes stp for creating unique index on business key in prep table if needed.

Parameters:
	@DimensionPrepTableSchema: The schema name of the stage table for the dimension table that is validated
	@DimensionSchemaName: The schema name of the dimension table that is validated
	@DimensionTableName: The table name of the dimension table that is validated

Dependencies:
	Procedure: setup.DimensionTableSynchronize
	Procedure: setup.DimensionTableCreate

	NOTE: Cross database joins to EDW_Utility database exists in dependencies!
*********************************************************************************************/
CREATE PROC [setup].[DimensionTableValidate] (
	@DimensionPrepTableSchema NVARCHAR(128)
	, @DimensionSchemaName NVARCHAR(128)
	, @DimensionTableName NVARCHAR(128)
	, @UseCase INT
)
AS 
BEGIN
	-- If dimension table exists => Synchronize
	IF OBJECT_ID(N'' + @DimensionSchemaName + '.' + @DimensionTableName + '', N'U') IS NOT NULL
		EXEC setup.DimensionTableSynchronize @DimensionPrepTableSchema, @DimensionSchemaName, @DimensionTableName
	-- If dimension table does not exist => Create table
	ELSE
		EXEC setup.DimensionTableCreate @DimensionPrepTableSchema, @DimensionSchemaName, @DimensionTableName
	
	-- Create unique index on prep table
	EXEC setup.DimensionTablePrepUniqueIndex @DimensionPrepTableSchema, @DimensionTableName

	-- Create merge index on edw table
	EXEC setup.DimensionTableIndex @DimensionSchemaName, @DimensionTableName, @UseCase
END