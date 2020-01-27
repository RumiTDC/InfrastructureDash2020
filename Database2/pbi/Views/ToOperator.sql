/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [pbi].[ToOperator] AS 

SELECT ToOperator_Key =  [Operatør_Key]
      ,ToOperator =[Operatør]
      --, =[OperatørGruppering]
      --, =[Teknologi]
      ,ToServiceProvider =[ServiceProvider]
      --, =[BTO]
  FROM [pbi].[Dim_Operatør]