

CREATE PROCEDURE [inf].[test_CVRKVHX_BF2] as


IF OBJECT_ID('tempdb.dbo.#CVR_STEP1', 'U') IS NOT NULL   DROP TABLE #CVR_STEP1;  

--TRUNCATE TABLE [stg].[Adresse_Inf_BF]
--Insert into  [stg].[Adresse_Inf_BF]

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT	[TDC_KVHX]
      ,	map.[cvrnr]
      ,	map.[navn_tekst]
      ,	[coNavn]
      ,	map.[ois_id]
	  --, [aarsbeskaeftigelse_antalAnsatteInterval]
	  , CVRRow = ROW_NUMBER() over (partition by tdc_kvhx order by map.cvrnr)
		--, [virksomhedsform_kode]
		--, [virksomhedsform_tekst]
		--, hovedbranche_kode
		--, [hovedbranche_tekst]
		--, [bibranche1_kode]
		--, [bibranche1_tekst]
		--, [bibranche2_kode]
		--, [bibranche2_tekst]
		--, [bibranche3_kode]
		--, [bibranche3_tekst]

		
	  	   	   
into #CVR_STEP1 

  FROM		[DataMart].[dbo].[KMD_CvrKvhxMapning] MAP
 Left JOIN  [KMDCognitoLocal].[CVR].[Virksomheder] VIR on map.cvrnr = VIR.cvrnr
 -- Group by TDC_KVHX, map.[ois_id]



 SELECT	[TDC_KVHX]
      ,	cvrnr = CASE when max(CVRRow) = 1 then convert(varchar, min(cvrnr)) else convert(varchar, max(CVRRow)) + ' CVR på adresse' end
  --    ,	[navn_tekst]

		, AntalCVR = max(CVRRow)

	  	   	   
into stg.test_CVRKVHX_BF2

  FROM #CVR_STEP1 
  Group by TDC_KVHX--, [navn_tekst]

  order by TDC_KVHX