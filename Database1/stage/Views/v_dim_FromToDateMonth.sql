CREATE View [stage].[v_dim_FromToDateMonth] AS

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
  FROM utility.Calendar
  where DateID > 20181231
  and Date <= DATEADD(YY, 2, GETDATE() )
  GROUP BY MONTH(Date), YEAR(Date), YearNameShort, MonthOfYearName, [Month]
)

SELECT 
BK_FromToDate = CAST(M3.YearMonth + '||' + M1.YearMonth + '||' + M2.YearMonth as nvarchar(100))
, M3.YearMonth,
FromYearMonth = M1.YearMonth, ToYearMonth = M2.YearMonth
FROM YearMonth M1, YearMonth M2, YearMonth M3
where M1.YearMonth <= M2.YearMonth and M3.YearMonth <= M1.YearMonth and M3.YearMonth <= M2.YearMonth
--Order by FromYearMonth, ToYearMonth