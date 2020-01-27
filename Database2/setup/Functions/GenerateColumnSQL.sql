/********************************************************************************************
Author: JFS
Date: 2017-11-30

Description:
Generates a string (a bit of SQL) that can be used for creating or altering columns in a table.
Eg.: 'ColumnName nvarchar(20)' or 'ColumnName decimal(18,0)'

Parameters:
	@ColumnName: The name of the column e.g. 'CustomerNo'
	@DataType: The datatype of the column e.g. 'decimal'
	@MaxLenght: The maximum lenght of the column (of text) e.g. 50
	@Precision: The precision of the column (if eg. decimal) e.g. 18
	@Scale: The scale of the column (if eg. decimal) e.g. 6

Returns: NVARCHAR(MAX)
*********************************************************************************************/
CREATE FUNCTION [setup].[GenerateColumnSQL] (
	@ColumnName NVARCHAR(128)
	, @DataType NVARCHAR(128)
	, @MaxLenght INT
	, @Precision INT
	, @Scale INT
)
RETURNS NVARCHAR(MAX)
AS

BEGIN
	DECLARE @ReturnValue NVARCHAR(MAX)
	SET @ReturnValue = '[' + @ColumnName + '] '
	
	IF @DataType IN ('nvarchar', 'nchar')
		SET @ReturnValue = @ReturnValue + @DataType + '(' + CASE @MaxLenght WHEN -1 THEN 'MAX' ELSE CAST(@MaxLenght / 2 AS NVARCHAR(50)) END + ')'
	ELSE IF @DataType IN ('nvarchar', 'varchar', 'nchar', 'char', 'binary', 'varbinary')
		SET @ReturnValue = @ReturnValue + @DataType + '(' + CASE @MaxLenght WHEN -1 THEN 'MAX' ELSE CAST(@MaxLenght AS NVARCHAR(50)) END + ')'
	ELSE IF @DataType IN ('numeric', 'decimal')
		SET @ReturnValue = @ReturnValue + @DataType + '(' + CAST(@Precision AS NVARCHAR(50)) + ', ' + CAST(@Scale AS NVARCHAR(50)) + ')'
	ELSE IF @DataType IN ('datetime2', 'time', 'datetimeoffset')
		SET @ReturnValue = @ReturnValue + @DataType + '(' + CAST(@Precision AS NVARCHAR(50)) + ')'
	ELSE 
		SET @ReturnValue = @ReturnValue + @DataType

	RETURN @ReturnValue
END