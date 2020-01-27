
/*
2017-02-08: JFS

Merge_Control stp validates a given stage table against the corresponding history table.
It returns meaningful error messages when meta data between the tables is out of syncronization.

The following error messages are supported:

	- History destination database equals stage database and no prefix has been defined for the history table schema.
	- The stage table has no primary key
	- A column in the stage table does not exist in the history table
	- A column in the history table does not exist in the stage table
	- The column meta data between the tables are out of synchonization
	- The stage table contains a column of the data type "timestamp" - this is not supported
*/
CREATE PROCEDURE [dbo].[Merge_Control]
	@TableName AS VARCHAR(128)
	, @Schema AS VARCHAR(128)
	, @DestinationDatabase AS VARCHAR(128)
	, @HistoryPrefix_Enabled INT
	, @ErrorInt INT OUTPUT
	, @ErrorMessage VARCHAR(4000) OUTPUT 
AS
DECLARE @TmpNameDestinationColumns NVARCHAR(128)
DECLARE @ErrorFromDynSQL INT
DECLARE @StrSQL NVARCHAR(MAX)

SET @TmpNameDestinationColumns = '[##' + @Schema + '_' + @TableName + ']'

/* Drop temporary table if exists (if it has not been cleaned up since last run) */
IF EXISTS (
	SELECT * 
	FROM tempdb.sys.objects
	WHERE 
		type = 'U'
		AND name = '##' + @Schema + '_' + @TableName + ''
)
BEGIN
	SET @StrSQL = 'DROP TABLE ' + @TmpNameDestinationColumns
	EXEC sp_executesql @StrSQL
END

/* Create a temporary table to hold the column meta data for the stage table */
SET @StrSQL = '
	SELECT * INTO ' + @TmpNameDestinationColumns + ' 
	FROM [' + @DestinationDatabase + '].[INFORMATION_SCHEMA].[COLUMNS] b
	WHERE 
		TABLE_SCHEMA = '+ CASE WHEN @HistoryPrefix_Enabled = 1 THEN '''history_' + @Schema + '''' ELSE '''' + @Schema + '''' END + '
		AND TABLE_NAME = ''' + @TableName + '''
		AND COLUMN_NAME NOT IN (
			''HistoryLogID''
			, ''HistoryValidDateTimeFrom''
			, ''HistoryValidDateTimeTo''
			, ''HistoryModifiedLogID''
			, ''HistoryModifiedDate''
			, ''HistoryCurrentRec''
			, ''HistoryDeletedAtSource''
		)'

EXEC(@StrSQL)

SET @ErrorInt = 0

IF @DestinationDatabase = (SELECT DB_NAME()) AND @HistoryPrefix_Enabled = 0
BEGIN
	SET @ErrorInt = 1
	SET @ErrorMessage = 'RETURNCODE = 1: The variable @DestinationDatabase equals Stage DB and the variable @HistoryPrefix_Enabled is not enabled (value 1). Either alter @DestinationDatabase to use another DB or set the variable @HistoryPrefix_Enabled = 1'
	SET @StrSQL = 'DROP TABLE ' + @TmpNameDestinationColumns
	EXEC sp_executesql @StrSQL
	RETURN(1)
END

IF NOT EXISTS (
	SELECT * 
	FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS]
	WHERE
		CONSTRAINT_TYPE = 'PRIMARY KEY'
		AND [TABLE_SCHEMA] = @Schema 
		AND [TABLE_NAME] = @TableName 
)
BEGIN
	SET @ErrorInt = 1
	SET @ErrorMessage = 'RETURNCODE = 2: There is no primary key on the stage table.'
	SET @StrSQL = 'DROP TABLE ' + @TmpNameDestinationColumns
	EXEC sp_executesql @StrSQL
	RETURN(2)
END

/* Check if columns in the stage table does not exist in the history table */
SET @ErrorFromDynSQL = 0
SET @StrSQL = '
	IF EXISTS (
		SELECT COLUMN_NAME
		FROM [INFORMATION_SCHEMA].[COLUMNS] a
		WHERE 
			TABLE_SCHEMA = ''' + @Schema + '''
			AND TABLE_NAME = ''' + @TableName + '''
			AND COLUMN_NAME NOT IN (
				SELECT COLUMN_NAME FROM ' + @TmpNameDestinationColumns + '
			)
	)
	AND 1 <= (SELECT COUNT(*) FROM ' + @TmpNameDestinationColumns + ')
	SET @Error = 1'

EXEC sp_executesql @StrSQL, N'@Error INT OUTPUT', @Error = @ErrorFromDynSQL OUTPUT

IF @ErrorFromDynSQL = 1
	BEGIN
		SET @ErrorInt = 1
		SET @ErrorMessage = 'RETURNCODE = 3: A column exist in the stage table that is not present in the history table.'
		SET @StrSQL = 'DROP TABLE ' + @TmpNameDestinationColumns
		EXEC sp_executesql @StrSQL
		RETURN(3)
	END

/* Check if columns in the history table does not exist in the stage table */
SET @ErrorFromDynSQL = 0
SET @StrSQL = '
	IF EXISTS (
	SELECT COLUMN_NAME FROM ' + @TmpNameDestinationColumns + '
	WHERE 
		COLUMN_NAME NOT IN (
			SELECT COLUMN_NAME
			FROM [INFORMATION_SCHEMA].[COLUMNS] b
			WHERE
				TABLE_SCHEMA = ''' + @Schema + '''
				AND TABLE_NAME = ''' + @TableName + '''
		)
	)
	SET @Error = 1'

EXEC sp_executesql @StrSQL, N'@Error INT OUTPUT', @Error = @ErrorFromDynSQL OUTPUT

IF @ErrorFromDynSQL = 1
	BEGIN
		SET @ErrorInt = 1
		SET @ErrorMessage = 'RETURNCODE = 4: A column exist in the history table that is not present in the stage table.'
		SET @StrSQL = 'DROP TABLE ' + @TmpNameDestinationColumns
		EXEC sp_executesql @StrSQL
		RETURN(4)
	END

/* Check if column meta data between the two tables is out of synconization */
SET @ErrorFromDynSQL = 0
SET @StrSQL = '
IF EXISTS (
	SELECT * 
	FROM ' + @TmpNameDestinationColumns + ' a
	WHERE
		NOT EXISTS (
			SELECT *
			FROM [INFORMATION_SCHEMA].[COLUMNS] b
			WHERE 
				TABLE_SCHEMA = ''' + @Schema + '''
				AND TABLE_NAME = ''' + @TableName + '''
				AND a.TABLE_NAME = b.TABLE_NAME 
				AND a.COLUMN_NAME = b.COLUMN_NAME 
				AND a.IS_NULLABLE = b.IS_NULLABLE
				AND a.DATA_TYPE = b.DATA_TYPE
				AND EXISTS (SELECT a.CHARACTER_MAXIMUM_LENGTH INTERSECT SELECT b.CHARACTER_MAXIMUM_LENGTH )
				AND EXISTS (SELECT a.CHARACTER_OCTET_LENGTH INTERSECT SELECT b.CHARACTER_OCTET_LENGTH )
				AND EXISTS (SELECT a.NUMERIC_PRECISION INTERSECT SELECT b.NUMERIC_PRECISION )
				AND EXISTS (SELECT a.NUMERIC_PRECISION_RADIX INTERSECT SELECT b.NUMERIC_PRECISION_RADIX )
				AND EXISTS (SELECT a.NUMERIC_SCALE INTERSECT SELECT b.NUMERIC_SCALE )
				AND EXISTS (SELECT a.DATETIME_PRECISION INTERSECT SELECT b.DATETIME_PRECISION )
				AND EXISTS (SELECT a.CHARACTER_SET_CATALOG INTERSECT SELECT b.CHARACTER_SET_CATALOG )
				AND EXISTS (SELECT a.CHARACTER_SET_SCHEMA INTERSECT SELECT b.CHARACTER_SET_SCHEMA )
				AND EXISTS (SELECT a.CHARACTER_SET_NAME INTERSECT SELECT b.CHARACTER_SET_NAME )
				AND EXISTS (SELECT a.COLLATION_CATALOG INTERSECT SELECT b.COLLATION_CATALOG )
				AND EXISTS (SELECT a.COLLATION_SCHEMA INTERSECT SELECT b.COLLATION_SCHEMA )
				AND EXISTS (SELECT a.COLLATION_NAME INTERSECT SELECT b.COLLATION_NAME )
				AND EXISTS (SELECT a.DOMAIN_CATALOG INTERSECT SELECT b.DOMAIN_CATALOG )
				AND EXISTS (SELECT a.DOMAIN_SCHEMA INTERSECT SELECT b.DOMAIN_SCHEMA )
				AND EXISTS (SELECT a.DOMAIN_NAME INTERSECT SELECT b.DOMAIN_NAME )
		)
	)
	SET @Error = 1'

EXEC sp_executesql @StrSQL, N'@Error INT OUTPUT', @Error = @ErrorFromDynSQL OUTPUT

IF @ErrorFromDynSQL = 1
BEGIN
	SET @ErrorInt = 1
	SET @ErrorMessage = 'RETURNCODE = 5: The column meta data does not match between the two tables.'
	SET @StrSQL = 'DROP TABLE ' + @TmpNameDestinationColumns
	EXEC sp_executesql @StrSQL
	RETURN(5)
END

/* Check if the stage table contains a column of the data type timestamp - not supported */
IF EXISTS (
	SELECT *
	FROM INFORMATION_SCHEMA.COLUMNS a
	WHERE 
		TABLE_SCHEMA = @Schema
		AND TABLE_NAME = @TableName
		AND DATA_TYPE = 'timestamp'
)
BEGIN
	SET @ErrorInt = 1
	SET @ErrorMessage = 'RETURNCODE = 6: A column of the data type timestamp exists in the stage table. This is not supported (read the documentation).'
	RETURN(6)
END

ELSE
RETURN(0)

SET @StrSQL = 'DROP TABLE ' + @TmpNameDestinationColumns
EXEC sp_executesql @StrSQL

SELECT @ErrorInt, @ErrorMessage