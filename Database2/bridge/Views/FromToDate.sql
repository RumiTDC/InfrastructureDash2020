



CREATE View [bridge].[FromToDate] AS

With YearMonth AS (

SELECT
--	DateID
	 YearMonth = CAST(YEAR(Date) as nvarchar(4)) + 
		CASE 
			WHEN LEN(MONTH(Date)) < 2 THEN '0' + CAST(MONTH(Date) as nvarchar(2))
			ELSE CAST(MONTH(Date) as nvarchar(2))
		END
	, [MonthNumber] = MONTH(Date) 
	, Year = YearNameShort
	, Month = MonthOfYearName
--	, Quarter = QuarterOfYearNameShort
  FROM edw.Calendar
  where DateID > 20181231
  and Date <= DATEADD(YY, 2, GETDATE() )
  GROUP BY MONTH(Date), YEAR(Date), YearNameShort, MonthOfYearName, [Month]
)
, CrossJ as (
SELECT 
BK_FromToDate = CAST (M1.YearMonth + '||' + M2.YearMonth as nvarchar(100))
, FromToDate_Key = CAST(M1.YearMonth + M2.YearMonth as bigint)
, M3.YearMonth
,FromYearMonth = M1.YearMonth
, ToYearMonth = M2.YearMonth
FROM YearMonth M1, YearMonth M2, YearMonth M3
where M1.YearMonth <= M2.YearMonth and M3.YearMonth >= M1.YearMonth and M3.YearMonth <= M2.YearMonth
)
, UnionedData AS(
SELECT *
FROM CrossJ
UNION ALL
SELECT BK_FromToDate = FromYearMonth + '||' + '999912', FromToDate_Key = CAST(FromYearMonth + '999912' as bigint), YearMonth, FromYearMonth, ToYearMonth = 999912
FROM CrossJ
)

SELECT
	BK_FromToDate
	, CAST(FromToDate_Key as nvarchar(20)) as FromToDate_Key
	, YearMonth
	, MonthDate =  CAST(LEFT(YearMonth,4) as nvarchar(4)) + '-' +
		CAST(RIGHT(YearMonth,2) as nvarchar(2)) + '-01'
	, FromYearMonth
	, ToYearMonth
FROM UnionedData
GROUP BY 

	BK_FromToDate
	, FromToDate_Key
	, YearMonth
	, FromYearMonth
	, ToYearMonth