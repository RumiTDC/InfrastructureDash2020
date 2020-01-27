/********************************************************************************************
Author: JFS
Date: 2017-11-30

Description:
Loads data from the dimension stage table and to the actual dimension table. Also generates a 
DW_Hash and maintain dimension audit columns.
	- If truncate/load: Dimension members are INSERTED into the dimension table
	- If Type 1 SCD: Dimension members are MERGED into the dimension table
	- If Type 2 SCD: Dimension members are INSERTED into the dimension table 
		AND old members are UPDATED (closed)

Regarding the merge statement:
Merging is done on the DW_Hash which is generated on the fly on rows in the dimension stage table.
Hashing is done by using the HASHBYTES function and SHA_512 algorithm and is performed on an 
XML string (also generated on the fly) containing all dimension attribute column names and their content.

Parameters:
	@DimensionPrepTableSchema: The schema name of the stage table for the dimension table that is created
	@DimensionSchemaName: The schema name of the dimension table that is created
	@DimensionTableName: The table name of the dimension table that is created
	@LogDetailID: The LogDetailID of the SSIS Package that calls the procedure
	@UseCase: The template type of the SSIS package
		1 = Truncate/load
		2 = Type 1 SCD
		3 = Type 2 SCD on all attribute columns

Dependencies:
	Function: setup.GenerateColumnList

NOTE: Cross database joins to EDW_Utility database exists!
*********************************************************************************************/
CREATE PROCEDURE [setup].[DimensionLoad] (
	@DimensionPrepTableSchema NVARCHAR(128)
	, @DimensionSchemaName NVARCHAR(128)
	, @DimensionTableName NVARCHAR(128)
	, @LogDetailID INT
	, @UseCase INT
)
AS

-- Declare and set up variables
DECLARE @ExecuteSQL AS NVARCHAR(MAX)
DECLARE @ColumnList AS NVARCHAR(MAX)
DECLARE @LogDetailIDStartDate DATETIME2(7)

SET @LogDetailIDStartDate = (SELECT StartDate FROM EDW_Utility.log.LogDetail WHERE LogDetailID = @LogDetailID)



/*
UseCase = 1: TRUNCATE LOAD
*/
IF @UseCase = 1
BEGIN
	-- Define SQL for insertion into the dimension table
	-- Hashing using the NON DOCUMENTED master.sys.fn_repl_hash_binary function commented out.
	-- This function hashes using MD5 on a binary - NOT USED
	SET @ExecuteSQL = '
			INSERT INTO [' + @DimensionSchemaName + '].[' + @DimensionTableName + '] (
				[' + @DimensionTableName + '_Key]
				, [DW_BK_' + @DimensionTableName + ']
				, DW_ValidDateTimeFrom
				, DW_ValidDateTimeTo
				, DW_Hash
				, DW_LogDetailID_Insert
				-- ## LIST OF DIMENSION ATTRIBUTES GOES HERE ## --
				' + ISNULL(setup.GenerateColumnList(@DimensionSchemaName, @DimensionTableName, 1), '') + '
			)  
			SELECT 
				[' + @DimensionTableName + '_Key]
				, [DW_BK_' + @DimensionTableName + ']
				, ''1900-01-01 00:00:00.0000000''
				, ''9999-12-31 00:00:00.0000000''
				-- ## GENERATE DW HASH ## --
				, DW_Hash = 
						HASHBYTES(
							''SHA2_512''
							, (
								SELECT C.* 
								FROM (VALUES(NULL))foo(BAR) FOR XML AUTO
							)
					)
					--master.sys.fn_repl_hash_binary (
					--	CAST(
					--		(
					--			SELECT C.* 
					--			FROM (VALUES(NULL))foo(BAR) FOR XML AUTO
					--		) AS VARBINARY(MAX)
					--	)
					--)
				, ' + CAST(@LogDetailID AS NVARCHAR(50)) + '
				-- ## LIST OF DIMENSION ATTRIBUTES GOES HERE ## --
				' + ISNULL(setup.GenerateColumnList(@DimensionSchemaName, @DimensionTableName, 1), '') + '
			FROM [' + @DimensionPrepTableSchema + '].[' + @DimensionTableName + '] C;'

	EXEC sp_executesql @ExecuteSQL;
END
/*
@UseCase = 2: INSERT / UPDATE (Type 1 SCD)
*/
ELSE IF @UseCase = 2
BEGIN
	SET @ExecuteSQL = '
		MERGE [' + @DimensionSchemaName + '].[' + @DimensionTableName + '] AS TGT  
			USING (
				SELECT 
					[' + @DimensionTableName + '_Key]
					, [DW_BK_' + @DimensionTableName + ']
					-- ## GENERATE DW HASH ## --
					, DW_Hash = 
						HASHBYTES(
							''SHA2_512''
							, (
								SELECT C.* 
								FROM (VALUES(NULL))foo(BAR) FOR XML AUTO
							)
					)
					-- ## LIST OF DIMENSION ATTRIBUTES GOES HERE ## --
					' + ISNULL(setup.GenerateColumnList(@DimensionSchemaName, @DimensionTableName, 1), '') + '
				FROM [' + @DimensionPrepTableSchema + '].[' + @DimensionTableName + '] C
			) AS SRC
			ON TGT.[' + @DimensionTableName + '_Key] = SRC.[' + @DimensionTableName + '_Key] 
			-- ## WHEN MATCH ON BUSINESS KEY AND DW HASHES DIFFERS - UPDATE VALUES ## --
			WHEN MATCHED AND (TGT.DW_Hash != SRC.DW_Hash OR TGT.DW_Hash IS NULL) THEN   
				UPDATE SET 
					TGT.DW_Hash = SRC.DW_Hash
					, TGT.DW_DateModified = SYSDATETIME()
					, TGT.DW_LogDetailID_Update = ' + CAST(@LogDetailID AS NVARCHAR(50)) + '
					' + ISNULL(setup.GenerateColumnList(@DimensionSchemaName, @DimensionTableName, 3), '') + '
		-- ## WHEN NO MATCH - INSERT NEW MEMBER ## --
		WHEN NOT MATCHED THEN  
			INSERT (
				[' + @DimensionTableName + '_Key]
				, [DW_BK_' + @DimensionTableName + ']
				, DW_ValidDateTimeFrom
				, DW_ValidDateTimeTo
				, DW_Hash
				, DW_LogDetailID_Insert
				' + ISNULL(setup.GenerateColumnList(@DimensionSchemaName, @DimensionTableName, 1), '') + '
			)  
			VALUES (
				SRC.[' + @DimensionTableName + '_Key]
				, SRC.[DW_BK_' + @DimensionTableName + ']
				, ''1900-01-01 00:00:00.0000000''
				, ''9999-12-31 00:00:00.0000000''
				, SRC.DW_Hash
				, ' + CAST(@LogDetailID AS NVARCHAR(50)) + '
				' + ISNULL(setup.GenerateColumnList(@DimensionSchemaName, @DimensionTableName, 2), '') + '
			);'

	EXEC sp_executesql @ExecuteSQL;
END
/*
@UseCase = 3: SCD Type 2
*/
ELSE IF @UseCase = 3
BEGIN
	-- Insert new or changed rows
	SET @ExecuteSQL = '
		INSERT INTO [' + @DimensionSchemaName + '].[' + @DimensionTableName + '] (
			[' + @DimensionTableName + '_Key]
			, [DW_BK_' + @DimensionTableName + ']
			, DW_ValidDateTimeFrom
			, DW_ValidDateTimeTo
			, DW_Hash
			, DW_LogDetailID_Insert
			-- ## LIST OF DIMENSION ATTRIBUTES GOES HERE ## --
			' + ISNULL(setup.GenerateColumnList(@DimensionSchemaName, @DimensionTableName, 1), '') + '
		)  
		SELECT
			-- ## GENERATE SURROGATE KEY ## --
			(NEXT VALUE FOR EDW_Utility.dimkey.DimensionKeySequence)
			, SRC.[DW_BK_' + @DimensionTableName + ']
			, ''' + CAST(@LogDetailIDStartDate AS NVARCHAR(28)) + '''
			, ''9999-12-31 00:00:00.0000000''
			-- ## GENERATE DW HASH ## --
			, HASHBYTES(
					''SHA2_512''
					, (
						SELECT SRC.* 
						FROM (VALUES(NULL))foo(BAR) FOR XML AUTO
					)
			)
			, ' + CAST(@LogDetailID AS NVARCHAR(50)) + '
			-- ## LIST OF DIMENSION ATTRIBUTES GOES HERE ## --
			' + ISNULL(setup.GenerateColumnList(@DimensionSchemaName, @DimensionTableName, 2), '') + '
		FROM [' + @DimensionPrepTableSchema + '].[' + @DimensionTableName + '] SRC
			-- ## DO A FULL OUTER JOIN IN ORDER TO CATCH DELETED ROWS AS WELL ## --
			FULL OUTER JOIN [' + @DimensionSchemaName + '].[' + @DimensionTableName + '] TGT
				ON (
					TGT.[DW_BK_' + @DimensionTableName + '] = SRC.[DW_BK_' + @DimensionTableName + ']
					-- ## NEED HASHING IN THE INNER QUERY THAT DETECTS DELETES AS WELL ## --
					AND TGT.DW_Hash = HASHBYTES(
							''SHA2_512''
							, (
								SELECT SRC.* 
								FROM (VALUES(NULL))foo(BAR) FOR XML AUTO
							)
						)
					)
					AND TGT.DW_ValidDateTimeTo = ''9999-12-31 00:00:00.0000000''
		WHERE
			TGT.[' + @DimensionTableName + '_Key] IS NULL'

	EXEC sp_executesql @ExecuteSQL
	-- PRINT @ExecuteSQL

	-- Close old rows
	SET @ExecuteSQL = '
		UPDATE [' + @DimensionSchemaName + '].[' + @DimensionTableName + ']
		SET
			DW_ValidDateTimeTo = ''' + CAST(DATEADD(ns, -100, CAST(@LogDetailIDStartDate AS DATETIME2(7))) AS NVARCHAR(28)) + '''
			, DW_DateModified = SYSDATETIME()
			, DW_LogDetailID_Update = ' + CAST(@LogDetailID AS NVARCHAR(50)) + '
		WHERE
			DW_LogDetailID_Insert < ' + CAST(@LogDetailID AS NVARCHAR(50)) + '
			AND DW_ValidDateTimeTo = ''9999-12-31 00:00:00.0000000''
			AND (
				-- ## MEMBERS THAT ARE DELETED ## --
				[DW_BK_' + @DimensionTableName + '] NOT IN (
					SELECT [DW_BK_' + @DimensionTableName + '] FROM [' + @DimensionPrepTableSchema + '].[' + @DimensionTableName + ']
				)
				-- ## MEMBERS THAT ARE UPDATED ## --
				OR [DW_BK_' + @DimensionTableName + '] IN (
					SELECT [DW_BK_' + @DimensionTableName + '] FROM [' + @DimensionSchemaName + '].[' + @DimensionTableName + ']
					WHERE DW_LogDetailID_Insert = ' + CAST(@LogDetailID AS NVARCHAR(50)) + '
				)
			)';
	
	EXEC sp_executesql @ExecuteSQL;
END