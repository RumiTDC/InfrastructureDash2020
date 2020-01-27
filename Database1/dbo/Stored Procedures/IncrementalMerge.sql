
CREATE PROC [dbo].[IncrementalMerge]
	@Schema nvarchar(128)
	,@TableName nvarchar(128)
AS

DECLARE
	@SQL nvarchar(MAX)

	,@ColumnName nvarchar(128)
	,@Constraint nvarchar(128)

	,@PKJoin nvarchar(max) = ''
	,@Update nvarchar(max) = ''
	,@Insert nvarchar(max) = ''
	,@Values nvarchar(max) = ''


DECLARE ColumnCursor CURSOR FOR
	SELECT
		A.COLUMN_NAME AS ColumnName
		,CONSTRAINT_TYPE
	FROM [INFORMATION_SCHEMA].[COLUMNS] A

	LEFT JOIN [INFORMATION_SCHEMA].[KEY_COLUMN_USAGE] T
	On A.COLUMN_NAME = T.COLUMN_NAME
	AND A.TABLE_SCHEMA = T.TABLE_SCHEMA
	AND A.TABLE_NAME = T.TABLE_NAME

	LEFT JOIN [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] K
	ON T.CONSTRAINT_NAME = K.CONSTRAINT_NAME

	WHERE A.[TABLE_SCHEMA] = @Schema
	AND A.[TABLE_NAME] =  @TableName

	ORDER BY ColumnName

OPEN ColumnCursor

	FETCH NEXT FROM ColumnCursor INTO @ColumnName, @Constraint

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF @Constraint = 'PRIMARY KEY'
		BEGIN
			IF (@PKJoin = '')
				SET @PKJoin += ' ON '
			ELSE
				SET @PKJoin += ' AND ';
			SET @PKJoin += 'T.['+ @ColumnName  + '] = S.[' + @ColumnName +']'
		END

		IF @Constraint <> 'PRIMARY KEY' OR @Constraint IS NULL
		BEGIN
			IF @Update <> ''
			SET @Update += ', '
			SET @Update += 'T.[' + @ColumnName + '] = S.[' + @ColumnName + ']'
		END

		IF @Insert <> ''
		SET @Insert += ', '
		SET @Insert += '[' + @ColumnName + ']'

		IF @Values <> ''
		SET @Values += ', '
		SET @Values += 'S.[' + @ColumnName + ']'

	FETCH NEXT FROM ColumnCursor INTO @ColumnName, @Constraint
	END

CLOSE ColumnCursor
DEALLOCATE ColumnCursor

SET @SQL = 
'MERGE [' + @Schema + '].[' + @TableName + '] AS T
USING [' + @Schema + '].[' + @TableName + '_ToUpdate] AS S'
+ @PKJoin +
' WHEN MATCHED
THEN UPDATE SET '
+ @Update +
' WHEN NOT MATCHED BY TARGET THEN 
INSERT (' + @Insert + ')
VALUES (' + @Values + ');'

EXEC (@SQL)