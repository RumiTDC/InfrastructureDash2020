

CREATE PROCEDURE [edw].[InsertUnknownMember]
/*Version 1,3*/
(
            @SchemaName VARCHAR(MAX) ,--= 'edw' -- Skemanavnet p� den tabel hvor der skal inds�ttes en Unknown key
            @TableName VARCHAR(MAX) ,--= 'Date'--, -- Tabelnavnet p� den tabel hvor der skal inds�ttes en Unknown key
            @Language int = 2       ,                          -- Angiv sprog 1 = dansk, 2 = Engelsk
	 	    @BlankValue VARCHAR(MAX) = N'Blank'
)
AS

DECLARE @Skey VARCHAR(MAX)
DECLARE @Counter int
DECLARE @Columnname VARCHAR(MAX)
DECLARE @Datatype VARCHAR(MAX)
DECLARE @Columndefault VARCHAR(MAX)
DECLARE @Columnvalue VARCHAR(MAX)
DECLARE @Columnvalue_Blank VARCHAR(MAX)
DECLARE @SQL VARCHAR(MAX)
DECLARE @SQL_UPSERT_A VARCHAR(MAX)
DECLARE @SQL_UPSERT_B VARCHAR(MAX)
DECLARE @SQL_UPSERT_C VARCHAR(MAX)
DECLARE @SQL_UPSERT_D VARCHAR(MAX)
DECLARE @SQL_UPSERT_A_Blank VARCHAR(MAX)
DECLARE @SQL_UPSERT_DELIMIT VARCHAR(MAX)
DECLARE @SQL_IDENTITY_INSERT_ON VARCHAR(MAX)
DECLARE @SQL_IDENTITY_INSERT_OFF VARCHAR(MAX)
DECLARE @Unknown VARCHAR(MAX)
DECLARE @MaxLength int
DECLARE @MaxLength_Blank int
DECLARE @Ident int
DECLARE @T TABLE (INFO INT)
DECLARE @Info VARCHAR(MAX)
DECLARE @ParmDefinition NVARCHAR(MAX);

DECLARE @Temp TABLE
(
            ID INT IDENTITY(1,1),
            COLUMN_NAME VARCHAR(MAX),            
            DATA_TYPE VARCHAR(MAX),
            CHARACTER_MAXIMUM_LENGTH VARCHAR(MAX),
            COLUMN_DEFAULT VARCHAR(MAX)
)

INSERT INTO @Temp        
            (
                         COLUMN_NAME,
                         DATA_TYPE,
                         CHARACTER_MAXIMUM_LENGTH,
                         COLUMN_DEFAULT 
            )
            SELECT 
                         COLUMN_NAME,
                         DATA_TYPE,
                         CHARACTER_MAXIMUM_LENGTH,
                         COLUMN_DEFAULT
            FROM
                         INFORMATION_SCHEMA.COLUMNS
            WHERE
                         TABLE_SCHEMA = @SchemaName
                         AND TABLE_NAME = @TableName

/* DIVERSE TJEKPROCEDURER */

            /* Der tjekkes om Tabellen eksisterer */
            IF NOT EXISTS (          SELECT 1 
                                                              FROM INFORMATION_SCHEMA.TABLES 
                                                              WHERE TABLE_NAME = + @TableName
                                                              AND TABLE_SCHEMA = @SchemaName
                                                              ) 
                                     BEGIN
                                     SET @Info = 'ERROR! - table [' + @SchemaName + '].[' + @TableName + '] does not exist! - PROCEDURE TERMINATED'
                                     RAISERROR (@Info, 16, 1)
                                     RETURN
                                     END

            /* Det tjekkes om Primary Key findes */
            SET @Skey = (select COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = @SchemaName AND TABLE_NAME = @Tablename)
                         IF @Skey IS NULL
                         BEGIN
                                     SET @Info = 'ERROR: NO PRIMATY KEY SET ON TABLE [' + @SchemaName + '].[' + @TableName + '] - PROCEDURE TERMINATED'
                                     RAISERROR (@Info, 16, 1)
                                     RETURN
                         END

            /* Der tjekkes om n�glen er Identity */
            SET @Ident = (SELECT ident_current('[' + @SchemaName + '].[' + @TableName + ']'))
            IF @Ident > - 2
                         BEGIN
                                     SET @SQL_IDENTITY_INSERT_ON = 'SET IDENTITY_INSERT [' + @SchemaName + '].[' + @TableName + '] ON'
                                     SET @SQL_IDENTITY_INSERT_OFF = 'SET IDENTITY_INSERT [' + @SchemaName + '].[' + @TableName + '] OFF'
                         END
                         ELSE BEGIN
                                     SET @SQL_IDENTITY_INSERT_ON = ''
                                     SET @SQL_IDENTITY_INSERT_OFF = ''    
                         END

/* TJEKPROCEDURER  SLUT */
--SPROG
IF
            @Language = 1
SET
            @Unknown = '''Ukendt''' 
ELSE SET
            @Unknown = '''Unknown''' 

SET @SQL_UPSERT_DELIMIT = ''
SET @SQL_UPSERT_A        = ''
SET @SQL_UPSERT_B        = ''
SET @SQL_UPSERT_C        = ''
SET @SQL_UPSERT_D        = ''
SET @SQL_UPSERT_A_Blank  = ''

--LOOP
SET @Counter = 1
WHILE @Counter <= (SELECT MAX(ID) FROM @Temp)
BEGIN
                         SET @Datatype                        = (SELECT DATA_TYPE FROM @Temp WHERE ID = @Counter)
                         SET @Columnname                      = (SELECT COLUMN_NAME FROM @Temp WHERE ID = @Counter)
                         SET @Columndefault					  = (SELECT COLUMN_DEFAULT FROM @Temp WHERE ID = @Counter)
                         SET @MaxLength                       = (SELECT CHARACTER_MAXIMUM_LENGTH FROM @Temp WHERE ID = @Counter)
                         SET @MaxLength_Blank				  = (SELECT CHARACTER_MAXIMUM_LENGTH FROM @Temp WHERE ID = @Counter)

                         -- (sikrer at der kun st�r U hvis der ikke er plads)
                         IF @Language = 1 AND @MaxLength < 6
                                     SET @MaxLength = 1
                         ELSE IF @Language = 2 AND @MaxLength < 7
                                     SET @MaxLength = 1
                       
					     IF LEN(@BlankValue) > @MaxLength_Blank
						 SET @MaxLength_Blank = @MaxLength_Blank -- 1 /*Hvis vi onsker at den kun skal tage forste bogstav hvis ikke det hele kan staa der, s� skal denne bare saettes til 1*/

                         -- Sikrer at Datecreated ikke bliver overskrevet
                         IF @Columndefault is NULL AND @Skey != @Columnname
                         BEGIN
                                     SET @Columnvalue = NULL
                                     SET @Columnvalue_Blank = NULL

                                     IF @Datatype IN ('char', 'varchar', 'nchar', 'nvarchar', 'text', 'ntext')
                                     BEGIN
                                                  SET @Columnvalue = 'LEFT(' + @Unknown + ', ' + CAST(@MaxLength AS VARCHAR) + ')'
                                     END
                                     
                                     ELSE IF @Datatype IN ('date', 'datetime', 'datetime2', 'datetimeoffset', 'smalldatetime', 'time')
                                     BEGIN
                                                  SET @Columnvalue = '''1900-01-01'''
                                     END

                                     ELSE IF @Datatype IN ('bigint', 'numeric', 'smallint', 'decimal', 'smallmoney',  'int',  'money', 'float', 'binary', 'varbinary')
                                     BEGIN
                                                  SET @Columnvalue = '-1'
                                     END
                                     
                                     ELSE IF @Datatype IN ( 'image', 'bit',  'tinyint' )
                                     BEGIN
                                                  SET @Columnvalue = NULL
                                     END

									 /*This is for the Blank values*/
									  IF @Datatype IN ('char', 'varchar', 'nchar', 'nvarchar', 'text', 'ntext')
                                     BEGIN
                                                  SET @Columnvalue_Blank = 'LEFT(''' + @BlankValue + ''', ' + CAST(@MaxLength_Blank AS VARCHAR) + ')'
                                     END

                                     ELSE IF @Datatype IN ('date', 'datetime', 'datetime2', 'datetimeoffset', 'smalldatetime', 'time')
                                     BEGIN
                                                  SET @Columnvalue_Blank = '''1900-01-01'''
                                     END

                                     ELSE IF @Datatype IN ('bigint', 'numeric', 'smallint', 'decimal', 'smallmoney',  'int',  'money', 'float', 'binary', 'varbinary')
                                     BEGIN
                                                  SET @Columnvalue_Blank = '-2'
                                     END
                                     
                                     ELSE IF @Datatype IN ( 'image', 'bit',  'tinyint' )
                                     BEGIN
                                                  SET @Columnvalue_Blank = NULL
                                     END


                                     IF @Columnvalue IS NOT NULL
                                     BEGIN
                                                  IF (LEN(@SQL_UPSERT_A) > 0)
                                                  BEGIN
                                                              SET @SQL_UPSERT_DELIMIT  = ', '
                                                  END
                                                  SET @SQL_UPSERT_A = @SQL_UPSERT_A + @SQL_UPSERT_DELIMIT + @Columnvalue + ' AS [' + @Columnname + ']'
                                                  SET @SQL_UPSERT_B = @SQL_UPSERT_B + @SQL_UPSERT_DELIMIT + 'Target.[' + @Columnname + '] = Source.[' + @Columnname + ']'
                                                  SET @SQL_UPSERT_C = @SQL_UPSERT_C + @SQL_UPSERT_DELIMIT + '[' + @Columnname + ']'
                                                  SET @SQL_UPSERT_D = @SQL_UPSERT_D + @SQL_UPSERT_DELIMIT + 'Source.[' + @Columnname + ']'
                                     END

									 /*This is the Upsert Columns for Blank Values*/
									  IF @Columnvalue_Blank IS NOT NULL
                                     BEGIN
                                                  IF (LEN(@SQL_UPSERT_A_Blank) > 0)
                                                  BEGIN
                                                              SET @SQL_UPSERT_DELIMIT  = ', '
                                                  END
                                                  SET @SQL_UPSERT_A_Blank = @SQL_UPSERT_A_Blank + @SQL_UPSERT_DELIMIT + @Columnvalue_Blank + ' AS [' + @Columnname + ']'
                                                
                                     END
                         END

SET @Counter =  @Counter + 1
END

/* N�glen s�ttes til - 1, derefter updates v�rdierne p� gennem loop gennem kollonnerne */
            SET @SQL = @SQL_IDENTITY_INSERT_ON + '
MERGE INTO
            [' + @SchemaName + '].[' + @TableName + '] as Target
USING (
            SELECT
                         -1 AS ' + @Skey + '
                         ,' + @SQL_UPSERT_A + '
			UNION
			SELECT
                         -2 AS ' + @Skey + '
                         ,' + @SQL_UPSERT_A_Blank + '
) as Source
ON
            Target.' + @Skey + ' = Source.' + @Skey + '
WHEN
            MATCHED
THEN
            UPDATE SET
                         ' + @SQL_UPSERT_B + '
WHEN NOT MATCHED
THEN
            INSERT (
                         ' + @Skey + '
                         ,' + @SQL_UPSERT_C + '
            )
            VALUES (
                         Source.' + @Skey + '
                         ,' + @SQL_UPSERT_D + '
            )
;'
+ @SQL_IDENTITY_INSERT_OFF
            PRINT @SQL
            EXEC (@SQL)
            SET @SQL = ''

-- TJEKKER AT DET ER INDSAT N�GLE

SET @SQL = 'SELECT COUNT(*) FROM [' + @SchemaName + '].[' + @TableName + '] WHERE ' + @Skey + ' = -1'
INSERT INTO @T (INFO)
EXEC (@SQL)

SELECT INFO FROM @T
            IF (SELECT INFO FROM @T) <> 1
            BEGIN
                         SET @Info = 'ERROR! - Unknown key NOT INSERTED INTO [' + @SchemaName + '].[' + @TableName + '] or table not truncated before insert unknown key.'
                         RAISERROR (@Info, 16, 1)
                         RETURN
            END
            ELSE BEGIN
                         SET @Counter = 0
                         SET @Counter = (SELECT INFO FROM @T)
                         PRINT 'Unknown key inserted. Rows inserted ' + CAST(@Counter AS VARCHAR(MAX))
            END