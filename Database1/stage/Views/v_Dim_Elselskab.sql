
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[v_Dim_Elselskab] AS 

SELECT 
BK_Elselskab = CAST(KVH_X as nvarchar(40))
,Kvhx = CAST([KVH_X] as nvarchar(40))
, Elselskab = CAST(elselskab as nvarchar(10))
  FROM [csv].[CityData]
  where BBRUSE <> 0
GROUP BY kvh_x, elselskab