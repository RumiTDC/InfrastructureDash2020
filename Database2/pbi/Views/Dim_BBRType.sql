/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [pbi].[Dim_BBRType] AS
SELECT  [BBRType_Key]
      ,[BBR_Type_Tekst]
  FROM [edw].[Dim_BBRType]