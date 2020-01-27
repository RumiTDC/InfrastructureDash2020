

CREATE PROCEDURE [setup].[CreateHistTable]
		@Schema AS varchar(128),
		@TableName AS varchar(128),
		@DestinationDatabase AS varchar(128),
		@HistoryPrefix_Enabled int 
as
BEGIN

DECLARE @Column AS varchar(128)
DECLARE @SQL_ColumnString_ToTempTable AS varchar(max) = ''
DECLARE @CreateTable as varchar(max)
DECLARE @CreateSchema as varchar(max)
DECLARE @DestinationSchema varchar(128) = CASE WHEN @HistoryPrefix_Enabled = 1 THEN 'history_' + @Schema ELSE @Schema END

/*
I f�lgende SQL kontrolleres det hvorvidt historik skemaet eksisterer og hvis ikke det g�r, s� laves dette.
*/
Set @CreateSchema = '
	USE '+ @DestinationDatabase+'	
		IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'''+@DestinationSchema+''')
		EXEC sys.sp_executesql N''CREATE SCHEMA ['+@DestinationSchema+']''
		
'
	EXEC (@CreateSchema);
	--Print (@CreateSchema);

/*Foelgende Cursor gaar ind og laver PK p� history tabellen ud fra de PK som findes paa Stage tabellen og s� bliver HistoryLogID tilf�jet dertil*/
DECLARE @ConstraintSQL varchar(400) = ''
DECLARE @PK_Column varchar(128) 
DECLARE @ConstraintName varchar(128)
DECLARE PrimaryKey_column_cursor CURSOR FOR
	select K.COLUMN_NAME from [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] T
	INNER JOIN [INFORMATION_SCHEMA].[KEY_COLUMN_USAGE] K
	ON T.CONSTRAINT_NAME = K.CONSTRAINT_NAME
	where CONSTRAINT_TYPE = 'PRIMARY KEY'
				AND T.[TABLE_SCHEMA] =  @Schema 
				AND T.[TABLE_NAME] =   @TableName 
	ORDER BY ORDINAL_POSITION

OPEN PrimaryKey_column_cursor
	FETCH NEXT FROM PrimaryKey_column_cursor INTO @PK_Column

	WHILE @@FETCH_STATUS = 0
	BEGIN

	IF (@ConstraintSQL <> '')
			SET @ConstraintSQL += ' , ';
	SET @ConstraintSQL += '['+ @PK_Column  + '] ASC'
	
		FETCH NEXT FROM PrimaryKey_column_cursor INTO @PK_Column
	END

	CLOSE PrimaryKey_column_cursor
	DEALLOCATE PrimaryKey_column_cursor

	SET @ConstraintSQL = 'CONSTRAINT PK_'+REPLACE(@TableName,' ','') +' PRIMARY KEY CLUSTERED (' + @ConstraintSQL + ' ,[HistoryLogID] ASC)'

/*
I f�lgende SQL findes kolonnerne fra Stage tabellen og disse laves som kolonnerne skal st� i et create statement.
*/
DECLARE column_cursor CURSOR FOR
SELECT
 '['+ COLUMN_NAME + '] ' + DATA_TYPE + 
 CASE 
	WHEN DATA_TYPE in ('varchar','nvarchar','char','nchar','binary','varbinary') THEN + ' ('+ (Case when CHARACTER_MAXIMUM_LENGTH = -1 then 'max' else cast(CHARACTER_MAXIMUM_LENGTH as varchar(50)) end) + ')'
	WHEN DATA_TYPE in ('numeric', 'decimal') THEN + ' ('+ cast(NUMERIC_PRECISION as varchar(50)) + ',' + cast(NUMERIC_SCALE as varchar(50)) + ')'
	WHEN DATA_TYPE in ('datetime2','time','datetimeoffset') THEN + ' ('+ cast(DATETIME_PRECISION as varchar(50)) + ')'
	ELSE ''
 END 
 + 
 CASE 
	WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' 
	ELSE ' NULL' 
 END 
 AS ColumnToCreateStatement
 FROM
 [INFORMATION_SCHEMA].[COLUMNS]
 WHERE
			[TABLE_SCHEMA] =  @Schema
			AND [TABLE_NAME] =   @TableName
OPEN column_cursor

FETCH NEXT FROM column_cursor INTO @Column

	WHILE @@FETCH_STATUS = 0
	BEGIN

	IF (@SQL_ColumnString_ToTempTable <> '')
			SET @SQL_ColumnString_ToTempTable += ', ';
	SET @SQL_ColumnString_ToTempTable += @Column 
		
		FETCH NEXT FROM column_cursor INTO @Column
	END

	CLOSE column_cursor
	DEALLOCATE column_cursor

	Set @CreateTable = '
	USE '+ @DestinationDatabase+'	
	IF NOT EXISTS ( SELECT * FROM sys.tables Where Name = '''+@TableName+''' and schema_id = schema_id( '''+@DestinationSchema+'''))
	Begin
	--DROP table ['+@DestinationSchema+'].['+  @TableName + ']
	
	CREATE TABLE ['+@DestinationSchema+'].['+ @TableName + '] ( '+@SQL_ColumnString_ToTempTable + '
	 ,[HistoryLogID] bigint
	 ,[HistoryValidDateTimeFrom] datetime2(7)
     ,[HistoryValidDateTimeTo] datetime2(7)
     ,[HistoryModifiedLogID] bigint
     ,[HistoryModifiedDate] datetime2(7)
     ,[HistoryCurrentRec] bit
	 ,[HistoryDeletedAtSource] bit
	  ,'+@ConstraintSQL+'
	)
	END
	'
	EXEC (@CreateTable);
	--Print (@CreateTable);

	EXEC dbo.CreateViewCurrentRec @TableName, @DestinationSchema, @DestinationDatabase, 0, @HistoryPrefix_Enabled
END