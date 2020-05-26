

CREATE PROCEDURE [dbo].[DimDateGeneratorAcc] 
AS


/* Standard date dimension table*/



/**POINT(!!!!) this to relevant datebase**/
 --USE [NETSTAGE] 
 

   /*Create Schema IF NOT EXIST*/
-- IF NOT EXISTS ( SELECT  *
--                FROM    sys.schemas
--                WHERE   name = N'cal' ) 
--    EXEC('CREATE SCHEMA [dbo] AUTHORIZATION [dbo]');
--GO

	/* Drop table table IF (...) */
-- IF OBJECT_ID('[dbo].DimDate', 'U') IS NOT NULL 
--  DROP TABLE [dbo].DimDate; 
--Go

--------- Part 1) Table Creation ---------------------
--CREATE TABLE [dbo].[DimDate](
--	[Date_Key]										INT		 					NULL,	--	'YYYYMMDD'
--	[PK_Date]										DATE						NULL,	--	'YYYY-MM-DD'
--	[Year_Key]										INT							NULL,	--	'YYYY'
--	[YearHalfyear_Key]								INT							NULL,	--	{YYYY1,YYYY2}
--	[YearHalfyear_Name_DK]							VARCHAR				(9)		NULL,	--	{'1. Halvår', '2.Halvår'}
--	[YearHalfyear_Name_EN]							VARCHAR				(11)	NULL,	--	{'1. Halfyear', '2.Halfyear'}
--	[Quarter_Key]									INT							NULL,	--  {'YYYY1', 'YYYY2', 'YYYY3', 'YYYY4'}
--	[Year_Quarter]									NVARCHAR			(6)		NULL,	--  {'YYYY-1','YYYY-2', 'YYYY-3', 'YYYY-4'}
--	[Quarter_Name_DK]								VARCHAR				(10)	NULL,	--	{'1. Kvartal', (...), 4. 'Kvartal'}
--	[Quarter_Name_EN]								VARCHAR				(10)	NULL,	--	{'1. Quarter', (...), 4. 'Quarter'}
--	[Month_Key]										INT							NULL,	--	'YYYYMM'
--	[Year_Month]									NVARCHAR			(7)		NULL,	--	'YYYY-MM'
--	[Month_Name_DK]									VARCHAR				(10)	NULL,	--	{'januar', 'februar', (...), 'december'}
--	[Month_Name_EN]									VARCHAR				(10)	NULL,	--	{'January', 'February', (...), 'December'}
--	[Month_Name_DK_Short]							VARCHAR				(3)		NULL,	--	{'jan','feb', (...), 'dec'}
--	[Month_Name_EN_Short]							VARCHAR				(3)		NULL,	--	{'Jan','Feb', (...), 'Dec'}
--	[Year_Month_Short_DK]							VARCHAR				(10)	NULL,	--	{'YYYY-jan', 'YYYY-feb', (...), 'YYYY-dec'}
--	[Year_Month_Short_EN]							VARCHAR				(10)	NULL,	--	{'YYYY-Jan', 'YYYY-Feb', (...), 'YYYY-Dec'}
--	[Year_Month_Long_DK]							NVARCHAR			(18)	NULL,	--	{'YYYY-januar', 'YYYY-februar',  (...), 'YYYY-december'}
--	[Year_Month_Long_EN]							NVARCHAR			(20)	NULL,	--	{'YYYY-January','YYYY-February', (...), 'YYYY-December'}
--	[Month_Number]									INT							NULL,	--	[1:12]
--	[Week_Key_ISO]									INT							NULL,	--	YYYYWW, where YYYY and WW form the isoyear+ isoweek combo (2016-01-01--->201553)
--	[Year_Week_Gregorian_Int]						INT							NULL,	--	former [Year Week ISO Int]--however it is the year+ gregorian week combo(2016-01-01-->201653)
--	[Year_Week_Int]									INT							NULL,	--	YYYYWW, where YYYY+WW form the basic year+week combo (2016-01-01-->201601)
--	[Year_Week]										VARCHAR				(7)		NULL,	--	CAL -- 'YYYY-W' / 'YYYY-WW' where W / WW = week_int(2016-01-01--> 2016-1)
--	[Week_Number_ISO]								INT							NULL,	--	w/WW
--	[Week_Int]										INT							NULL,	--	w/WW  (2016-01-01 is week 1)
--	[Week_Year_Key_ISO]								INT							NULL,	--	actually ISO year : YYYY (2016-01-01-->2015)
--	[Week_Name_DA]									VARCHAR				(6)		NULL,	--	Uge WeekNoISO (2016-01-01: Uge 53)
--	[Week_Name_EN]									VARCHAR				(7)		NULL,	--	Week WeekNoISO(2018-12-31: Week 01)
--	[Week_Name_DA_Unique]							VARCHAR				(12)	NULL,	--	Week_Name_DA, Week_Year_Key_ISO(2016-01-01 --> Uge 53, 2015)
--	[Week_Name_EN_Unique]							VARCHAR				(13)	NULL,	--	Week_Name_EN, Week_Year_Key_ISO
--	[Weekday_Key]									INT							NULL,	--	[1:7], where 1 = Monday
--	[Weekday_Name_DA]								VARCHAR				(7)		NULL,	--	{'mandag', 'tirsdag', (...), 'søndag'}
--	[Weekday_Name_EN]								NVARCHAR			(9)		NULL,	--	{'Monday', 'Tuesday', (...), 'Sunday'}
--	[Weekday_Name_DA_Short]							VARCHAR				(2)		NULL,	--	{'ma', 'ti', (...), 'sø'}
--	[Weekday_Name_EN_Short]							VARCHAR				(3)		NULL,	--	{'Mon','Tue', (...), 'Sun'}
--	[Day_Month_Key]									INT							NULL,	--	[1:31]
--	[Day_Month_Name]								VARCHAR				(7)		NULL,	--	'dd / mm'
--	[Day_Year_Key]									INT							NULL,	--	[1:366]
--	[Day_Year_Name]									VARCHAR				(10)	NULL,	--	'ddd / YYYY', eg: 003 / 2015
--	[LastDayInCurrentMonth]							DATE						NULL,	--	last day of the month from where the Date comes from.(2015-01-13--->2015-01-31)
--	[Seq_Day_Number]								INT							NULL,
--	[Seq_Month_Number]								INT							NULL,
--	[Seq_Month_Number_Desc]							INT							NULL,
--	[FiscalDate]									DATE						NOT NULL,--	'YYYY-MM-DD'			#RUM: will generate duplicate values for eom days, on some months. Very rare use case. 
--	[FiscalMonth]									INT							NOT NULL,-- [1:12] ( 2015-01-01 -->7)
--	[FiscalYear]									NVARCHAR			(9)		NOT NULL,--	'YYYY1/YYYY2' ( for 2015-01-01 --> 2014/2015)
--	[FiscalYearNum]									BIGINT						NOT NULL,-- sequential fiscal year
--) ON [PRIMARY]


--- Table Population-----------------------------------------------------------------------------------------------------------------------------
--TRUNCATE TABLE dbo.DimDate
DECLARE @StartDate		DATE
DECLARE @YearsAhead		INT
DECLARE @monthOffset	INT
DECLARE @FiscalMonth	INT
DECLARE @MonthSeq		INT


SET		@StartDate						= '2016-01-01'	-- First date in Time Dim
SET		@YearsAhead						= 20			-- Number of years from today to include in Time Dim. All dates in end year are included
SET		@FiscalMonth					= 7				-- the starting month for the fiscal year (in this case July)
SET		@monthOffset					= 6				-- offset (from 1-January) determing which is the starting fiscal month of the year. EG: The fiscal month of 2015-01-01 is 7.
														-- ( month 7 of the fiscal year starting from 2014-07-01)
SET		@MonthSeq						= ABS(DATEDIFF(MONTH,GETDATE(),@StartDate)) +1 -- add month difference to get sequential month in table

SET DATEFIRST 1 --  set the first day of the week to 1, meaning Monday.

;WITH Temp_Dim_Time AS
(
	SELECT
		Date = @StartDate

 	UNION all

	SELECT
		Date = DATEADD(DAY, 1, Date)
	FROM
		Temp_Dim_Time  
	WHERE
		YEAR(DATEADD(day, 1, Date)) <= YEAR(DATEADD(year, @YearsAhead, GETDATE()))
)

---
INSERT INTO dbo.DimDate
SELECT 
	 [Date_Key]						= CAST(CONVERT(VARCHAR(8), Date, 112) as int)
	,[PK_Date]						= [Date]
--	,[Date_VARCHAR]					= CAST(YEAR(Date) as VARCHAR) + '-' + RIGHT(('0' + CAST(MONTH(Date) as VARCHAR)), 2) + '-' + RIGHT(('0' + CAST(DAY(Date) as VARCHAR)), 2)
--	,[Date_VARCHAR_Reverse]			= RIGHT(('0' + CAST(DAY(Date) as VARCHAR)), 2) + '-' + RIGHT(('0' + CAST(MONTH(Date) as VARCHAR)), 2) + '-' + CAST(YEAR(Date) as VARCHAR)
--	,[Date_VARCHAR_US]				= convert(VARCHAR(36), [Date], 110)
	,[Year_Key]						= YEAR([Date])
	,[YearHalfYear_Key]				= CASE WHEN MONTH([Date]) in (1,2,3,4,5,6) then YEAR([Date]) * 10 + 1 ELSE YEAR([Date])*10 +2 END
	,[YearHalfyear_Name_DK]			= CASE WHEN month([Date]) in (1,2,3,4,5,6) then '1. Halvår' ELSE '2. Halvår' END
	,[YearHalfyear_Name_EN]			= CASE WHEN month([Date]) in (1,2,3,4,5,6) then '1. Halfyear'ELSE '2. Halfyear' END
--	,[YearHalfyear_Name_DK_Unique]	= CASE WHEN month([Date]) in (1,2,3,4,5,6) then '1. Halvår, ' + cast(year([Date]) as VARCHAR)
--									    ELSE '2. Halvår, ' + cast(year([Date]) as VARCHAR) END	
--	,[YearHalfyear_Name_EN_Unique]	= CASE WHEN month([Date]) in (1,2,3,4,5,6) then '1. Halfyear, ' + cast(year([Date]) as VARCHAR)
--										ELSE '2. Halfyear, ' + cast(year([Date]) as VARCHAR) END	
--	,[YearHalfyear_Number]			= CASE WHEN month([Date]) in (1,2,3,4,5,6) then 1 ELSE  2 END
	,[Quarter_Key]					= YEAR([Date]) * 10 + DATEPART(QUARTER, [Date])
	,[Year_Quarter]					= CAST(YEAR([Date]) as VARCHAR) + '-' + CAST(DATEPART(QUARTER,[Date]) as VARCHAR)
--	,[Year_Q_Quarter]				= CAST(YEAR([Date]) as VARCHAR) + '-Q' + CAST(DATEPART(QUARTER,[Date]) as VARCHAR)
	,[Quarter_Name_DK]				= CAST(DATEPART(QUARTER,[Date]) as VARCHAR) + '. Kvartal'
	,[Quarter_Name_EN]				= CAST(DATEPART(QUARTER,[Date]) as VARCHAR) + '. Quarter'
--	,[Quarter_Name_DK_Unique]		= CAST(DATEPART(QUARTER,[Date]) as VARCHAR) + '. Kvartal, ' + CAST(YEAR([Date]) as VARCHAR)
--	,Quarter_Name_EN_Unique			= CAST(DATEPART(QUARTER,[Date]) as VARCHAR) + '. Quarter, ' + CAST(YEAR([Date]) as VARCHAR)
--	,[Quarter_Number]				= DATEPART(QUARTER, [Date])
--	,[Quarter_Short]				= 'Q'+cast(DATEPART(QUARTER, [Date]) as VARCHAR(1))
	,[Month_Key]					= year([Date]) * 100 + month([Date])
	,[Year Month]					= FORMAT([Date], 'yyyy-MM')
	,[Month_Name_DK]				= FORMAT([Date],'MMMM','da-DK')
	,[Month_Name_EN]				= FORMAt([Date], 'MMMM','en-US')	
	,[Month_Name_DK_Short]			= FORMAT([Date],'MMM','da-DK')
	,[Month_Name_EN_Short]			= FORMAT([Date],'MMM','en-US')
	,[Year_Month_Short_DK]			= FORMAT([Date], 'yyyy-MMM', 'da-DK')
	,[Year_Month_Short_EN]			= FORMAT([Date], 'yyyy-MMM', 'en-US')
	,[Year_Month_Long_DK]			= FORMAT([Date], 'yyyy-MMMM', 'da-DK')
	,[Year_Month_Long_EN]			= FORMAT([Date], 'yyyy-MMMM', 'en-US')
	,[Month_Number]					= MONTH([Date])
	,[Week_Key_ISO]					= CASE
											WHEN DATEPART(ISO_WEEK, Date) = 1 AND MONTH(Date) = 12 THEN (YEAR(Date) + 1) * 100 + DATEPART(ISO_WEEK, Date)
											WHEN DATEPART(ISO_WEEK, Date) >= 52 AND MONTH(Date) = 1 THEN (YEAR(Date) - 1) * 100 + DATEPART(ISO_WEEK, Date)
											ELSE YEAR(Date) * 100 + DATEPART(ISO_WEEK, Date)
										END
	,[Year_Week_Gregorian_Int]		= YEAR([Date]) * 100 + DATEPART(ISO_WEEK,[Date])
	,[Year_Week_Int]				= YEAR([Date])* 100 + DATEPART(WEEK,[Date])
	,[Year_Week]					= CAST(YEAR([Date]) as VARCHAR) + '-' + CAST(DATEPART(WEEK, [Date]) as VARCHAR)--CAL
	,[Week_Number_ISO]				= DATEPART(ISO_WEEK,[Date])
	,[Week_Int]						= DATEPART(WEEK, [Date])
	,[Week_Year_Key_ISO]			= CASE
										WHEN DATEPART(ISO_WEEK, Date) = 1 AND MONTH(Date) = 12 THEN (YEAR(Date) + 1) 
										WHEN DATEPART(ISO_WEEK, Date) >= 52 AND MONTH(Date) = 1 THEN (YEAR(Date) - 1) 
										ELSE YEAR(Date) 
									  END
	,[Week_Name_DA]					= 'Uge ' + RIGHT('0' + CAST(DATEPART(ISO_WEEK,[Date]) as VARCHAR),2)
	,[Week_Name_EN]					= 'Week ' + right('0' + CAST(DATEPART(ISO_WEEK,[Date]) as VARCHAR),2)
	,[Week_Name_DA_Unique]			= CASE 
											WHEN DATEPART(ISO_WEEK, Date) = 1 AND MONTH(Date) = 12 THEN 'Uge ' + RIGHT('0' + CAST(DATEPART(ISO_WEEK, Date) as VARCHAR), 2) + ', ' + CAST((YEAR(Date) + 1) as VARCHAR)
											WHEN DATEPART(ISO_WEEK, Date) >= 52 AND MONTH(Date) = 1 THEN 'Uge ' + RIGHT('0' + CAST(DATEPART(ISO_WEEK, Date) as VARCHAR), 2) + ', ' + CAST((YEAR(Date) - 1) as VARCHAR)
											ELSE 'Uge ' + RIGHT('0' + CAST(DATEPART(ISO_WEEK, Date) as VARCHAR), 2) + ', ' + CAST(YEAR(Date) as VARCHAR)
										END
	,[Week_Name_EN_Unique]			= CASE 
											WHEN DATEPART(ISO_WEEK, Date) = 1 AND MONTH(Date) = 12 THEN 'Week ' + RIGHT('0' + CAST(DATEPART(ISO_WEEK, Date) as VARCHAR), 2) + ', ' + CAST((YEAR(Date) + 1) as VARCHAR)
											WHEN DATEPART(ISO_WEEK, Date) >= 52 AND MONTH(Date) = 1 THEN 'Week ' + RIGHT('0' + CAST(DATEPART(ISO_WEEK, Date) as VARCHAR), 2) + ', ' + CAST((YEAR(Date) - 1) as VARCHAR)
											ELSE 'Week ' + RIGHT('0' + CAST(DATEPART(ISO_WEEK, Date) as VARCHAR), 2) + ', ' + CAST(YEAR(Date) as VARCHAR)
										END
	,[Weekday_Key]					=  DATEPART(WEEKDAY,[Date])
	,[Weekday_Name_DA]				= FORMAT([Date], 'dddd', 'da-DK')
	,[Weekday_Name_EN]				= FORMAT([Date],'dddd','en-US')
	,[Weekday_Name_DA_Short]		= FORMAT([Date],'ddd','da-DK')
	,[Weekday_Name_EN_Short]		= FORMAT([Date],'ddd', 'en-US')
	,[Day_Month_Key]				= DAY([Date])
	,[Day_Month_Name]				= RIGHT('0' + CAST(DAY([Date]) as VARCHAR),2) + ' / ' + RIGHT('0' + CAST(MONTH([Date]) as VARCHAR),2) 
	,[Day_Year_Key]					= DATEPART(DAYOFYEAR, [Date])
	,[Day_Year_Name]				= RIGHT(('00'+ CAST(DATEPART(DAYOFYEAR,[Date]) as VARCHAR)),3)  + ' / ' + CAST(YEAR([Date]) as VARCHAR)
	,[LastDayInCurrentMonth]		= EOMONTH([Date])
	,[Seq_Day_Number]				= ROW_NUMBER() over (order by [Date])
	,[Seq_Month_Number]				= NULL
	,[Seq_Month_Number_Desc]		= NULL
	--,[FiscalDate]= DATEADD(MONTH,@monthOffset,[Date])
	,[FiscalMonth]					= MONTH(DATEADD(MONTH,@monthOffset,[Date]))
	,[FiscalYear]					= CASE
									  	WHEN MONTH([Date]) < @FiscalMonth then CAST(YEAR([Date])-1 AS VARCHAR) +'/' + CAST(YEAR([Date]) as VARCHAR)
									  	ELSE CAST(YEAR([Date]) AS VARCHAR) + '/' + CAST(YEAR([Date]) +1 AS VARCHAR) 
									  END
	,[FiscalYearNum]				= DENSE_RANK() OVER (ORDER BY CASE WHEN MONTH([Date]) < @FiscalMonth THEN  CAST(YEAR([Date]) -1 AS VARCHAR) + '/' + CAST(YEAR([Date]) AS VARCHAR)
																						   ELSE CAST(YEAR([Date]) AS VARCHAR) + '/' + CAST(YEAR([Date]) +1 AS VARCHAR)
																						   END) 
---------------------
FROM
	Temp_Dim_Time	src
WHERE
	Date NOT IN (SELECT [Date] FROM dbo.DimDate)

OPTION (MAXRECURSION 0)

------------------------------------------

;WITH TmpTbl
AS
(
 SELECT 
   [PK_Date]
  ,[Seq_Month_Number]				= (SELECT COUNT(DISTINCT sub.[Year_Month]) from [dbo].[DimDate] sub where sub.[PK_Date] <= src.[PK_Date])
  ,[Seq_Month_Number_Desc]			= (select COUNT(DISTINCT sub.[Year_Month]) from [dbo].[DimDate] sub where sub.[PK_Date] >= src.[PK_Date])

 FROM [dbo].[DimDate] src

)
UPDATE   td

SET		 td.[Seq_Month_Number]			= ts.[Seq_Month_Number] 
		,td.[Seq_Month_Number_Desc]		= ts.[Seq_Month_Number_Desc]

FROM	[dbo].[DimDate] td
			JOIN TmpTbl ts
				ON ts.[PK_Date] = td.[PK_Date]

 SELECT *
 FROM		dbo.[DimDate]
 ORDER BY	[PK_Date];