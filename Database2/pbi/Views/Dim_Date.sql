/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [pbi].[Dim_Date] AS 

SELECT
	DateID
	, Date
	, Year = YearNameShort
	, Month = MonthOfYearName
	, Quarter = QuarterOfYearNameShort
  FROM [edw].[Calendar]
  where DateID > 20181231