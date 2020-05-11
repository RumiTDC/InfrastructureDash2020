

CREATE PROCEDURE [inf].[Dim_Adresse] as

IF OBJECT_ID('tempdb.dbo.#CityCount', 'U') IS NOT NULL   DROP TABLE #CityCount;  
IF OBJECT_ID('tempdb.dbo.#ADR_STEP1', 'U') IS NOT NULL   DROP TABLE #ADR_STEP1;  
IF OBJECT_ID('tempdb.dbo.#ADR_STEP2', 'U') IS NOT NULL   DROP TABLE #ADR_STEP2;  

	SELECT Adresse_By, COUNT(*) CityCount
		INTO #CityCount

	FROM [dm].[InfrastructureBaseDataV2]
	WHERE   IsCurrent = 1 AND IsDeleted = 0 
	GROUP BY Adresse_By


 Select --top 10000
 /* DATA SOURCE HHI_KVHX START */
		 [TDC_KVHX]
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
		,I.[BBR_BbrKode]
		,I.[Adresse_Kvh]
--		,I.[Adresse_Kommunenavn]
		,I.[Adresse_Latitude]						-- FROM INF V2, TOO BE REPLACED in V3
		,I.[Adresse_Longitude]					-- FROM INF V2, TOO BE REPLACED in V3
		,I.[WLEWII_ejer]							-- FROM INF V2, TOO BE REPLACED in V3
		,I.[WL_Coax]								-- FROM INF V2, TOO BE REPLACED in V3
		,I.[WL_Fiber]								-- FROM INF V2, TOO BE REPLACED in V3
		,I.[WL_Fiber_deselection_reasontekst]		-- FROM INF V2, TOO BE REPLACED in V3
		,I.[BL_Coax]								-- FROM INF V2, TOO BE REPLACED in V3
		,I.[BBR_PB_rev]							-- FROM INF V2, TOO BE REPLACED in V3
/* DATA SOURCE HHI_KVHX [InfrastructureBaseDataV2] END */

		,U.[BBRUSE]
		,U.[El-selskab]

		,P.[PDS_Operatør]

		,[TDNCoax] = C.[KonkCoax]
		,[TDNFiber] = F.[Konkurrerende_Elselskab]


/* DATA SOURCE WhitelistFtthDetail added 02-04-2020 */

		, dong_adr_2015  = case when dong_adr_2015 = 'Ja' then 1
								else 0
							end
  INTO #ADR_STEP1 -- select * from #ADR_STEP1
-- SELECT COUNT (*)

  FROM [dm].[HHI_KVHX]									H
  LEFT JOIN [dm].[InfrastructureBaseDataV2]				I			ON	H.TDC_KVHX		= I.Adresse_Kvhx 
  LEFT JOIN	[dm].Total_utility_Fiber					U			ON	U.KVHX			= H.TDC_KVHX	
  LEFT JOIN [csv].[PDSKabling]							P			ON	P.KVHX			= H.TDC_KVHX	

/*We have joined on the views in regards to following TDN tabels. They are static and the logic used would be messy in this procedure. 
I have chosen the simplest solution since this probably is already or soon irrelevant data*/
  LEFT JOIN [inf].V_Dim_TDNCoax							C			ON	C.[BK_TDNCoax]	= H.TDC_KVHX	
  LEFT JOIN [inf].V_Dim_TDNFiber						F			ON	F.[BK_TDNFiber]	= H.TDC_KVHX	
  LEFT JOIN DataMart.dbo.whitelistFtthDetail			W			ON  W.kvhx = H.TDC_KVHX


WHERE 
  (U.IsCurrent = 1 or U.IsCurrent IS NULL) AND (U.IsDeleted = 0 or U.IsDeleted IS NULL)

  AND 
  H.IsCurrent = 1 AND H.IsDeleted = 0 
  AND 
--  I.IsCurrent = 1 AND I.IsDeleted = 0 
(I.IsCurrent = 1 or i.IsCurrent IS NULL) AND (I.IsDeleted = 0 or I.IsCurrent IS NULL)



 SELECT
	[TDC_KVHX] 
	,[DAWA_KVHX]
	,[By]
	,[postnummer]
	,[Vejnavn]
	,[Kommunekode]	
	,[Kommunenavn]
    ,[etage]	
    ,[husnummer]	
    ,[sidedoer]
	,[LandsdelKode]
    ,[LandsdelNavn]
    ,[RegionKode]
    ,[RegionNavn]
    ,[adgadr_id]
    ,[ois_id]
    ,[In_BBR]
	,[BBR_Type_Tekst] =
	CASE
		WHEN BBR_BbrKode = 0 THEN CAST('Ukendt' as nvarchar(25)) 
		WHEN BBR_BbrKode = 1 THEN CAST('Residential Use' as nvarchar(25))
		WHEN BBR_BbrKode = 2 THEN CAST('Non-Residential Use' as nvarchar(25))
		WHEN BBR_BbrKode = 3 THEN CAST('Leisure-time use' as nvarchar(25))
		ELSE ''
	END
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
	


	, BBR_Coax_ejer
	, Latitude = 
		CASE 
			WHEN adresse_latitude IS NOT NULL
			THEN Adresse_Latitude
			ELSE ''
		END
	, Longitude =  

		CASE
			WHEN Adresse_Longitude is not null
			THEN Adresse_Longitude 
			ELSE ''
		END
	, WLEWII_ejer
	, WL_Coax
	, WL_Fiber
	, WL_Fiber_deselection_reasontekst
	, BL_Coax
	, MDU_SDU = CASE
					WHEN COUNT([TDC_KVHX]) OVER(PARTITION BY Adresse_Kvh) >= 4 THEN 'MDU'
					ELSE 'SDU'
				END
	, MDU_50Plus =
		CASE
			WHEN COUNT([TDC_KVHX]) OVER(PARTITION BY Adresse_Kvh) > 49 then 1
			ELSE 0
		END
	, MDU_SDU_Amount = COUNT([TDC_KVHX]) OVER(PARTITION BY Adresse_Kvh)
	, PB_Mulig = 
		CASE 
			WHEN BBR_PB_rev = 'PB' THEN 1
			ELSE 0
		END
	, [BBRUSE]
	, [El-selskab]

	, [PDS_Operatør]
	, [TDNCoax] 
	, [TDNFiber]
	, DongKommuner = dong_adr_2015

  INTO	 #ADR_STEP2
  FROM   #ADR_STEP1


TRUNCATE TABLE [stg].[Adresse_Inf]
Insert into  [stg].[Adresse_Inf]

SELECT
	 [TDC_KVHX] = CAST(rtrim([TDC_KVHX]) as nvarchar(20))
	, [By] 
	, [Kommunekode] 
	, Kommunenavn 
	, Etage 
	, [husnummer]			
	, [sidedoer]
	, Latitude  
	, Longitude  
	, A.Postnummer
	, Vejnavn 
	, DongKommuner 
      ,[ois_id]
      ,[In_BBR]
	  ,[BBR_Type_Tekst]
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
	, EWII_Adresse = 
		CASE
			WHEN A.WLEWII_ejer <> '' THEN CAST(1 AS bit)
			ELSE CAST(0 AS bit) 
		END
	, CoaxWhitelist = CAST(WL_Coax as nvarchar(1))	 
	, FiberWhitelist = CAST(WL_Fiber as nvarchar(1))
	, CoaxBlacklist = CAST(BL_Coax as nvarchar(1)) 
	, MDU_SDU = CAST(MDU_SDU as nvarchar(10)) 
	, CoaxAnlaegEjer = CAST(ISNULL(BBR_Coax_ejer, 'Ukendt') as nvarchar(10))
	, FiberWhitelistDeselectionText = CAST(ISNULL(WL_Fiber_deselection_reasontekst, 'Ukendt') as nvarchar(40))
	, MDU_50Plus
	, MDU_SDU_amount = MDU_SDU_Amount
	, IndbyggertalBy = CC.CityCount
	, Over10KIndbyggereIBy =
		CASE
			WHEN cc.CityCount >= 10000 THEN 1
			ELSE 0
		END
	, PB_Mulig
	, CASE 
		WHEN[In_WhitelistFtthDetail] IS NOT NULL THEN 1
		ELSE 0
	  END AS 'FiberUdrulning'
	, [El-selskab] = ISNULL( [El-selskab], 'Ukendt')
	, [BBRUSE] = ISNULL([BBRUSE] , -1)

	, [PDS_Operatør]=  ISNULL( [PDS_Operatør], 'Ukendt')
	, [TDNCoax]		=	ISNULL([TDNCoax]	, -1)	 
	, [TDNFiber]	=	ISNULL([TDNFiber] 	, -1)

--into   stg.Adresse_INF2
FROM  #ADR_STEP2 A
LEFT JOIN #CityCount CC
ON A.[By] = CC.Adresse_By


--IF OBJECT_ID('tempdb.dbo.#CityCount', 'U') IS NOT NULL   DROP TABLE #CityCount;  
--IF OBJECT_ID('tempdb.dbo.#ADR_STEP1', 'U') IS NOT NULL   DROP TABLE #ADR_STEP1;  
--IF OBJECT_ID('tempdb.dbo.#ADR_STEP2', 'U') IS NOT NULL   DROP TABLE #ADR_STEP2;  

--select * from #ADR_STEP2  