








CREATE VIEW [pbi].[Dim_Teknologi] AS 
SELECT [Teknologi_Key]
  
      ,[BestPossibleTechnology]
	--  ,[BestTechnologyType]
      ,[TechnologyInstalled]
      ,[GIG_GDS_Coax_Fiber]
	  ,[DSLType]
	  , BTO_Fiber
	  , FiberType
	  ,[BestTechSort]
	  , [TechnologyInstalledSort]
  FROM [edw].[Dim_Teknologi]