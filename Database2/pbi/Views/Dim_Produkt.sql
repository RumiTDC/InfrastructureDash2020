
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [pbi].[Dim_Produkt] AS

SELECT  [Produkt_Key]
   
      ,[Produktnavn]
      ,[DownloadHastighed_KB]
   
      ,[Produktområde]
   
  FROM [edw].[Dim_Produkt]