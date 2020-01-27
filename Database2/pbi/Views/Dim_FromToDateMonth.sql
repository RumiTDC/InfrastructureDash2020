
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [pbi].[Dim_FromToDateMonth] AS 

SELECT  CAST([FromToDateMonth_Key] as nvarchar(20)) as FromToDateMonth_Key
      ,[YearMonth]
      ,[FromYearMonth]
      ,[ToYearMonth]
  FROM [edw].[Dim_FromToDateMonth]