

/*
** This script create views on history tables.
** - The view name is prefixes the table name with "v"
**	   Example: Table	      "[history_mds].[Cons_AccountHierarchy]" 
**			  gets the view "[history_mds].[vCons_AccountHierarchy]"
**
** - The view (1) SELECTs all columns, (2) excludes the history house-keeping columns and (3) sets [HistoryCurrentRec] = 1 in the WHERE clause.
**
** NOTICE: IT WILL DROP THE VIEW ITS TRYING TO CREATE IF IT ALREADY EXISTS
*/ 


-- Change this variable 
-- The history schema to creates views on 

CREATE Proc [dbo].[CreateViewCurrentRec]
@TableName AS NVARCHAR(128),
@SchemaName AS NVARCHAR(128),
@DestinationDatabase AS NVARCHAR(128),
@AllTablesInSchema bit = 0, 
@HistoryPrefix_Enabled bit = 0

AS

DECLARE @HistDB AS NVARCHAR(128) = Concat(@DestinationDatabase,'.sys.sp_executesql')
DECLARE @DROP_VIEW_QUERY VARCHAR(4000);
DECLARE @CRETAE_VIEW_QUERY NVARCHAR(4000);

DECLARE crsMyTblParams CURSOR
FOR
    SELECT
		 [DROP_VIEW]
		,[SQL_QUERY]
    FROM
    (
    SELECT
		 [DROP_VIEW] = CONCAT('USE ',@DestinationDatabase,'; DROP VIEW IF EXISTS ',[TABLE_SCHEMA], '.[v',[TABLE_NAME],'];')
		,[SQL_QUERY] = CONCAT(
		'CREATE VIEW '
		,'[', IIF(@HistoryPrefix_Enabled = 1, 'History_',''),  [TABLE_SCHEMA], '].[v',[TABLE_NAME],'] AS ('
		,CHAR(13) + CHAR(10)
		,'SELECT'
		,CHAR(13) + CHAR(10)
		,[COLUMN_NAME]
		,CHAR(13) + CHAR(10)
		,'FROM '
		,'[', @DestinationDatabase,']','.[',IIF(@HistoryPrefix_Enabled = 1, 'History_',''), [TABLE_SCHEMA], ']', '.[',[TABLE_NAME],']'
		,CHAR(13) + CHAR(10)
		,'WHERE 1 = 1'
		,CHAR(13) + CHAR(10)
		,'AND [HistoryCurrentRec] = 1'
		,CHAR(13) + CHAR(10)
		,' )')
    FROM
    (
    SELECT
		 [TABLE_NAME] = [C1].[TABLE_NAME]
	    ,[TABLE_SCHEMA] = [C1].[TABLE_SCHEMA]
		,[COLUMN_NAME] = REPLACE(
		 (
		 SELECT
			   
			   (STUFF(
			   (
			   SELECT
					CHAR(10)+',['+[C2].[COLUMN_NAME]+']'
			   FROM [INFORMATION_SCHEMA].[COLUMNS] [C2]
			   WHERE 1 = 1
				    AND [C2].[TABLE_NAME] = [C1].[TABLE_NAME]
				    AND [C2].[TABLE_SCHEMA] = [C1].[TABLE_SCHEMA]
				    AND [C2].[COLUMN_NAME] NOT   IN('HistoryLogID',
													'HistoryValidDateTimeFrom',
													'HistoryValidDateTimeTo',
													'HistoryModifiedLogID',
													'HistoryModifiedDate',
													'HistoryCurrentRec',
													'HistoryDeletedAtSource') FOR
			   XML PATH(''),TYPE).value
			   ('.','VARCHAR(MAX)'),1,2,''))),CHAR(10),CHAR(13) + CHAR(10))
    FROM [INFORMATION_SCHEMA].[COLUMNS] [C1]
    INNER JOIN [INFORMATION_SCHEMA].[TABLES] [T] ON [T].[TABLE_SCHEMA] = [C1].[TABLE_SCHEMA]
										  AND [T].[TABLE_NAME] = [C1].[TABLE_NAME]
    WHERE 1 = 1
		AND [C1].[TABLE_SCHEMA] = @SchemaName
		AND ([C1].TABLE_NAME = @TableName OR @AllTablesInSchema = 1)
		AND [T].[TABLE_TYPE] ='BASE TABLE'
		
    GROUP BY
		   [C1].[TABLE_NAME]
		  ,[C1].[TABLE_SCHEMA]) [Sub]) [Sub2];


 
OPEN crsMyTblParams;   
FETCH NEXT FROM crsMyTblParams INTO @DROP_VIEW_QUERY
							,@CRETAE_VIEW_QUERY;



WHILE @@FETCH_STATUS = 0
    BEGIN

	  -- SELECT
			--[DropViewSQL]	  = @DROP_VIEW_QUERY
		 --   ,[CreateViewSQL]  = @CRETAE_VIEW_QUERY -- to see the results
		
PRINT (@DROP_VIEW_QUERY)
PRINT (@CRETAE_VIEW_QUERY)

	   EXEC (@DROP_VIEW_QUERY);	   -- This one drops existing views	
	  Select @CRETAE_VIEW_QUERY EXEC @HistDB @CRETAE_VIEW_QUERY;	   -- This one creates the views		 
	   FETCH NEXT FROM crsMyTblParams INTO @DROP_VIEW_QUERY
								   ,@CRETAE_VIEW_QUERY;
    END;
	


CLOSE crsMyTblParams;
DEALLOCATE crsMyTblParams;