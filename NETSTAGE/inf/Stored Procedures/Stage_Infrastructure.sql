
CREATE PROCEDURE [inf].[Stage_Infrastructure] AS


IF OBJECT_ID('tempdb.dbo.#STEP1', 'U') IS NOT NULL   DROP TABLE #STEP1; 
IF OBJECT_ID('tempdb.dbo.#STEP2', 'U') IS NOT NULL   DROP TABLE #STEP2; 
IF OBJECT_ID('tempdb.dbo.#STEP3', 'U') IS NOT NULL   DROP TABLE #STEP3; 
IF OBJECT_ID('tempdb.dbo.#STEP4', 'U') IS NOT NULL   DROP TABLE #STEP4; 
IF OBJECT_ID('tempdb.dbo.#STEP5', 'U') IS NOT NULL   DROP TABLE #STEP5; 
IF OBJECT_ID('tempdb.dbo.#STEP6', 'U') IS NOT NULL   DROP TABLE #STEP6; 
IF OBJECT_ID('tempdb.dbo.#STEP7', 'U') IS NOT NULL   DROP TABLE #STEP7; 
IF OBJECT_ID('tempdb.dbo.#STEP8', 'U') IS NOT NULL   DROP TABLE #STEP8; 
--IF OBJECT_ID('tempdb.dbo.#STEP9', 'U') IS NOT NULL   DROP TABLE #STEP9; 


SELECT --top 1000
adresse_kvhx,
 TDC_Fiber_Enabled =
	CASE
		WHEN WL_Fiber = '1' THEN 1
		ELSE 0
	END

/**********************************************************************************
COAX ENABLED
Jf. dialog med Finn Rosendal Larsen <FIRLA@tdcnet.dk>, defineres TDC_Coax_enabled ved - 
for at være COAX enabled tages udgangspunkt i WL, men nogle har et COAX anlæg, men styret afsætning er nej. Dem defineres ikke, som COAX enabled
Det omhandler anlæg, som vi har adgang til, men ikke kan sælge på. 
AKA hvis der står fx gigabredbånd i afsætning -- RUMI & CAFO 20-05-2020

Udviklingsnote: blanke skal nok nedenfor rettes til NULLS
Mulig løsning, skal testes
	 , TDC_Coax_Enabled =
		CASE
			WHEN BBR_Coax_anlaeg_id <> '' THEN
				CASE
					WHEN ISNULL(WL_Coax_Adgang_Andre_BBOperatoer, '') IN ('Nej', '') and WL_Coax_BB_Styret_afsaetning NOT IN ('Nej', '') THEN 1
					WHEN ISNULL(WL_Coax_Adgang_Andre_BBOperatoer, '') NOT IN ('', 'Nej') and WL_Coax_BB_Styret_afsaetning NOT IN ('Nej', '') THEN 1
					ELSE 0
				END
			WHEN WL_Coax = 1 THEN 1
			ELSE 0
		END
************************************************************************************/
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
	, WS_XDSL_OPERATOER
	, WS_RAA_KOBBER_OPERATOER
	, WS_Coax_OPERATOER
	, WS_Fiber_OPERATOER
	, WS_Fiber_Hovedprodukt
	, YS_BB_technology
	, WL_Fiber_digging_length
	, WL_Fiber_kapstik
	, WL_Coax_Installationsstatus
	, BBR_BbrKode
	, Business_BB_Tech_Fiber
	, Business_BB_Tech_Coax
	, Business_BB_Tech_GSHDSL
	, Business_BB_Tech_XDSL
	, YS_BB_antal
	, WL_Coax
	, BBR_Coax_anlaeg_id
	, HistoryValidDateTimeFrom = ValidFromDatetime
	, HistoryValidDateTimeTo =  
				CASE WHEN ValidToDatetime is NULL then 
						 '9999-12-31 00:00:00.000'
				ELSE DATEADD(day, DATEDIFF(day, 1, ValidToDatetime), '00:00:00')
			END
	
	, ValidToDatetime
	, HistoryCurrentRec = A.IsCurrent
	, HistoryModifiedDate = A.IsDeleted
	, KørselsTidspunkt = CAST(DATEADD(month, DATEDIFF(month, 0,DATEADD(month, -1, GETDATE())), 0) as date)


    , Archetypes_3rd_party																						-- Added 05-02-2020 RUMI
	, WS_Fiber_HASTIGHED																						-- Added 05-02-2020	RUMI
	, WS_Coax_HASTIGHED																							-- Added 05-02-2020	RUMI
	, WS_XDSL_HASTIGHED																							-- Added 05-02-2020	RUMI
	, BBR_DSL_Mulig_REV																							-- Added 05-02-2020	RUMI
	, BBR_MDU_SDU_rev																							-- Added 05-02-2020	RUMI
	, BBR_PB_rev																								-- Added 05-02-2020	RUMI
	, BBR_kobber_downprio_ds																					-- Added 05-02-2020	RUMI
	, BL_Coax																									-- Added 05-02-2020	RUMI
	, WLEWII_ejer																								-- Added 05-02-2020	RUMI
	, YS_BB_package_name
	, A.IsCurrent
	, WL_Coax_KAPGR_Name
	, WL_Coax_BB_Styret_afsaetning
	, WL_Coax_Topgruppekode
	, WL_Coax_sloejfe
	, ad.Fiberudrulning
	, AD.[El-selskab]

INTO #STEP1
FROM dm.InfrastructureBaseDataV2 A
LEFT JOIN stg.Adresse_Inf AD ON AD.TDC_KVHX = A.Adresse_Kvhx
  --LEFT JOIN [csv].[PDSKabling]			P	ON	P.KVHX			= A.Adresse_Kvhx 
  --LEFT JOIN [dm].[Total_utility_Fiber]	E	ON	E.[Kvhx]		= A.Adresse_Kvhx


where A.IsDeleted = 0
--select top 100 * from #STEP1
--/*		FOR TEST PURPOSES		 */
-------------------------------------
--AND
--Adresse_Kvhx IN
--  (
--'1017032043 02TH', '1018636009 03TH', '1470367002 ST0002', '1570827007A01TH', '2694883016', '7872381091', '8514915075B02TV', '1011504020 05TH', '1011519013', '1014236059 01TV'
--)
-------------------------------------
--/*		FOR TEST PURPOSES		 */




SELECT 
	adresse_kvhx
	, TechnologyInstalled = 
		CASE
			WHEN TDC_Fiber_Enabled = 1 AND ((WS_FIBER_OPERATOER NOT IN ('', 'NULL')) OR  YS_BB_technology = 'Fiber' OR Business_BB_Tech_Fiber > 0)  THEN 'Fiber'
			WHEN TDC_Fiber_Enabled = 0 AND ((WS_FIBER_OPERATOER NOT IN ('', 'NULL')) OR  YS_BB_technology = 'Fiber' OR Business_BB_Tech_Fiber > 0) THEN 'Fiber On Other Infrastructure'
			WHEN TDC_Coax_Enabled = 1 AND (WS_COAX_OPERATOER <> '' OR YS_BB_technology = 'Coax' OR Business_BB_Tech_Coax > 0) THEN 'Coax'
			WHEN  TDC_Coax_Enabled = 0 AND (WS_COAX_OPERATOER <> '' OR YS_BB_technology = 'Coax' OR Business_BB_Tech_Coax > 0) THEN 'Coax On Other Infrastructure'
			WHEN WS_XDSL_OPERATOER <> '' OR YS_BB_technology = 'DSL' OR Business_BB_Tech_GSHDSL > 0 OR Business_BB_Tech_XDSL > 0 OR WS_RAA_KOBBER_OPERATOER <> '' THEN 'DSL'
			ELSE 'No Installation'
		END
	, BestPossibleTechnology =
		CASE
			WHEN TDC_Fiber_Enabled = 1 THEN  'Fiber'
			WHEN TDC_Coax_Enabled = 1 THEN 'Coax'
			WHEN TDC_DSL_Enabled = 1 THEN 'DSL Only'
			ELSE 'No TDC Infrastructure'
		END
	, WS_XDSL_OPERATOER
	, WS_RAA_KOBBER_OPERATOER
	, WS_Coax_OPERATOER
	, WS_Fiber_OPERATOER
	, YS_BB_technology
	, Business_BB_Tech_Fiber
	, Business_BB_Tech_Coax
	, Business_BB_Tech_GSHDSL
	, Business_BB_Tech_XDSL
	, BBR_BbrKode
	, YS_BB_antal
	, WL_Fiber_digging_length
	, WL_Fiber_kapstik
	, WL_Coax_Installationsstatus
	, WL_Coax
	, BBR_Coax_anlaeg_id
	, WS_Fiber_Hovedprodukt
	, HistoryValidDateTimeFrom
	, HistoryValidDateTimeTo
	, HistoryCurrentRec
	, KørselsTidspunkt
	, Archetypes_3rd_party																						-- Added 05-02-2020 RUMI
	, WS_Fiber_HASTIGHED																						-- Added 05-02-2020	RUMI
	, WS_Coax_HASTIGHED																							-- Added 05-02-2020	RUMI
	, WS_XDSL_HASTIGHED																							-- Added 05-02-2020	RUMI
	, BBR_DSL_Mulig_REV																							-- Added 05-02-2020	RUMI
	, BBR_MDU_SDU_rev																							-- Added 05-02-2020	RUMI
	, BBR_PB_rev																								-- Added 05-02-2020	RUMI
	, BBR_kobber_downprio_ds																					-- Added 05-02-2020	RUMI
	, BL_Coax																									-- Added 05-02-2020	RUMI
	, WLEWII_ejer																								-- Added 05-02-2020	RUMI
	, YS_BB_package_name
	, TDC_Coax_Enabled_Wholesale	
	, TDC_Coax_Enabled_YouseeOnly 
	, IsCurrent
	, WL_Coax_KAPGR_Name
	, WL_Coax_BB_Styret_afsaetning
	, WL_Coax_Topgruppekode
	, WL_Coax_sloejfe
	, [FiberUdrulning]
	, [El-selskab]

INTO #STEP2
FROM #Step1

IF OBJECT_ID('tempdb.dbo.#STEP1', 'U') IS NOT NULL   DROP TABLE #STEP1; --Drop temptable to relieve TEMPDB

SELECT
	adresse_kvhx
	,TechnologyInstalled
	, Operatør =
	CASE
			WHEN TechnologyInstalled = 'Fiber' OR TechnologyInstalled = 'Fiber On Other Infrastructure' THEN
				CASE 
					WHEN WS_Fiber_OPERATOER <> '' THEN WS_Fiber_OPERATOER
					WHEN YS_BB_technology = 'Fiber' THEN 'YouSee'
					WHEN Business_BB_Tech_Fiber > 0 THEN 'TDC Business'
					ELSE ''
				END
			WHEN TechnologyInstalled = 'Coax' OR TechnologyInstalled = 'Coax On Other Infrastructure' THEN
				CASE
					WHEN WS_Coax_OPERATOER <> '' THEN WS_Coax_OPERATOER
					WHEN YS_BB_technology = 'Coax' THEN 'YouSee'
					WHEN Business_BB_Tech_Coax > 0 THEN 'TDC Business'
					ELSE ''
				END
			WHEN TechnologyInstalled = 'DSL' THEN
				CASE
					WHEN WS_XDSL_OPERATOER <> '' THEN WS_XDSL_OPERATOER
					WHEN YS_BB_technology = 'DSL' THEN 'YouSee'
					WHEN Business_BB_Tech_GSHDSL > 0 OR Business_BB_Tech_XDSL > 0 THEN 'TDC Business'
					WHEN WS_RAA_KOBBER_OPERATOER <> '' then WS_RAA_KOBBER_OPERATOER
					ELSE ''
				END
			ELSE ''
		END
	--, BBR_Type =
	--	CASE
	--		WHEN BBR_BbrKode = 0 THEN 'Ukendt'
	--		WHEN BBR_BbrKode = 1 THEN 'Residential Use'
	--		WHEN BBR_BbrKode = 2 THEN 'Non-Residential Use'
	--		WHEN BBR_BbrKode = 3 THEN 'Leisure-Time Use'
	--		ELSE ''
	--	END
	,BBR_BbrKode
	, YS_BB_antal
	, WS_XDSL_OPERATOER
	,	BTO_Fiber =
		CASE
			WHEN WS_Fiber_Hovedprodukt IN ('IPCONNECT FK', 'DEDIKERET FIBER', 'FIBER BTO ACCESS') THEN CAST(1 as nvarchar(1))
			ELSE CAST(0 as nvarchar(1))
		END
	, WS_RAA_KOBBER_OPERATOER
	, WS_Coax_OPERATOER
	, WS_Fiber_OPERATOER
	,  FiberType =
		CASE
			WHEN TechnologyInstalled = 'Fiber' THEN
				CASE
					WHEN WS_Fiber_Hovedprodukt = 'Rå Fiber' THEN 'Raw Fiber'
					ELSE 'FBSA'
				END
			ELSE ''
		END
	, YS_BB_technology
	, BestPossibleTechnology
	, WL_Fiber_digging_length
	, WL_Fiber_kapstik
	, WL_Coax_Installationsstatus
	, WL_Coax
	, Business_BB_Tech_Fiber
	, Business_BB_Tech_Coax
	, Business_BB_Tech_GSHDSL
	, Business_BB_Tech_XDSL
	, BBR_Coax_anlaeg_id
	, HistoryValidDateTimeFrom
	, HistoryValidDateTimeTo
	, CAST(HistoryValidDateTimeFrom as varchar(50)) as HistoryVARCHAR
	, HistoryCurrentRec
	, KørselsTidspunkt

	, Archetypes_3rd_party																						-- Added 05-02-2020 RUMI
	, WS_Fiber_HASTIGHED																						-- Added 05-02-2020	RUMI
	, WS_Coax_HASTIGHED																							-- Added 05-02-2020	RUMI
	, WS_XDSL_HASTIGHED																							-- Added 05-02-2020	RUMI
	, BBR_DSL_Mulig_REV																							-- Added 05-02-2020	RUMI
	, MDU_SDU = 
		CASE 
			WHEN BBR_MDU_SDU_rev > 4 THEN 'MDU'
			ELSE 'SDU'
		END
	, BBR_PB_rev
	, Mulig_Kobber_Download_Hastighed = BBR_kobber_downprio_ds
	, BL_Coax																									-- Added 05-02-2020	RUMI
	, EWII_Whitelist = 
		CASE
			WHEN WLEWII_ejer <> '' THEN 1
			ELSE 0
		END
	, YS_BB_package_name
	, TDC_Coax_Enabled_Wholesale	
	, TDC_Coax_Enabled_YouseeOnly 
	, BBR_kobber_downprio_ds
	, IsCurrent
	, WL_Coax_KAPGR_Name
	, WL_Coax_BB_Styret_afsaetning
	, WL_Coax_Topgruppekode
	, WL_Coax_sloejfe
	, [FiberUdrulning]
	, [El-selskab]

INTO #STEP3
FROM #STEP2

IF OBJECT_ID('tempdb.dbo.#STEP2', 'U') IS NOT NULL   DROP TABLE #STEP2; --Drop temptable to relieve TEMPDB


SELECT
	Adresse_Kvhx
	, LaterHistoryValidTimeFrom = LEAD(HistoryVARCHAR,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	, ServiceProvider = 	
		CASE
			WHEN SP.Operatør = 'YouSee' THEN CAST('YouSee' as nvarchar(50))
			WHEN Operatør = 'TDC Business' THEN CAST('TDC Business' as nvarchar(50))
			ELSE CAST(SP2.[Service Provider] as nvarchar(50))
		END
	, PriorServiceProvider = LAG(
		CASE
			WHEN SP.Operatør = 'YouSee' THEN CAST('YouSee' as nvarchar(50))
			WHEN Operatør = 'TDC Business' THEN CAST('TDC Business' as nvarchar(50))
			ELSE CAST(SP2.[Service Provider] as nvarchar(50))
		END
		,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	, Operator =
		CASE
			WHEN SP.Operatør = 'YouSee' THEN CAST('YouSee' as nvarchar(50))
			WHEN Operatør = 'TDC Business' THEN CAST('TDC Business' as nvarchar(50))
			ELSE CAST(Operatør as nvarchar(50))
		END
	, PriorOperator = LAG(
		CASE
			WHEN SP.Operatør = 'YouSee' THEN CAST('YouSee' as nvarchar(50))
			WHEN Operatør = 'TDC Business' THEN CAST('TDC Business' as nvarchar(50))
			ELSE CAST(operatør as nvarchar(50))
		END
		,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
		
	, TechnologyInstalled
	, PriorTechnologyInstalled = LAG(TechnologyInstalled,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	--, PriorTechnologyInstalledTwoMonths = LAG(TechnologyInstalled,2,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	--, PriorTechnologyInstalledThreeMonths = LAG(TechnologyInstalled,3,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	, BestPossibleTechnology
	, PriorBestPossibleTechnology = LAG(BestPossibleTechnology,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	, BTO_Fiber
	, PRIORBTO_Fiber = LAG(BTO_Fiber,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	, FiberType
	, PriorFiberType = LAG(FiberType, 1, 0) OVER (PARTITION BY Adresse_kvhx ORDER BY historyvaliddatetimefrom)
	, BBR_BbrKode
	, YS_BB_antal
	, Prior_YS_BB_Antal = LAG(YS_BB_antal,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	, PRIOR_WS_XDSL_OPERATOER = LAG(WS_XDSL_OPERATOER,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	,PRIOR_WS_RAA_KOBBER_OPERATOER = LAG(WS_RAA_KOBBER_OPERATOER,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	, PRIOR_Business_BB_Tech_GSHDSL = LAG(Business_BB_Tech_GSHDSL,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	, PRIOR_Business_BB_Tech_XDSL = LAG(Business_BB_Tech_XDSL,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
		, WS_XDSL_OPERATOER
	, WS_RAA_KOBBER_OPERATOER
	, WS_Coax_OPERATOER
	, WS_Fiber_OPERATOER
	, WL_Fiber_digging_length
	, WL_Fiber_kapstik
	, WL_Coax_Installationsstatus
	, WL_Coax
	, YS_BB_technology
	, Business_BB_Tech_Fiber
	, Business_BB_Tech_Coax
	, Business_BB_Tech_GSHDSL
	, Business_BB_Tech_XDSL
	, BBR_Coax_anlaeg_id
	, HistoryValidDateTimeFrom
	, HistoryValidDateTimeTo 
	, HistoryCurrentRec
	, KørselsTidspunkt

	, WS_Fiber_HASTIGHED
	, WS_Coax_HASTIGHED
	, WS_XDSL_HASTIGHED
	, EWII_Whitelist
	, BL_Coax
	, Archetypes_3rd_party
	, YS_BB_package_name
	, BBR_PB_rev

	, TDC_Coax_Enabled_Wholesale	
	, TDC_Coax_Enabled_YouseeOnly 
	, BBR_kobber_downprio_ds
	, IsCurrent
	, WL_Coax_KAPGR_Name
	, WL_Coax_BB_Styret_afsaetning
	, WL_Coax_Topgruppekode
	, WL_Coax_sloejfe
	, [FiberUdrulning]
	, [El-selskab]

INTO #STEP4
FROM #STEP3 SP
LEFT JOIN (
SELECT [Fiber Operatør], [Service Provider]
FROM EDW_Stage.csv.ServiceProviders



GROUP BY [Fiber Operatør], [Service Provider]) SP2
ON SP.Operatør = SP2.[Fiber Operatør]




IF OBJECT_ID('tempdb.dbo.#STEP3', 'U') IS NOT NULL   DROP TABLE #STEP3; --Drop temptable to relieve TEMPDB



SELECT 
	Adresse_Kvhx
, BBR_BbrKode
, LaterHistoryValidTimeFrom = CASE
									WHEN LaterHistoryValidTimeFrom = '0' THEN NULL
									ELSE LaterHistoryValidTimeFrom
								END  
, PriorTechnologyInstalled =
		CASE
			WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.000' THEN TechnologyInstalled
			ELSE PriorTechnologyInstalled
		END
	, TechnologyInstalled
	, Operator 
	, PriorOperator =
		CASE
			WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.000' THEN Operator 
			ELSE PriorOperator
		END
	, ServiceProvider
	, PriorServiceProvider = 
		CASE
			WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.000' THEN ServiceProvider 
			ELSE PriorServiceProvider
		END
	, BestPossibleTechnology
	, PriorBestPossibleTechnology = 
		CASE
			WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.000' THEN BestPossibleTechnology
			ELSE PriorBestPossibleTechnology
		END
	, MovementType =
		CASE
			WHEN TechnologyInstalled = 'DSL' AND PriorTechnologyInstalled IN ('Coax', 'Fiber')
			THEN
				CASE
					WHEN PriorServiceProvider = 'Yousee' and ServiceProvider = 'Yousee'
					THEN 
						CASE
							WHEN PRIOR_YS_BB_antal > YS_BB_antal THEN 'Nedgradering'
							WHEN PRIOR_YS_BB_antal = YS_BB_antal THEN 'Kundevandring'
						END
					ELSE
						CASE
							WHEN (WS_XDSL_OPERATOER = PRIOR_WS_XDSL_OPERATOER AND WS_XDSL_OPERATOER <> '')
							OR (WS_RAA_KOBBER_OPERATOER = PRIOR_WS_RAA_KOBBER_OPERATOER AND WS_RAA_KOBBER_OPERATOER <> '')
							OR PRIOR_Business_BB_Tech_GSHDSL > 0
							OR PRIOR_Business_BB_Tech_XDSL > 0
							THEN 'Nedgradering'
							ELSE 'Kundevandring'
						END
				END
			WHEN (TechnologyInstalled <> 'No Installation' AND PriorTechnologyInstalled = 'No Installation') OR (PriorTechnologyInstalled = '0' AND HistoryValidDateTimeFrom <> '2019-05-01 00:00:00.000' AND TechnologyInstalled <> 'No Installation') THEN 'Nytilgang'
			WHEN TechnologyInstalled = 'No Installation' AND PriorTechnologyInstalled NOT IN ('No Installation', '0') THEN 'Churn'
			WHEN TechnologyInstalled <> PriorTechnologyInstalled and PriorTechnologyInstalled <> '0' THEN 'Kundevandring'
			WHEN Operator <> PriorOperator and PriorOperator <> '0' THEN 'Kundevandring'
			ELSE 'Non-Movement'
		END

	, Fiber_GDS_GIG =
		CASE
			WHEN BestPossibleTechnology = 'Fiber' AND WL_Fiber_digging_length IN ('0','0.00') AND WL_Fiber_kapstik = 'ja' THEN 'GDS'
			WHEN BestPossibleTechnology = 'Fiber' THEN 'GIG'
			ELSE ''
		END
	, Coax_GDS_GIG =
		CASE
			WHEN BestPossibleTechnology = 'Coax' THEN
			CASE 
				WHEN WL_Coax = 1 and WL_Coax_Installationsstatus = '1' THEN 'GDS'
				WHEN WL_Coax = 1 THEN 'GIG'
				WHEN WL_Coax = 0 and BestPossibleTechnology = 'Coax' THEN 'Yousee Only'
				ELSE ''
			END
			ELSE ''
		END
	, F_Movement = --select * from #step4
		CASE 
						WHEN ltrim(rtrim(PriorTechnologyInstalled)) = '0' THEN 0
			ELSE

				CASE 
					WHEN (ltrim(rtrim(PriorTechnologyInstalled)) <> ltrim(rtrim(TechnologyInstalled)) OR  ltrim(rtrim(PriorOperator)) <> ltrim(rtrim(Operator)))
						 AND 
						 (ltrim(rtrim(PriorTechnologyInstalled)) <> '0' OR (ltrim(rtrim(PriorTechnologyInstalled)) = '0' and ltrim(rtrim(TechnologyInstalled)) <> 'No Installation'))
					THEN 1
					ELSE 0
				END
		END
	, RowSelection =
				CASE	
					when
						PriorServiceProvider = '0' or PriorOperator = '0' 
						or LaterHistoryValidTimeFrom = '0'
						or ServiceProvider != PriorServiceProvider or operator != PriorOperator THEN 1
					else 0
				end
	, RowSelectionDate =
				CASE	
					when
							datediff(month, HistoryValidDateTimeFrom, HistoryValidDateTimeTo) >  1 then 1
					else 0
				end						
			
	, WS_XDSL_OPERATOER
	, WS_RAA_KOBBER_OPERATOER
	, BTO_Fiber
	, PRIORBTO_Fiber
	, FiberType
	, PriorFiberType
	, YS_BB_technology
	, YS_BB_package_name
	, Business_BB_Tech_GSHDSL
	, Business_BB_Tech_XDSL
	, BBR_Coax_anlaeg_id
	, HistoryValidDateTimeFrom
	, HistoryValidDateTimeTo
	, HistoryCurrentRec
	, Kørselstidspunkt
	, HistoryValidDateTimeFromMonth = CAST(YEAR(HistoryValidDateTimeTo) as nvarchar(4)) + '-' + CASE
					WHEN
					LEN(MONTH(HistoryValidDateTimeTo)) = 1 THEN '0'+ CAST(MONTH(HistoryValidDateTimeTo) as nvarchar(2))
					ELSE CAST(MONTH(HistoryValidDateTimeTo) as nvarchar(2))
				END + '-01'

	, WS_Fiber_HASTIGHED
	, WS_Coax_HASTIGHED
	, WS_XDSL_HASTIGHED
	, EWII_Whitelist
	, BL_Coax
	, WL_Coax
	, Archetypes_3rd_party
	, BBR_PB_rev
	, TDC_Coax_Enabled_Wholesale	
	, TDC_Coax_Enabled_YouseeOnly 
	, BBR_kobber_downprio_ds
	, IsCurrent
	, WL_Coax_KAPGR_Name
	, WL_Coax_BB_Styret_afsaetning
	, WL_Coax_Topgruppekode
	, WL_Coax_sloejfe
	, [FiberUdrulning]
	, [El-selskab] 

INTO #STEP5
FROM #STEP4




IF OBJECT_ID('tempdb.dbo.#STEP4', 'U') IS NOT NULL   DROP TABLE #STEP4; --Drop temptable to relieve TEMPDB


SELECT 
	Adresse_Kvhx
	, BBR_BbrKode
	, PriorTechnologyInstalled  
	, TechnologyInstalled
	, PriorOperator
	, Operator
	, PriorServiceProvider
	, ServiceProvider
	, PriorBestPossibleTechnology
	, BestPossibleTechnology
	, MovementType
--	, ChurnLag =  LAG(MovementType,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom asc)
					
	, HistoryValidDateTimeFrom 
	, LaterHistoryValidTimeFrom
	, HistoryValidDateTimeTo
	, HistoryCurrentRec
	, GIG_GDS_Coax_Fiber =
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
	--, F_Movement
	--, F_Movement_LAG1 = LAG(F_Movement,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	, Non_Movement_Extra_Row =
		CASE
			WHEN F_Movement = 1
			AND DATEDIFF(month, HistoryValidDateTimeFrom, HistoryValidDateTimeTo) >= 1 
			AND MovementType <> 'Non-Movement'
		  AND CAST(HistoryValidDateTimeFrom as date) <> KørselsTidspunkt
			THEN 1
			ELSE 0
		END
	--, 
	, BBR_Coax_anlaeg_id
	, KørselsTidspunkt
		, BTO_Fiber
	, PRIORBTO_Fiber
	, FiberType
	, PriorFiberType
	, BestPossibleTechnologyType =
	 CASE 		
			WHEN BestPossibleTechnology = 'Coax' AND	TDC_Coax_Enabled_Wholesale	= 1 THEN 'Coax'
			WHEN  BestPossibleTechnology = 'Coax' AND	TDC_Coax_Enabled_YouseeOnly = 1 THEN 'Coax Yousee Only'
			ELSE BestPossibleTechnology
	END
	, Mulig_Kobber_Download_Hastighed	=				BBR_kobber_downprio_ds
	, Mulig_Pairbonding					=				BBR_PB_rev
	, WS_Fiber_HASTIGHED
	, WS_Coax_HASTIGHED
	, WS_XDSL_HASTIGHED
	, EWII_Whitelist
	, BL_Coax
	, WL_Coax
	, Archetypes_3rd_party
	, YS_BB_package_name
	, IsCurrent

	, WL_Coax_KAPGR_Name
	, WL_Coax_BB_Styret_afsaetning
	, WL_Coax_Topgruppekode
	, WL_Coax_sloejfe
	, [FiberUdrulning]
	, [El-selskab]
		, RowSelection, RowSelectionDate
INTO #STEP6
FROM #STEP5 
--where 	 RowSelection = 1 or RowSelectionDate = 1

IF OBJECT_ID('tempdb.dbo.#STEP5', 'U') IS NOT NULL   DROP TABLE #STEP5; --Drop temptable to relieve TEMPDB

--select * from #step6  order by adresse_kvhx
--select * from #STEP7 order by adresse_kvhx
SELECT * INTO #STEP7 FROM( 
SELECT
	  Adresse_Kvhx
	, BBR_BbrKode
	, PriorTechnologyInstalled
	, TechnologyInstalled
	, PriorOperator
	, Operator
	, PriorServiceProvider 
	, ServiceProvider
	, PriorBestPossibleTechnology
	, BestPossibleTechnology
	, MovementType
--	, ChurnLag
	, HistoryValidDateTimeFrom 
	, HistoryValidDateTimeTo =
								CASE
									WHEN Non_Movement_Extra_Row = 1 THEN HistoryValidDateTimeFrom
									ELSE HistoryValidDateTimeTo
								END
	, HistoryCurrentRec
	, GIG_GDS_Coax_Fiber
	, DSLType
	, BTO_Fiber
	, PRIORBTO_Fiber
	, FiberType
	, PriorFiberType
	, BBR_Coax_anlaeg_id
	--, F_Movement
	--, F_Movement_LAG1
	, Non_Movement_Extra_Row
	, Newrowadded = 0
	, Mulig_Kobber_Download_Hastighed
	, Mulig_Pairbonding
	, WS_Fiber_HASTIGHED
	, WS_Coax_HASTIGHED
	, WS_XDSL_HASTIGHED
	, BestPossibleTechnologyType
	, EWII_Whitelist
	, BL_Coax
	, WL_Coax
	, Archetypes_3rd_party
	, YS_BB_package_name
	, IsCurrent
	, WL_Coax_KAPGR_Name
	, WL_Coax_BB_Styret_afsaetning
	, WL_Coax_Topgruppekode
	, WL_Coax_sloejfe
	, [FiberUdrulning]
	, [El-selskab]

FROM #STEP6

UNION ALL

SELECT 
	Adresse_Kvhx
	, BBR_BbrKode
	, PriorTechnologyInstalled = TechnologyInstalled
	, TechnologyInstalled
	, PriorOperator = Operator
	, Operator
	, PriorServiceProvider = ServiceProvider
	, ServiceProvider
	, PriorBestPossibleTechnology = BestPossibleTechnology
	, BestPossibleTechnology
	, MovementType = 'Non-Movement'
--	, ChurnLag = 'No Churn'
	, HistoryValidDateTimeFrom = DATEADD(Month, 1, HistoryValidDateTimeFrom)
	, HistoryValidDateTimeTo
	, HistoryCurrentRec
	, GIG_GDS_Coax_Fiber
	, DSLType
	, BTO_Fiber
	, PRIORBTO_Fiber = BTO_Fiber
	, FiberType
	, PriorFiberType = FiberType
	, BBR_Coax_anlaeg_id
	--, F_Movement
	--, F_Movement_LAG1
	, Non_Movement_Extra_Row
	, Newrowadded = 1
	, Mulig_Kobber_Download_Hastighed
	, Mulig_Pairbonding
	, WS_Fiber_HASTIGHED
	, WS_Coax_HASTIGHED
	, WS_XDSL_HASTIGHED
	, BestPossibleTechnologyType
	, EWII_Whitelist
	, BL_Coax
	, WL_Coax
	, Archetypes_3rd_party
	, YS_BB_package_name
	, IsCurrent
	, WL_Coax_KAPGR_Name
	, WL_Coax_BB_Styret_afsaetning
	, WL_Coax_Topgruppekode
	, WL_Coax_sloejfe
	, [FiberUdrulning]
	, [El-selskab]

FROM #STEP6
where Non_Movement_Extra_Row = 1
) as tmp

IF OBJECT_ID('tempdb.dbo.#STEP6', 'U') IS NOT NULL   DROP TABLE #STEP6; --Drop temptable to relieve TEMPDB



SELECT
	Adresse_Kvhx
	, BBR_BbrKode
	, PriorTechnologyInstalled
	, TechnologyInstalled
	, PriorTechnologyTwoTimeLag = LAG(PriorTechnologyInstalled,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom asc) 
	, PriorOperator
	, PriorOperatorTwoTimeLag = LAG(PriorOperator,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom asc) 
	, Operator
	, PriorServiceProvider
	, ServiceProvider
	, PriorBestPossibleTechnology
	, BestPossibleTechnology
	, F_Churn =
		CASE
			WHEN MovementType = 'Churn' THEN 1
			ELSE 0
		END	


	, ChurnTwoPeriodLag =  
				CASE WHEN 
					LAG(MovementType,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom asc) = 'Churn' Then 'TwoPeriodChurn'
					Else 'No-Churn'
				END
	, BK_FromTeknologi = 
			CAST(UPPER(PriorBestPossibleTechnology + '||' + PriorTechnologyInstalled + '||' +
				CASE
					WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.000' THEN GIG_GDS_Coax_Fiber
					ELSE LAG(GIG_GDS_Coax_Fiber,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
				END
				 + '||' +
				 CASE
					WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.000' THEN DSLType
					ELSE LAG(DSLType,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
				END
				+ '||' + 
				CASE
					WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.000' THEN BTO_Fiber
					ELSE LAG(BTO_Fiber,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
				END
			   + '||' + 
			 CASE
					WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.000' THEN FiberType
					ELSE LAG(FiberType,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
				END) as nvarchar(250))
	, HistoryValidDateTimeFrom
	, HistoryValidDateTimeTo = 
			CASE
				WHEN MovementType <> 'Non-Movement' and LEAD(MovementType,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom) = 'Non-Movement'
				THEN HistoryValidDateTimeFrom
				ELSE HistoryValidDateTimeTo
			END
	, HistoryCurrentRec = 
		CASE
				WHEN MovementType <> 'Non-Movement' and LEAD(MovementType,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom) = 'Non-Movement'
				THEN 0
				ELSE HistoryCurrentRec
			END
	, GIG_GDS_Coax_Fiber
	, DSLType
	, BTO_Fiber
	, PRIORBTO_Fiber
	, FiberType
	, PriorFiberType
	, BBR_Coax_anlaeg_id
	--, F_Movement
	--, F_Movement_LAG1
	, Non_Movement_Extra_Row
	, Newrowadded
	, MovementType
	, M_DSLChurn = 
		CASE
			WHEN PriorTechnologyInstalled = 'DSL' AND TechnologyInstalled = 'No Installation' THEN 1
			ELSE 0
		END
	, F_Movement = 
		CASE
			WHEN MovementType <> 'Non-Movement' THEN 1
			ELSE 0
		END
	, F_Nytilgang =
		CASE
			WHEN MovementType = 'Nytilgang' THEN 1
			ELSE 0
		END
	, F_Kundevandring = 
		CASE	
			WHEN MovementType = 'Kundevandring' THEN 1
			ELSe 0
		END
	, F_Nedgradering = 
		CASE
			WHEN MovementType = 'Nedgradering' THEN 1
			ELSE 0
		END
	
	, Mulig_Kobber_Download_Hastighed = CAST(Mulig_Kobber_Download_Hastighed as numeric(18,0)) 
	, Mulig_Kobber_Download_Hastighed_m_Pairbonding =
		CASE
			WHEN Mulig_Pairbonding = 'PB' THEN CAST(Mulig_Kobber_Download_Hastighed as numeric(18,0))  * 2
			ELSE Mulig_Kobber_Download_Hastighed
		END


	, Produktområde = 
		CASE
			WHEN Operator = 'YouSee' THEN 'YouSee'
			WHEN Operator = 'TDC Business' THEN 'TDC Business'
			WHEN Operator <> '' THEN 'Wholesale'
			ELSE ''
		END
	, Produktnavn =
		CASE
			WHEN Operator = 'YouSee' THEN YS_BB_package_name
			WHEN Operator = 'TDC Business' THEN 'TDC Business'
			WHEN Operator <> '' THEN 
				CASE
					WHEN TechnologyInstalled = 'Fiber' THEN	 WS_Fiber_HASTIGHED
					WHEN TechnologyInstalled = 'Coax' THEN	 WS_Coax_HASTIGHED
					WHEN TechnologyInstalled = 'DSL' THEN	 WS_XDSL_HASTIGHED
				END
			ELSE ''
		END
	
	, Mulig_Pairbonding = 
		CASE 
			WHEN Mulig_Pairbonding = 'PB' THEN 1
			ELSE 0
		END
	, DSLOnly =
		CASE
			WHEN BestPossibleTechnology = 'DSL Only' THEN 1
			ELSE 0
		END
	, NoInfrastructure =
		CASE 
			WHEN BestPossibleTechnology = 'No TDC Infrastructure' THEN 1
			ELSE 0
		END
	, FiberInstalled =
		CASE
			WHEN TechnologyInstalled = 'Fiber' THEN 1
			ELSE 0
		END	, FiberInstalledOnOTherInfrastructure =
		CASE
			WHEN TechnologyInstalled = 'Fiber On Other Infrastructure' THEN 1
			ELSE 0
		END
	, CoaxInstalled =
		CASE
			WHEN TechnologyInstalled = 'Coax' THEN 1
			ELSE 0
		END
	, CoaxInstalledOnOTherInfrastructure =
		CASE
			WHEN TechnologyInstalled = 'Coax On Other Infrastructure' THEN 1
			ELSE 0
		END
	, DSLInstalled = 
		CASE
			WHEN TechnologyInstalled = 'DSL' THEN 1
			ELSE 0
		END
	, NoInstallation = 
		CASE
			WHEN TechnologyInstalled = 'No Installation' THEN 1
			ELSE 0
		END
	
	, HasSubscription = 
		CASE 
			WHEN TechnologyInstalled <> 'No Installation' THEN 1
			ELSE 0
		END
	, FiberBestPossbile =
		CASE 
			WHEN BestPossibleTechnology = 'Fiber' THEN 1
			ELSE 0
		END
	, CoaxBestPossible_WS_YS = 
		CASE
		  WHEN BestPossibleTechnology = 'Coax' THEN 1 
		  ELSE 0
		END
	, CoaxYouseeBestPossible = 
		CASE
			WHEN BestPossibleTechnologyType = 'Coax Yousee Only' THEN 1
			ELSE 0
		END

	, EWII_Whitelist =		EWII_Whitelist
	, BL_Coax =					BL_Coax
	, WL_Coax =					WL_Coax
	, Archetypes_3rd_party =	Archetypes_3rd_party
	, IsCurrent	
	, WL_Coax_KAPGR_Name
	, WL_Coax_BB_Styret_afsaetning
	, WL_Coax_Topgruppekode
	, WL_Coax_sloejfe
	, [FiberUdrulning]
	, [El-selskab]

INTO #STEP8
FROM #STEP7



--WHERE 	Adresse_Kvhx IN
--  (
--    '1010004007 STTH', '1010108009B05TH', '1010108140 03TH', '1010108194 ST', '1010112025 03TV'
--  )

IF OBJECT_ID('tempdb.dbo.#STEP7', 'U') IS NOT NULL   DROP TABLE #STEP7; --Drop temptable to relieve TEMPDB

TRUNCATE TABLE [stg].[Infrastructure]
INSERT INTO [stg].[Infrastructure]
--select top 1000 *  from #STEP8
SELECT
	BK_TDC_KVHX = CAST(Adresse_Kvhx as nvarchar(20))
	, BK_AnlægsinformationID = CAST(BBR_Coax_anlaeg_id as nvarchar(50))
	, BK_BBRType = CAST(BBR_BbrKode as nvarchar(1))
	, BK_FromTeknologiLag = LAG(BK_FromTeknologi,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	, BK_FromTeknologi
	, BK_ToTeknologi = CAST(UPPER(BestPossibleTechnology + '||' + TechnologyInstalled + '||' + GIG_GDS_Coax_Fiber + '||' + DSLType + '||' + BTO_Fiber + '||' + FiberType) as nvarchar(250))
	, BK_FromOperator = CAST(UPPER(PriorOperator + '||' + PriorTechnologyInstalled) as nvarchar(150))
	, BK_FromOperatorTwoTimeLag = CAST(UPPER(PriorOperatorTwoTimeLag + '||' + PriorTechnologyTwoTimeLag) as nvarchar(150))	
	, BK_ToOperator = CAST(UPPER(Operator + '||' + TechnologyInstalled) as nvarchar(150))
	
	, BK_Tredjepartsinfrastruktur = CAST(Archetypes_3rd_party as nvarchar(50))

	, BK_Movement = CAST(MovementType as nvarchar(20))
	, BK_DateFrom = CAST(HistoryValidDateTimeFrom as date)
	, BK_DateTo = 
	 CAST(HistoryValidDateTimeTo as Date)
	, FromToDate_Key = 
		 CAST(
			CAST(YEAR(HistoryValidDateTimeFrom) as nvarchar(4)) + 
			CASE 
				WHEN LEN(MONTH(HistoryValidDateTimeFrom)) < 2 THEN '0' + CAST(MONTH(HistoryValidDateTimeFrom) as nvarchar(2))
				ELSE CAST(MONTH(HistoryValidDateTimeFrom) as nvarchar(2))
			END +
		 CAST(YEAR(HistoryValidDateTimeTo) as nvarchar(4)) + 
			CASE 
				WHEN LEN(MONTH(HistoryValidDateTimeTo)) < 2 THEN '0' + CAST(MONTH(HistoryValidDateTimeTo) as nvarchar(2))
				ELSE CAST(MONTH(HistoryValidDateTimeTo) as nvarchar(2))
			END
			 as nvarchar(20))
	, BK_Produkt = CAST(UPPER(#STEP8.Produktnavn + '||' + #STEP8.Produktområde) as nvarchar(300))
	 , F_Movement = F_Movement
	, F_Churn = F_Churn
	 ,[ChurnCategoryDSL] = 
			CASE
				WHEN F_Churn = 1	AND		BestPossibleTechnology = 'DSL Only'		THEN 1
				ELSE '0'																	 
			END																				 
	  ,[ChurnCategoryCoax] = 																 
			CASE																			 
				WHEN F_Churn = 1	AND		BestPossibleTechnology = 'Coax'			THEN 1
				ELSE '0'																	 
			END																				 
	 ,[ChurnCategoryFiber] = 																 
			CASE																			 
				WHEN F_Churn = 1	AND		BestPossibleTechnology = 'Fiber'			THEN 1
				ELSE '0'																	 
			END																				 
	 ,[ChurnCategoryUtility] = 																 
			CASE																			 
				WHEN F_Churn = 1	AND		FiberUdrulning = 1						THEN 1
				ELSE '0'																	 
			END																				
	,[ChurnCategoryUdrulning] = 																 
			CASE																			 
				WHEN F_Churn = 1	AND		[El-selskab] is not null						THEN 1
				ELSE '0'
			END
	,[ChurnCategory] = 
			CASE
				WHEN F_Churn = 1	AND		(BestPossibleTechnology = 'Fiber' or FiberUdrulning = 1)	THEN 'Fiber'
				WHEN F_Churn = 1	AND		[El-selskab]					is not null							THEN 'Utility'
				WHEN F_Churn = 1	AND		BestPossibleTechnology = 'Coax'								THEN 'Coax'
				WHEN F_Churn = 1	AND		BestPossibleTechnology = 'DSL Only'							THEN 'DSL'
				ELSE '0'
			END
	, F_ChurnTwoTimeLag = 
		CASE 
			WHEN ChurnTwoPeriodLag = 'TwoPeriodChurn' THEN 1
			ELSE 0
		END

	, F_Nytilgang = F_Nytilgang
	, F_Kundevandring = F_Kundevandring
	, F_Nedgradering = F_Nedgradering
	, M_DSLChurn = 
		CASE
			WHEN PriorTechnologyInstalled = 'DSL' AND TechnologyInstalled = 'No Installation' THEN 1
			ELSE 0
		END
	, M_DSLNewCustomer = 
		CASE
			WHEN PriorTechnologyInstalled IN ('No Installation', 'Unknown') AND TechnologyInstalled = 'DSL' THEN 1
			ELSE 0
		END
	, M_DSLUpgradeToCoax =
		CASE
			WHEN PriorTechnologyInstalled = 'DSL' AND TechnologyInstalled = 'Coax' THEN 1
			ELSE 0
		END
	, M_DSLDowngradeFromCoax =
		CASE
			WHEN PriorTechnologyInstalled = 'Coax' AND TechnologyInstalled = 'DSL' THEN 1
			ELSE 0
		END	
	, M_DSLUpgradeToFiber =
		CASE
			WHEN PriorTechnologyInstalled = 'DSL' AND TechnologyInstalled = 'Fiber' THEN 1
			ELSE 0
		END
	, M_DSLDowngradeFromFiber =
		CASE
			WHEN PriorTechnologyInstalled = 'Fiber' AND TechnologyInstalled = 'DSL' THEN 1
			ELSE 0
		END	

	, FiberInstalled 
	, FiberInstalledOnOTherInfrastructure
	, CoaxInstalled
	, CoaxInstalledOnOTherInfrastructure
	, DSLInstalled
	, NoInstallation
	, HasSubscription
	, FiberBestPossbile
	, CoaxBestPossible_WS_YS
	, CoaxYouseeBestPossible
	, NoInfrastructure
	, EWII_Whitelist
	, Mulig_Kobber_Download_Hastighed
	, Mulig_Kobber_Download_Hastighed_m_Pairbonding
	, Mulig_Pairbonding 
--	, DownloadHastighed_KB = CAST(P.DownloadHastighed_KB as numeric(23,1))
	, Blacklist_Coax = CAST(BL_Coax as int) 
	, Whitelist_Coax = CAST(WL_Coax as int)
	--, U.[El-selskab]
	, IsCurrent
	, WL_Coax_KAPGR_Name
	, WL_Coax_BB_Styret_afsaetning
	, WL_Coax_Topgruppekode
	, WL_Coax_sloejfe
	--, [FiberUdrulning]
	--, [El-selskab]




--Drop Table [stg].[Infrastructure]
--INTO [stg].[Infrastructure]
FROM #STEP8
--LEFT JOIN edw.edw.Dim_Produkt P 
--ON UPPER(#STEP8.Produktnavn + '||' + #STEP8.Produktområde) = P.BK_Produkt
--Left join DataMart.[dbo].[Total_utility_Fiber_tbl] U on U.KVHX = B.[Adresse_Kvhx]
--)




-- IF OBJECT_ID('tempdb.dbo.#STEP8', 'U') IS NOT NULL   DROP TABLE #STEP8; --Drop temptable to relieve TEMPDB
-- IF OBJECT_ID('tempdb.dbo.#STEP9', 'U') IS NOT NULL   DROP TABLE #STEP9; 