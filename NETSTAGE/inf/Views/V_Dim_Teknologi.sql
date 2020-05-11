

CREATE view  [inf].[V_Dim_Teknologi] as
(
select [BK_Teknologi]
      ,[BestPossibleTechnology]
      ,[TechnologyInstalled]
      ,[GIG_GDS_Coax_Fiber]
      ,[DSLType]
      ,[BestTechSort]
      ,[TechnologyInstalledSort]
      ,[BTO_Fiber]
      ,[FiberType]
      ,[dw_DateTimeLoad]
FROM [stg].[Teknologi_Inf]
--WHERE [BK_DateTo] is null

)