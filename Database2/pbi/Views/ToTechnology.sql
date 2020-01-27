






CREATE VIEW [pbi].[ToTechnology] AS
SELECT ToTeknologi_Key = [Teknologi_Key]
      ,ToBestPossbileTechnology = [BestPossibleTechnology]
      ,ToTechnologyInstalled = [TechnologyInstalled]
      , ToGIG_GDS_Coax_Fiber = [GIG_GDS_Coax_Fiber]
	  , ToBTOFiber = BTO_Fiber
	  , ToFiberType = FiberType
      --,[DSLType]
      --,[BestTechSort]
      --,[TechnologyInstalledSort]
	,   ToTechSort =  	
	  CASE
			WHEN TechnologyInstalled = 'Fiber' THEN CAST(1 as int)
			WHEN TechnologyInstalled = 'Coax' THEN CAST(2 as int)
			WHEN TechnologyInstalled = 'DSL' THEN CAST(3 as int)
			WHEN TechnologyInstalled = 'No Installation' THEN CAST(4 as int)
			ELSE 5
		END
	, ToBestTechSort =
	  CASE
			WHEN BestPossibleTechnology = 'Fiber' THEN CAST(1 as int)
			WHEN BestPossibleTechnology = 'Coax' THEN CAST(2 as int)
			WHEN BestPossibleTechnology = 'DSL Only' THEN CAST(3 as int)
			WHEN BestPossibleTechnology = 'No TDC Infrastructure' THEN CAST(4 as int)
			ELSE 5
		END
  FROM [pbi].[Dim_Teknologi]