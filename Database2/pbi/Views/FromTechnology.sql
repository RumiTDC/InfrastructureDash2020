






CREATE VIEW [pbi].[FromTechnology] AS
SELECT FromTeknologi_Key = [Teknologi_Key]
      ,FromBestPossibleTechnology = [BestPossibleTechnology]
      ,FromTechnologyInstalled = 
		CASE
			WHEN [TechnologyInstalled] = 'Unknown' THEN 'No Installation'
			ELSE TechnologyInstalled
		END
      ,[FromGIG_GDS_Coax_Fiber] = GIG_GDS_Coax_Fiber
	  ,[FromFiberType] = FiberType
	  ,[FromFiberBTO] = BTO_Fiber
      --,[DSLType]
      --,[BestTechSort]
      --,[TechnologyInstalledSort]
	  , FromTechSort =  	
	  CASE
			WHEN TechnologyInstalled = 'Fiber' THEN CAST(1 as int)
			WHEN TechnologyInstalled = 'Coax' THEN CAST(2 as int)
			WHEN TechnologyInstalled = 'DSL' THEN CAST(3 as int)
			WHEN TechnologyInstalled = 'No Installation' THEN CAST(4 as int)
			ELSE 5
		END

  FROM [pbi].[Dim_Teknologi]