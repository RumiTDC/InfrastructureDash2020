
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [pbi].[FromOperator] AS 

SELECT FromOperator_Key =  [Operatør_Key]
      ,FromOperator =
	  CASE
			WHEN Operatør = 'Unknown' THEN 'No TDC Operator'
			ELSE Operatør
		END
      --, =[OperatørGruppering]
      --, =[Teknologi]
      ,FromServiceProvider = 	
	  CASE
			WHEN ServiceProvider = 'Unknown' THEN 'No TDC ISP'
			ELSE ServiceProvider
		END
      --, =[BTO]
  FROM [pbi].[Dim_Operatør]