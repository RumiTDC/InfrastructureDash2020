

CREATE PROCEDURE [inf].[Dim_AdresseOneSP] as

IF OBJECT_ID('tempdb.dbo.#CityCount', 'U') IS NOT NULL   DROP TABLE #CityCount;  
IF OBJECT_ID('tempdb.dbo.#ADR_STEP1', 'U') IS NOT NULL   DROP TABLE #ADR_STEP1;  
IF OBJECT_ID('tempdb.dbo.#ADR_STEP2', 'U') IS NOT NULL   DROP TABLE #ADR_STEP2;  

	SELECT Adresse_By, COUNT(*) CityCount
		INTO #CityCount

	FROM [dm].[InfrastructureBaseDataV2]
	WHERE   IsCurrent = 1 AND IsDeleted = 0 
	GROUP BY Adresse_By

TRUNCATE TABLE stg.test_Adresse_BF
Insert into  stg.test_Adresse_BF

 Select --top 10000
 /* DATA SOURCE HHI_KVHX START */
		 [TDC_KVHX] = CAST(rtrim(h.[TDC_KVHX]) as nvarchar(20))
	 	, MDU_50Plus =
		CASE
			WHEN COUNT(h.[TDC_KVHX]) OVER(PARTITION BY Adresse_Kvh) > 49 then 1
			ELSE 0
		END
		, MDU_SDU_Amount = COUNT(h.[TDC_KVHX]) OVER(PARTITION BY Adresse_Kvh)
		, MDU_SDU = cast(CASE
					WHEN COUNT(h.[TDC_KVHX]) OVER(PARTITION BY Adresse_Kvh) >= 4 THEN 'MDU'
					ELSE 'SDU'
				END as nvarchar (10))
		,[DAWA_KVHX]
		,[kommunekode]
		,[kommunenavn]
		,h.[vejkode]
		,[vejnavn]
		,h.[husnummer]
		,h.[etage]
		,[sidedoer]
		,h.[postnummer]
		,[By]
		,[LandsdelKode]
		,[LandsdelNavn]
		,[RegionKode]
		,[RegionNavn]
		,[adgadr_id]
		,[ois_id]
		,[In_BBR]
		,[In_BBR_Daekning]
		,[In_MAD]
		,[In_Agillic]
		,[In_BSACoaxBlackList]
		,[In_BSACoaxWhiteList]
		,[In_BSACoax_WholeSale]
		,[In_Columbus_FiberOrders]
		,[In_Competitors_PDS]
		,[In_PDS_DKTV]
		,[In_eBSA_VULA_BB_Gensalg_Wholesale]
		,[In_Raa_Kobber_og_Delt_RK_Wholesale]
		,[In_EnergiStyrelsenBredbaand]
		,[In_TjekDitNet_Coax]
		,[In_TjekDitNet_Fiber]
		,[In_Total_utility_Fiber]
		,[In_WhitelistFtthDetail]
/* DATA SOURCE HHI_KVHX END */


/* DATA SOURCE HHI_KVHX [InfrastructureBaseDataV2] START */
		,I.[BBR_Coax_ejer]							-- FROM INF V2, TOO BE REPLACED in V3
		, CoaxAnlaegEjer = CAST(ISNULL(BBR_Coax_ejer, 'Ukendt') as nvarchar(10))
		,[BBR_Type_Tekst] =
	CASE
		WHEN BBR_BbrKode = 0 THEN CAST('Ukendt' as nvarchar(25)) 
		WHEN BBR_BbrKode = 1 THEN CAST('Residential Use' as nvarchar(25))
		WHEN BBR_BbrKode = 2 THEN CAST('Non-Residential Use' as nvarchar(25))
		WHEN BBR_BbrKode = 3 THEN CAST('Leisure-time use' as nvarchar(25))
		ELSE ''
	END
		,I.[Adresse_Kvh]
--		,I.[Adresse_Kommunenavn]
		, Latitude = 
		CASE 
			WHEN adresse_latitude IS NOT NULL
			THEN Adresse_Latitude
			ELSE ''
		END
					-- FROM INF V2, TOO BE REPLACED in V3
			, Longitude =  

		CASE
			WHEN Adresse_Longitude is not null
			THEN Adresse_Longitude 
			ELSE ''
		END
		,I.[WLEWII_ejer]							-- FROM INF V2, TOO BE REPLACED in V3
		, EWII_Adresse = 
		CASE
			WHEN I.WLEWII_ejer <> '' THEN CAST(1 AS bit)
			ELSE CAST(0 AS bit) 
		END
		,I.[WL_Coax]								-- FROM INF V2, TOO BE REPLACED in V3
		,I.[WL_Fiber]								-- FROM INF V2, TOO BE REPLACED in V3
		,I.[WL_Fiber_deselection_reasontekst]		-- FROM INF V2, TOO BE REPLACED in V3
		, CoaxWhitelist = CAST(WL_Coax as nvarchar(1))	 
		, FiberWhitelist = CAST(WL_Fiber as nvarchar(1))
		, CoaxBlacklist = CAST(BL_Coax as nvarchar(1)) 
		,I.[BL_Coax]								-- FROM INF V2, TOO BE REPLACED in V3
		,I.[BBR_PB_rev]							-- FROM INF V2, TOO BE REPLACED in V3
		, PB_Mulig = 
		CASE 
			WHEN BBR_PB_rev = 'PB' THEN 1
			ELSE 0
		END
/* DATA SOURCE HHI_KVHX [InfrastructureBaseDataV2] END */


		, [El-selskab]	= ISNULL( [El-selskab], 'Ukendt')
		, [BBRUSE]		= ISNULL([BBRUSE] , -1)

		, [PDS_Operatør]=  ISNULL( [PDS_Operatør], 'Ukendt')
		, [TDNCoax]		=	ISNULL( C.[KonkCoax]	, -1)	 
		, [TDNFiber]	=	ISNULL(F.[Konkurrerende_Elselskab] 	, -1)





		, CASE 
				WHEN[In_WhitelistFtthDetail] IS NOT NULL THEN 1
				ELSE 0
			  END AS 'FiberUdrulning'

/* DATA SOURCE WhitelistFtthDetail added 02-04-2020 */

		, dong_adr_2015  = case when dong_adr_2015 = 'Ja' then 1
								else 0
							end


	, Over10KIndbyggereIBy =
		CASE
			WHEN cc.CityCount >= 10000 THEN 1
			ELSE 0
		END

	, CVR.AntalCVR
	, CVRGruppering = CASE		WHEN 			CVR.AntalCVR between 0 and 5		then '1-5'
								WHEN 			CVR.AntalCVR between 6 and 10		then '6-10' 
								WHEN 			CVR.AntalCVR between 11 and 15		then '11-15' 
								WHEN 			CVR.AntalCVR between 15 and 20		then '16-20' 
								WHEN 			CVR.AntalCVR between 21 and 30		then '21-30' 
								WHEN 			CVR.AntalCVR between 31 and 40		then '31-40' 
								WHEN 			CVR.AntalCVR between 41 and 50		then '41-50' 
								WHEN 			CVR.AntalCVR between 51 and 100		then '51-100' 
								WHEN 			CVR.AntalCVR between 101 and 500	then '101-500'
								WHEN 			CVR.AntalCVR between 501 and 1000	then '501-1000'
								WHEN 			CVR.AntalCVR >= 1001				then '>1000'
								else 'Ukendt'
							END
						
	, CVRGruppering2 = CASE		WHEN 			CVR.AntalCVR between 0 and 10		then '1-10'
								WHEN 			CVR.AntalCVR between 10 and 50		then '11-50' 
								WHEN 			CVR.AntalCVR between 51 and 200		then '51-200' 
								WHEN 			CVR.AntalCVR between 201 and 501	then '201-500'
								WHEN 			CVR.AntalCVR between 501 and 1000	then '501-1000'
								WHEN 			CVR.AntalCVR >= 1001				then '>1000'
								else 'Ukendt'
						END
 -- INTO   stg.test_Adresse_BF-- select * from #ADR_STEP1
-- SELECT COUNT (*)


  FROM		[dm].[HHI_KVHX]								H
  LEFT JOIN [dm].[InfrastructureBaseDataV2]				I			ON	H.TDC_KVHX		= I.Adresse_Kvhx 
  LEFT JOIN	[dm].Total_utility_Fiber					U			ON	U.KVHX			= H.TDC_KVHX	
  LEFT JOIN [csv].[PDSKabling]							P			ON	P.KVHX			= H.TDC_KVHX	

/*We have joined on the views in regards to following TDN tabels. They are static and the logic used would be messy in this procedure. 
I have chosen the simplest solution since this probably is already or soon irrelevant data*/
  LEFT JOIN [inf].V_Dim_TDNCoax							C			ON	C.[BK_TDNCoax]	= H.TDC_KVHX	
  LEFT JOIN [inf].V_Dim_TDNFiber						F			ON	F.[BK_TDNFiber]	= H.TDC_KVHX	
  LEFT JOIN [$(DataMart)].dbo.whitelistFtthDetail			W			ON  W.kvhx = H.TDC_KVHX

  LEFT JOIN [stg].[test_CVRKVHX_BF2]					CVR			ON H.TDC_KVHX  = CVR.TDC_KVHX   
  
  LEFT JOIN #CityCount									CC			ON H.[By] = CC.Adresse_By





WHERE 
  (U.IsCurrent = 1 or U.IsCurrent IS NULL) AND (U.IsDeleted = 0 or U.IsDeleted IS NULL)

  AND 
  H.IsCurrent = 1 AND H.IsDeleted = 0 
  AND 
--  I.IsCurrent = 1 AND I.IsDeleted = 0 
(I.IsCurrent = 1 or i.IsCurrent IS NULL) AND (I.IsDeleted = 0 or I.IsCurrent IS NULL)



 --SELECT
	--[TDC_KVHX] 
	--,[DAWA_KVHX]
	--,[By]
	--,[postnummer]
	--,[Vejnavn]
	--,[Kommunekode]	
	--,[Kommunenavn]
 --   ,[etage]	
 --   ,[husnummer]	
 --   ,[sidedoer]
	--,[LandsdelKode]
 --   ,[LandsdelNavn]
 --   ,[RegionKode]
 --   ,[RegionNavn]
 --   ,[adgadr_id]
 --   ,[ois_id]
 --   ,[In_BBR]
	--,[BBR_Type_Tekst]
 --   ,[In_BBR_Daekning]
 --   ,[In_MAD]
 --   ,[In_Agillic]
 --   ,[In_BSACoaxBlackList]
 --   ,[In_BSACoaxWhiteList]
 --   ,[In_BSACoax_WholeSale]
 --   ,[In_Columbus_FiberOrders]
 --   ,[In_Competitors_PDS]
 --   ,[In_PDS_DKTV]
 --   ,[In_eBSA_VULA_BB_Gensalg_Wholesale]
 --   ,[In_Raa_Kobber_og_Delt_RK_Wholesale]
 --   ,[In_EnergiStyrelsenBredbaand]
 --   ,[In_TjekDitNet_Coax]
 --   ,[In_TjekDitNet_Fiber]
 --   ,[In_Total_utility_Fiber]
 --   ,[In_WhitelistFtthDetail]
	
	--, BBR_Coax_ejer
	--, Latitude
	--, Longitude
	--, WLEWII_ejer
	--, WL_Coax
	--, WL_Fiber
	--, WL_Fiber_deselection_reasontekst
	--, BL_Coax
	--, MDU_50Plus
	--, MDU_SDU_Amount
	--, PB_Mulig

	--, [BBRUSE]
	--, [El-selskab]

	--, [PDS_Operatør]
	--, [TDNCoax] 
	--, [TDNFiber]
	--, DongKommuner = dong_adr_2015

 -- INTO	 #ADR_STEP2
 -- FROM   #ADR_STEP1




--SELECT
--	 [TDC_KVHX] = CAST(rtrim([TDC_KVHX]) as nvarchar(20))
--	, [By] 
--	, [Kommunekode] 
--	, Kommunenavn 
--	, Etage 
--	, [husnummer]			
--	, [sidedoer]
--	, Latitude  
--	, Longitude  
--	, A.Postnummer
--	, Vejnavn 
--	, DongKommuner = dong_adr_2015 
--      ,[ois_id]
--      ,[In_BBR]
--	  ,[BBR_Type_Tekst]
--      ,[In_BBR_Daekning]
--      ,[In_MAD]
--      ,[In_Agillic]
--      ,[In_BSACoaxBlackList]
--      ,[In_BSACoaxWhiteList]
--      ,[In_BSACoax_WholeSale]
--      ,[In_Columbus_FiberOrders]
--      ,[In_Competitors_PDS]
--      ,[In_PDS_DKTV]
--      ,[In_eBSA_VULA_BB_Gensalg_Wholesale]
--      ,[In_Raa_Kobber_og_Delt_RK_Wholesale]
--      ,[In_EnergiStyrelsenBredbaand]
--      ,[In_TjekDitNet_Coax]
--      ,[In_TjekDitNet_Fiber]
--      ,[In_Total_utility_Fiber]
--      ,[In_WhitelistFtthDetail]
--	  ,EWII_Adresse
--	, CoaxWhitelist		 
--	, FiberWhitelist	
--	, CoaxBlacklist		
--	, CoaxAnlaegEjer = CAST(ISNULL(BBR_Coax_ejer, 'Ukendt') as nvarchar(10))
--	, FiberWhitelistDeselectionText = CAST(ISNULL(WL_Fiber_deselection_reasontekst, 'Ukendt') as nvarchar(40))
--	, MDU_50Plus
--	, MDU_SDU_amount = MDU_SDU_Amount
--	, IndbyggertalBy = CC.CityCount
--	, Over10KIndbyggereIBy =
--		CASE
--			WHEN cc.CityCount >= 10000 THEN 1
--			ELSE 0
--		END
--	, PB_Mulig
--	, CASE 
--		WHEN[In_WhitelistFtthDetail] IS NOT NULL THEN 1
--		ELSE 0
--	  END AS 'FiberUdrulning'
--	, [El-selskab] = ISNULL( [El-selskab], 'Ukendt')
--	, [BBRUSE] = ISNULL([BBRUSE] , -1)

--	, [PDS_Operatør]=  ISNULL( [PDS_Operatør], 'Ukendt')
--	, [TDNCoax]		=	ISNULL([TDNCoax]	, -1)	 
--	, [TDNFiber]	=	ISNULL([TDNFiber] 	, -1)

----into   stg.Adresse_INF2
--FROM  #ADR_STEP1 A
--LEFT JOIN #CityCount CC
--ON A.[By] = CC.Adresse_By


----IF OBJECT_ID('tempdb.dbo.#CityCount', 'U') IS NOT NULL   DROP TABLE #CityCount;  
----IF OBJECT_ID('tempdb.dbo.#ADR_STEP1', 'U') IS NOT NULL   DROP TABLE #ADR_STEP1;  
----IF OBJECT_ID('tempdb.dbo.#ADR_STEP2', 'U') IS NOT NULL   DROP TABLE #ADR_STEP2;  

----select * from #ADR_STEP2  