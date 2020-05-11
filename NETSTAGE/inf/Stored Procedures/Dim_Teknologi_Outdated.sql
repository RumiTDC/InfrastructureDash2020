/****** Script for SelectTopNRows command from SSMS  ******/
Create procedure [inf].[Dim_Teknologi_Outdated] AS
     SET NOCOUNT ON; 
	 IF 1=0 BEGIN
	 SET FMTONLY OFF END

SELECT
Adresse_Kvhx
, TDC_Fiber_Enabled =
	CASE
		WHEN WL_Fiber = '1' THEN 1
		ELSE 0
	END
	, TDC_Coax_Enabled_Wholesale =
	CASE
		WHEN WL_Coax_Adgang_Andre_BBOperatoer NOT IN ('', 'Nej') and WL_Coax_BB_Styret_afsaetning NOT IN ('Nej', '') THEN 1
		ELSE 0
	END
	, TDC_Coax_Enabled_YouseeOnly =
		CASE 
			WHEN BBR_Coax_anlaeg_id <> '' THEN
				CASE
					WHEN WL_Coax_Adgang_Andre_BBOperatoer IN ('Nej', '') AND WL_Coax_BB_Styret_afsaetning NOT IN ('Nej', '') THEN 1
					ELSE 0
				END
		ELSE 0
		END
	, TDC_Coax_Enabled =
		CASE
			WHEN BBR_Coax_anlaeg_id <> '' THEN
				CASE
					WHEN WL_Coax_Adgang_Andre_BBOperatoer IN ('Nej', '') and WL_Coax_BB_Styret_afsaetning NOT IN ('Nej', '') THEN 1
					WHEN WL_Coax_Adgang_Andre_BBOperatoer NOT IN ('', 'Nej') and WL_Coax_BB_Styret_afsaetning NOT IN ('Nej', '') THEN 1
					ELSE 0
				END
			WHEN WL_Coax = 1 THEN 1
			ELSE 0
		END
	, TDC_DSL_Enabled =
		CASE
			WHEN BBR_DSL_Mulig_REV = 1 THEN 1
			ELSE 0
		END
	, WS_Fiber_OPERATOER
	, WS_Fiber_Hovedprodukt
	, WS_Coax_OPERATOER
	, WS_XDSL_OPERATOER
	, YS_BB_technology
	, YS_BB_package_name
	, Business_BB_Tech_Fiber
	, Business_BB_Tech_Coax
	, Business_BB_Tech_GSHDSL
	, Business_BB_Tech_XDSL
	, WL_Fiber
	, WL_Coax
	, BL_Coax
	, WLEWII_ejer
	, WL_Coax_Installationsstatus
	, WL_Fiber_digging_length
	, WL_Fiber_kapstik
	, BBR_DSL_Mulig_REV
	, WL_Coax_BB_Styret_afsaetning
	, WS_RAA_KOBBER_OPERATOER

INTO #TEK_STEP1 
FROM dm.InfrastructureBaseData
--LEFT JOIN stage.v_Dim_Anlægsinformation AI
--ON REPLICATE('0', 10-LEN(Al.BBR_Coax_anlaeg_id)) + BBR_Coax_anlaeg_id = AI.BK_Anlægsinformation



SELECT
	TechnologyInstalled = 
		CASE
			WHEN TDC_Fiber_Enabled = 1 AND (WS_FIBER_OPERATOER <> '' OR  YS_BB_technology = 'Fiber' OR Business_BB_Tech_Fiber > 0) THEN 'Fiber'
			WHEN TDC_Fiber_Enabled = 0 AND (WS_FIBER_OPERATOER <> '' OR  YS_BB_technology = 'Fiber' OR Business_BB_Tech_Fiber > 0) THEN 'Fiber On Other Infrastructure'
			WHEN TDC_Coax_Enabled = 1 AND (WS_COAX_OPERATOER <> '' OR YS_BB_technology = 'Coax' OR Business_BB_Tech_Coax > 0) THEN 'Coax'
			WHEN TDC_Coax_Enabled = 0 AND (WS_COAX_OPERATOER <> '' OR YS_BB_technology = 'Coax' OR Business_BB_Tech_Coax > 0) THEN 'Coax On Other Infrastructure'
			WHEN WS_XDSL_OPERATOER <> '' OR YS_BB_technology = 'DSL' OR Business_BB_Tech_GSHDSL > 0 OR Business_BB_Tech_XDSL > 0 OR WS_RAA_KOBBER_OPERATOER <> '' THEN 'DSL'
			ELSE 'No Installation'
		END
	,  BestPossibleTechnology =
		CASE
			WHEN TDC_Fiber_Enabled = 1 THEN  'Fiber'
			WHEN TDC_Coax_Enabled = 1 THEN 'Coax'
			--WHEN TDC_Coax_Enabled_YouseeOnly = 1 THEN 'Coax'
			WHEN TDC_DSL_Enabled = 1 THEN 'DSL Only'
			ELSE 'No TDC Infrastructure'
		END
	, WL_Fiber
	, WL_Coax
	, BL_Coax
	, WLEWII_ejer
	, WL_Coax_Installationsstatus
	, WL_Fiber_kapstik
	, BBR_DSL_Mulig_REV
	, WS_Fiber_Hovedprodukt
	, WL_Coax_BB_Styret_afsaetning
	, WS_XDSL_OPERATOER
	, WS_Fiber_OPERATOER
	, WS_RAA_KOBBER_OPERATOER
	, YS_BB_technology
	, Business_BB_Tech_GSHDSL
	, Business_BB_Tech_XDSL
	, WL_Fiber_digging_length
	, TDC_Coax_Enabled_Wholesale
	, TDC_Coax_Enabled_YouseeOnly
	, TDC_Coax_Enabled
	, Adresse_Kvhx

INTO #TEK_STEP2
FROM #TEK_STEP1 

--LEFT JOIN csv.v_RaaKobber RK
--ON TDC.Adresse_Kvhx = RK.KVH_X

SELECT
	 BestPossibleTechnology 
	 , BestPossibleTechnologyType =
	 CASE 		
			WHEN BestPossibleTechnology = 'Coax' AND TDC_Coax_Enabled_Wholesale = 1 THEN 'Coax'
			WHEN  BestPossibleTechnology = 'Coax' AND TDC_Coax_Enabled_YouseeOnly = 1 THEN 'Coax Yousee Only'
			ELSE BestPossibleTechnology
	END
	, TechnologyInstalled
	, Fiber_GDS_GIG =
		CASE
			WHEN BestPossibleTechnology = 'Fiber' AND WL_Fiber_digging_length IN ('0', '0.00') AND WL_Fiber_kapstik = 'ja' THEN 'GDS'
			WHEN BestPossibleTechnology = 'Fiber' THEN 'GIG'
			ELSE ''
		END
	, Coax_GDS_GIG =
		CASE
			WHEN BestPossibleTechnology = 'Coax'  THEN
			CASE 
				WHEN WL_Coax = 1 and WL_Coax_Installationsstatus = '1' THEN 'GDS'
				WHEN WL_Coax = 1 THEN 'GIG'
				WHEN WL_Coax = 0 and BestPossibleTechnology = 'Coax' THEN 'Yousee Only'
				ELSE ''
			END
			ELSE ''
		END
	
	, DSLType =
		CASE
			WHEN TechnologyInstalled = 'DSL' THEN
				CASE
					WHEN WS_XDSL_OPERATOER <> '' THEN 'EBSA VULA'
					WHEN YS_BB_technology = 'DSL' THEN 'Yousee'
					WHEN Business_BB_Tech_GSHDSL > 0 OR Business_BB_Tech_XDSL > 0 THEN 'TDC Business'
					WHEN WS_RAA_KOBBER_OPERATOER <> '' THEN 'Rå Kobber'
					ELSE ''
				END
			ELSE ''
		END
	, FiberType =
		CASE
			WHEN TechnologyInstalled = 'Fiber' THEN
				CASE
					WHEN WS_Fiber_Hovedprodukt = 'Rå Fiber' THEN 'Raw Fiber'
					ELSE 'FBSA'
				END
			ELSE ''
		END
	, Adresse_Kvhx
	,WS_Fiber_Hovedprodukt

INTO #TEK_STEP3
FROM #TEK_STEP2 




SELECT 

	
	 BestPossibleTechnology = CAST(BestPossibleTechnology as nvarchar(50))
	, TechnologyInstalled = CAST(TechnologyInstalled as nvarchar(50))
	
	, DSLType = CAST(DSLType as nvarchar(20)) 
	, BestPossibleTechnologyType
	,  GIG_GDS_Coax_Fiber =
		CASE
			WHEN TechnologyInstalled = 'DSL' OR TechnologyInstalled = 'No Installation' THEN
				CASE
					 WHEN Fiber_GDS_GIG = 'GDS' AND Coax_GDS_GIG = '' THEN 'Fiber GDS'
					 WHEN Fiber_GDS_GIG = 'GIG' AND Coax_GDS_GIG = '' THEN 'Fiber GIG'
					 WHEN Fiber_GDS_GIG = 'GDS' AND Coax_GDS_GIG = 'GDS' THEN 'Fiber GDS and Coax GDS'
					 WHEN Fiber_GDS_GIG = 'GDS' AND Coax_GDS_GIG = 'GIG' THEN 'Fiber GDS and Coax GIG'
					 WHEN Fiber_GDS_GIG = 'GIG' AND Coax_GDS_GIG = 'GDS' THEN 'Fiber GIG and Coax GDS'
					 WHEN Fiber_GDS_GIG = 'GIG' AND Coax_GDS_GIG = 'GIG' THEN 'Fiber GIG and Coax GIG'
					 WHEN Fiber_GDS_GIG = ''    AND Coax_GDS_GIG = 'GDS' THEN 'Coax GDS'
					 WHEN Fiber_GDS_GIG = ''    AND Coax_GDS_GIG = 'GIG' THEN 'Coax GIG'
					 WHEN Fiber_GDS_GIG = ''    AND Coax_GDS_GIG = 'Yousee Only' THEN 'Coax Yousee'
					 WHEN Fiber_GDS_GIG = 'GDS' AND Coax_GDS_GIG = 'Yousee Only' THEN 'Fiber GDS and Coax Yousee'
					 WHEN Fiber_GDS_GIG = 'GIG' AND Coax_GDS_GIG = 'Yousee Only' THEN 'Fiber GIG and Coax Yousee'
					 ELSE ''
				END 
			WHEN TechnologyInstalled = 'Coax' THEN
				CASE
					WHEN Fiber_GDS_GIG = 'GDS' THEN 'Fiber GDS'
					WHEN Fiber_GDS_GIG = 'GIG' THEN 'Fiber GIG'
					ELSE 'Coax Installed (Not on Fiber Whitelist)'
				END
			ELSE ''
		END
	--, AntalDSLTyper = EBSAVula + RåKobberSubscription + YouseeSubscription + BusinessSubscription
	--, DSLTyperPåAdresse =
	--	CASE
	--		WHEN EBSAVula + RåKobberSubscription + YouseeSubscription + BusinessSubscription = 4 THEN 'EBSA Vula, Rå Kobber, Yousee, Business'
	--		WHEN EBSAVula + RåKobberSubscription + YouseeSubscription = 3 THEN 'EBSA Vula, Rå Kobber, Yousee'
	--		WHEN  EBSAVula + RåKobberSubscription + BusinessSubscription = 3 THEN 'EBSA Vula, Rå Kobber, Business'
	--		WHEN EBSAVula + YouseeSubscription + BusinessSubscription = 3 THEN 'EBSA Vula, Yousee, Business'
	--		WHEN RåKobberSubscription + YouseeSubscription + BusinessSubscription = 3 THEN 'Rå Kobber, Yousee, Business'
	--		WHEN EBSAVula + RåKobberSubscription = 2 THEN 'EBSA Vula, Rå Kobber'
	--		WHEN EBSAVula + YouseeSubscription = 2 THEN 'EBSA Vula, Yousee'
	--		WHEN EBSAVula + BusinessSubscription = 2 THEN 'EBSA Vula, Business'
	--		WHEN RåKobberSubscription + YouseeSubscription = 2 THEN 'Rå Kobber, Yousee'
	--		WHEN RåKobberSubscription + BusinessSubscription = 2 THEN 'Rå Kobber, Business'
	--		WHEN YouseeSubscription + BusinessSubscription = 2 THEN 'Yousee, Business'
	--		ELSE DSLType
	--	END
	, BTO_Fiber =
		CASE
			WHEN WS_Fiber_Hovedprodukt IN ('IPCONNECT FK', 'DEDIKERET FIBER', 'FIBER BTO ACCESS') THEN CAST(1 as nvarchar(1))
			ELSE CAST(0 as nvarchar(1))
		END
	, FiberType
	, Adresse_Kvhx

INTO #TEK_STEP4
FROM #TEK_STEP3 


SELECT 

	 BK_Teknologi = CAST(UPPER(BestPossibleTechnology + '||' + TechnologyInstalled + '||' + GIG_GDS_Coax_Fiber + '||' + DSLType + '||' + BTO_Fiber + '||' + FiberType) as nvarchar(150))
	, BestPossibleTechnology = CAST(BestPossibleTechnology as nvarchar(50))
	, TechnologyInstalled = CAST(TechnologyInstalled as nvarchar(50))
	, GIG_GDS_Coax_Fiber = CAST(GIG_GDS_Coax_Fiber as nvarchar(50))
	, DSLType = CAST(DSLType as nvarchar(20))
	, BestTechSort =
		CASE 
			WHEN BestPossibleTechnology = 'Fiber' THEN CAST(1 as int)
			WHEN BestPossibleTechnology = 'Coax' THEN CAST(2 as int)
			WHEN BestPossibleTechnology = 'DSL Only' THEN CAST(3 as int)
			WHEN BestPossibleTechnology = 'No TDC Infrastructure' THEN CAST(4 as int)
		END
	, TechnologyInstalledSort =
		CASE
			WHEN TechnologyInstalled = 'Fiber' THEN CAST(1 as int)
			WHEN TechnologyInstalled = 'Coax' THEN CAST(2 as int)
			WHEN TechnologyInstalled = 'DSL' THEN CAST(3 as int)
			WHEN TechnologyInstalled = 'No Installation' THEN CAST(4 as int)
			ELSE 5
		END
	, BTO_Fiber
	, FiberType = CAST(FiberType as nvarchar(20))
--	, BestPossibleTechnologyType = CAST(BestPossibleTechnologyType as nvarchar(50))
	, dw_DateTimeLoad = GETDATE()

--INTO [stage].[v_Dim_Teknologi]
FROM #TEK_STEP4 

GROUP BY

	 BestPossibleTechnology
	, TechnologyInstalled
	, GIG_GDS_Coax_Fiber
	, DSLType
	, BTO_fiber
	, FiberType
	--, BestPossibleTechnologyType

IF OBJECT_ID('tempdb.dbo.#TEK_STEP1', 'U') IS NOT NULL   DROP TABLE #TEK_STEP1; --Drop temptable to relieve TEMPDB
IF OBJECT_ID('tempdb.dbo.#TEK_STEP2', 'U') IS NOT NULL   DROP TABLE #TEK_STEP2; --Drop temptable to relieve TEMPDB
IF OBJECT_ID('tempdb.dbo.#TEK_STEP3', 'U') IS NOT NULL   DROP TABLE #TEK_STEP3; --Drop temptable to relieve TEMPDB
IF OBJECT_ID('tempdb.dbo.#TEK_STEP4', 'U') IS NOT NULL   DROP TABLE #TEK_STEP4; --Drop temptable to relieve TEMPDB