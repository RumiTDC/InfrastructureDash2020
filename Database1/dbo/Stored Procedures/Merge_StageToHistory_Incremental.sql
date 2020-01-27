
---------------------------------------

CREATE PROCEDURE [dbo].[Merge_StageToHistory_Incremental]
	@TableName AS varchar(128),
	@Schema AS varchar(128),
	@LogID varchar(10),
	@DestinationDatabase as varchar(128),
	@HistoryPrefix_Enabled int 
AS

BEGIN
	SET NOCOUNT ON;
DECLARE @ErrorInt int
DECLARE @ErrorMessage varchar(4000) 

EXEC [dbo].[Merge_Control] @TableName = @TableName,@Schema = @Schema,@DestinationDatabase = @DestinationDatabase, @HistoryPrefix_Enabled = @HistoryPrefix_Enabled, @ErrorInt = @ErrorInt OUTPUT, @ErrorMessage = @ErrorMessage OUTPUT;

IF @ErrorInt = 0
BEGIN

DECLARE @StartTime Varchar(50) = (SELECT [StartDate] FROM [EDW_Utility].[log].[Log] WHERE [LogID] = @LogID)
DECLARE @DestinationSchema varchar(128) = CASE WHEN @HistoryPrefix_Enabled = 1 THEN 'history_' + @Schema ELSE @Schema END

EXEC [setup].[CreateHistTable] @Schema = @Schema, @TableName = @TableName, @DestinationDatabase = @DestinationDatabase, @HistoryPrefix_Enabled = @HistoryPrefix_Enabled;

--Nedenst�ende Cursor benyttes til at lave n en temp tabel, som indeholder alle kolonner med b�de Target_ og Source_ pr�fiks, s�ledes at vi kan smide vores output ned i denne og senere inds�tte det i vores history tabel.
DECLARE @Column AS varchar(128)
DECLARE @Column2 AS varchar(128)
DECLARE @SQL_ColumnString_ToTempTable AS varchar(max) = ''
DECLARE @CreateTable as varchar(max)

DECLARE column_cursor CURSOR FOR

SELECT
'[Target_'+ COLUMN_NAME + '] ' + DATA_TYPE + 
case when DATA_TYPE in ('varchar','nvarchar','nchar','binary','varbinary','char') then + ' ('+  (Case when CHARACTER_MAXIMUM_LENGTH = -1 then 'max' else cast(CHARACTER_MAXIMUM_LENGTH as varchar(50)) end) + ')'
when DATA_TYPE in ('numeric', 'decimal') then + ' ('+ cast(NUMERIC_PRECISION as varchar(50)) + ',' + cast(NUMERIC_SCALE as varchar(50)) + ')'
when DATA_TYPE in ('datetime2','time','datetimeoffset') then + ' ('+  cast(DATETIME_PRECISION as varchar(50)) + ')'
else ''
end as TargetColumnToCreateStatement,
'[Source_'+ COLUMN_NAME + '] ' + DATA_TYPE + 
case when DATA_TYPE in ('varchar','nvarchar','nchar','binary','varbinary','char') then + ' ('+  (Case when CHARACTER_MAXIMUM_LENGTH = -1 then 'max' else cast(CHARACTER_MAXIMUM_LENGTH as varchar(50)) end) + ')'
when DATA_TYPE in ('numeric', 'decimal') then + ' ('+ cast(NUMERIC_PRECISION as varchar(50)) + ',' + cast(NUMERIC_SCALE as varchar(50)) + ')'
when DATA_TYPE in ('datetime2','time','datetimeoffset') then + ' ('+  cast(DATETIME_PRECISION as varchar(50)) + ')'
else ''
end as SOURCEColumnToCreateStatement
FROM
[INFORMATION_SCHEMA].[COLUMNS]
		WHERE
			[TABLE_SCHEMA] =  @Schema 
			AND [TABLE_NAME] =   @TableName 
			AND COLUMN_NAME != 'STA_DateCreated' 			
OPEN column_cursor
	FETCH NEXT FROM column_cursor INTO @Column, @Column2

	WHILE @@FETCH_STATUS = 0
	BEGIN

	IF (@SQL_ColumnString_ToTempTable <> '')
			SET @SQL_ColumnString_ToTempTable += ', ';
	SET @SQL_ColumnString_ToTempTable += @Column + ', '+  @Column2   
	
		FETCH NEXT FROM column_cursor INTO @Column, @Column2
	END

	CLOSE column_cursor
	DEALLOCATE column_cursor

	Set @CreateTable = '
	IF EXISTS ( SELECT * FROM [sys].[tables] Where name = '''+@Schema+'_'+@TableName+''' and schema_id = schema_id( ''history_temp''))
	Begin
	DROP table [history_temp].['+ @Schema +'_'+ @TableName + ']
	END
	CREATE TABLE [history_temp].['+ @Schema +'_'+ @TableName + '] ([Action] nvarchar(10),' + @SQL_ColumnString_ToTempTable + '
	 ,[Target_HistoryLogID] bigint
     ,[Target_HistoryValidDateTimeFrom] datetime2(7)
     ,[Target_HistoryValidDateTimeTo] datetime2(7)
     ,[Target_HistoryModifiedLogID] bigint
     ,[Target_HistoryModifiedDate] datetime2(7)
     ,[Target_HistoryCurrentRec] bit
	 ,[Target_HistoryDeletedAtSource] bit
	 ,[Source_HistoryDeletedAtSource] bit
	)'

    Print @CreateTable;
	EXEC (@CreateTable);


	DECLARE @PK_Column AS varchar(128)
    DECLARE @SQL_PK AS varchar(max) = ''
	DECLARE @PK_Columns as varchar(max)

--F�lgende Cursor laver den s�tning der benyttes til MERGE ON clausen, ved at se p� primary keys p� Source tabellen.
DECLARE PrimaryKey_column_cursor CURSOR FOR
select K.COLUMN_NAME from [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] T
INNER JOIN [INFORMATION_SCHEMA].[KEY_COLUMN_USAGE] K
ON T.CONSTRAINT_NAME = K.CONSTRAINT_NAME AND T.TABLE_SCHEMA = K.TABLE_SCHEMA
where CONSTRAINT_TYPE = 'PRIMARY KEY'
			AND T.[TABLE_SCHEMA] =  @Schema 
			AND T.[TABLE_NAME] =   @TableName 
ORDER BY ORDINAL_POSITION

OPEN PrimaryKey_column_cursor
	FETCH NEXT FROM PrimaryKey_column_cursor INTO @PK_Column

	WHILE @@FETCH_STATUS = 0
	BEGIN

	IF (@SQL_PK <> '')
			SET @SQL_PK += ' AND ';
	SET @SQL_PK += 'Target.['+ @PK_Column  + '] = Source.[' + @PK_Column +']'
	
		FETCH NEXT FROM PrimaryKey_column_cursor INTO @PK_Column
	END

	CLOSE PrimaryKey_column_cursor
	DEALLOCATE PrimaryKey_column_cursor

	DECLARE @SQL AS varchar(max);
	DECLARE @ColumnName AS varchar(128)
	DECLARE @SQL_ColumnString_ToTemp AS varchar(max) = ''
	DECLARE @SQL_ColumnString_ToTemp_InsertValues AS varchar(max) = ''
	DECLARE @SQL_ColumnString_UpdateSet AS varchar(max) = ''
	DECLARE @SQL_ColumnString_InsertColumns AS varchar(max) = ''
	DECLARE @SQL_ColumnString_InsertValues AS varchar(max) = ''
	DECLARE @SQL_ColumnString_InsertValues_OnDeleted AS varchar(max) = ''
	DECLARE @SQL_SelectColumnString_FromTemp AS varchar(max) = ''
	DECLARE @ConstraintName AS VARCHAR(128)
	DECLARE @DataType as Varchar (128)

	DECLARE column_cursor CURSOR FOR
			SELECT
			A.COLUMN_NAME AS ColumnName
			,K.CONSTRAINT_NAME
			,A.DATA_TYPE
		FROM
			[INFORMATION_SCHEMA].[COLUMNS] A LEFT OUTER JOIN
			[INFORMATION_SCHEMA].[KEY_COLUMN_USAGE] T
									INNER JOIN [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] K
									ON T.CONSTRAINT_NAME = K.CONSTRAINT_NAME and T.TABLE_SCHEMA = @Schema and T.[TABLE_NAME] = @TableName
								   and CONSTRAINT_TYPE = 'Primary Key'
						
			On A.COLUMN_NAME = T.COLUMN_NAME AND T.TABLE_SCHEMA = K.TABLE_SCHEMA
		WHERE
			A.[TABLE_SCHEMA] =  @Schema 
			AND A.[TABLE_NAME] =   @TableName
			AND A.COLUMN_NAME != 'STA_DateCreated' 
	 
	OPEN column_cursor
	FETCH NEXT FROM column_cursor INTO @ColumnName,@ConstraintName,@DataType

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF (@SQL_ColumnString_UpdateSet <> '')
				IF @ConstraintName is null
				IF @DataType != 'image'
			SET @SQL_ColumnString_UpdateSet += ' OR ';
		IF @ConstraintName is null
		IF @DataType != 'image'
		SET @SQL_ColumnString_UpdateSet += 'EXISTS (SELECT Target.[' + @ColumnName + '] EXCEPT SELECT  Source.[' + @ColumnName + '] )'
	    --http://stackoverflow.com/questions/4509722/nulls-and-the-merge-statement-i-need-to-set-a-value-to-infinity-how
	    --Explanes the EXISTS EXCEPT logic for the MERGE
		;

		IF (@SQL_ColumnString_InsertColumns <> '')
			SET @SQL_ColumnString_InsertColumns += ' , ';
		SET @SQL_ColumnString_InsertColumns += '[' + @ColumnName + ']'
		
		IF (@SQL_ColumnString_InsertValues <> '')
			SET @SQL_ColumnString_InsertValues += ' , ';
		SET @SQL_ColumnString_InsertValues += 'Source.[' + @ColumnName + ']'

		IF (@SQL_ColumnString_ToTemp <> '')
			SET @SQL_ColumnString_ToTemp += ' , ';
		SET @SQL_ColumnString_ToTemp += 'DELETED.[' + @ColumnName + '], Source.[' + @ColumnName + ']'

		IF (@SQL_ColumnString_ToTemp_InsertValues <> '')
			SET @SQL_ColumnString_ToTemp_InsertValues += ' , ';
		SET @SQL_ColumnString_ToTemp_InsertValues += '[Source_' + @ColumnName + ']'

		IF (@SQL_ColumnString_InsertValues_OnDeleted <> '')
			SET @SQL_ColumnString_InsertValues_OnDeleted += ' , ';
		SET @SQL_ColumnString_InsertValues_OnDeleted += '[Target_' + @ColumnName + ']'

		IF (@SQL_SelectColumnString_FromTemp <> '')
			SET @SQL_SelectColumnString_FromTemp += ' , ';
		SET @SQL_SelectColumnString_FromTemp += '[' + @ColumnName + ']'

		FETCH NEXT FROM column_cursor INTO @ColumnName,@ConstraintName,@DataType
	END

	CLOSE column_cursor
	DEALLOCATE column_cursor

    SET @SQL_SelectColumnString_FromTemp += 
		',[HistoryLogID]
		 ,[HistoryValidDateTimeFrom]
		 ,[HistoryValidDateTimeTo]
		 ,[HistoryModifiedLogID]
		 ,[HistoryModifiedDate]
		 ,[HistoryCurrentRec]
		 ,[HistoryDeletedAtSource]'

	-- Fill history table
	SET @SQL = '
	MERGE INTO ['+@DestinationDatabase+'].['+@DestinationSchema+'].[' + @TableName + '] AS Target
	USING ['+@Schema+'].[' + @TableName + '] AS Source
	ON ' + @SQL_PK + ' and Target.HistoryValidDateTimeTo = ''9999-12-31''
	 WHEN MATCHED  and (
			'+@SQL_ColumnString_UpdateSet+'
            ) 	
	    THEN
		UPDATE SET 
		Target.[HistoryValidDateTimeTo] = dateadd(NANOSECOND,-100, CAST(''' + @StartTime +''' as datetime2(7))),
		Target.[HistoryCurrentRec] = 0,
		Target.[HistoryModifiedLogID] = '''+@LogID+''',
		Target.[HistoryModifiedDate] = ''' + @StartTime +'''
	
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (
			' + @SQL_ColumnString_InsertColumns + '
			    ,[HistoryLogID]
				,[HistoryValidDateTimeFrom]
				,[HistoryValidDateTimeTo]
				,[HistoryCurrentRec]
				,[HistoryDeletedAtSource]
		)
		VALUES (
			' + @SQL_ColumnString_InsertValues + '
				,'''+@LogID+'''
				,'''+@StartTime+'''
				,''9999-12-31''
				,1 --It�s a new row, so it is the current active row
				,0 --It�s a new row, so it is not deleted
		)
	
	OUTPUT $action, ' + @SQL_ColumnString_ToTemp + ' 
	 ,INSERTED.[HistoryLogID]
     ,INSERTED.[HistoryValidDateTimeFrom]
     ,INSERTED.[HistoryValidDateTimeTo]
     ,INSERTED.[HistoryModifiedLogID]
     ,INSERTED.[HistoryModifiedDate]
     ,INSERTED.[HistoryCurrentRec]
     ,INSERTED.[HistoryDeletedAtSource]
	 ,DELETED.[HistoryDeletedAtSource]
	INTO [history_temp].['+ @Schema +'_'+ @TableName + '];

/*Insert of the new rows*/
INSERT INTO ['+@DestinationDatabase+'].['+ @DestinationSchema +'].['+ @TableName + ']
('+@SQL_SelectColumnString_FromTemp+')
SELECT '+@SQL_ColumnString_ToTemp_InsertValues +'
      ,'''+@LogID+''' --Inds�t LogID
      ,'''+@StartTime+'''
      ,''9999-12-31''
      ,NULL
      ,NULL
      ,1 --It is a new row, so it is the current row
      ,0 --It is a new row, so it is not a deleted row
  FROM [history_temp].['+ @Schema +'_'+ @TableName + ']
  WHERE [Target_HistoryDeletedAtSource] = 0 AND [Action] = ''UPDATE'';

'
	;
	PRINT @SQL;
	EXEC(@SQL);
	
    DECLARE @DropSQL as varchar(1000)
	Set @DropSQL = 'DROP TABLE [history_temp].['+ @Schema +'_'+ @TableName + ']'
    EXEC (@DropSQL);
	
END
ELSE
RAISERROR(@ErrorMessage,18,1)
END