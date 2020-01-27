

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [pbi].[Dim_Operatør] AS

SELECT  [Operatør_Key]
      ,[Operatør]
      ,[OperatørGruppering]
      ,[Teknologi]
      ,[ServiceProvider]

  FROM [edw].[Dim_Operatør]