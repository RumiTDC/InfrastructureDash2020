
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [pbi].[Dim_Elselskab] AS
SELECT [Elselskab_Key]
      --,[BK_Elselskab]
      ,[Kvhx]
      ,[Elselskab]
  FROM [edw].[Dim_Elselskab]