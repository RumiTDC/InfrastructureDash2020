


/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [pbi].[Dim_Month] AS 

SELECT
	MonthDate =  CAST(YEAR(Date) as nvarchar(4)) + '-' +
		CASE 
			WHEN LEN(MONTH(Date)) < 2 THEN '0' + CAST(MONTH(Date) as nvarchar(2))
			ELSE CAST(MONTH(Date) as nvarchar(2))
		END + '-01'
	, YearMonth = CAST(YEAR(Date) as nvarchar(4)) + 
		CASE 
			WHEN LEN(MONTH(Date)) < 2 THEN '0' + CAST(MONTH(Date) as nvarchar(2))
			ELSE CAST(MONTH(Date) as nvarchar(2))
		END
	, [MonthNumber] = MONTH(Date) 
	, Year = YearNameShort
	, Month = MonthOfYearName
	, LastUpdatedMonth =
		CASE
			WHEN LastUpdatedMonth is not null then 1
			ELSE 0
		END
--	, Quarter = QuarterOfYearNameShort
  FROM [edw].[Calendar] C
  LEFT JOIN pbi.LastUpdatedMonth LUM
  ON CAST(YEAR(Date) as nvarchar(4)) + '-' +
		CASE 
			WHEN LEN(MONTH(Date)) < 2 THEN '0' + CAST(MONTH(Date) as nvarchar(2))
			ELSE CAST(MONTH(Date) as nvarchar(2))
		END + '-01' = CAST(LUM.LastUpdatedMonth as date)
  where DateID > 20181231
  and Date <= DATEADD(YY, 2, GETDATE() )
  GROUP BY MONTH(Date), YEAR(Date), YearNameShort, MonthOfYearName, [Month],LastUpdatedMonth
  --ORDER BY YearMonth