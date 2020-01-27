



CREATE VIEW [pbi].[Fact_Kundevandring] AS
SELECT  [FK_FromTeknologi]
      ,[FK_ToTeknologi]
      ,[FK_Adresse]
      ,[FK_FromOperator]
      ,[FK_ToOperator]
      ,[FK_BBRType]
      ,[FK_FromDate]
      ,[FK_ToDate]
      ,[FK_FromToDatePeriod]
	  ,[FK_Movementtype]
	  ,[F_Movement]
	  ,[F_Churn]
      ,[F_Nytilgang]
      ,[F_Kundevandring]
      ,[F_Nedgradering]
      --,[Movementtype]
  FROM [edw].[Fact_Kundevandring]