


CREATE VIEW [stage].[v_Fact_Bredbånd] AS

WITH TDCNetwork AS (
SELECT
	Adresse_Vejnavn
	, Adresse_Husnummertal
	, Adresse_Sidedoer
	, Adresse_Husnummerbogstav
	, Adresse_Etage
	, Adresse_Postnummer
	, Adresse_Kvhx
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
	, WLEWII_ejer
	, WL_Coax
	, BL_Coax
	, BBR_DSL_Mulig_REV	
	, BBR_MDU_SDU_rev
	, BBR_BbrKode
	, BBR_PB_rev
	, BBR_kobber_downprio_ds
	, WL_Fiber_digging_length
	, WL_Fiber_kapstik
	, WL_Coax_Installationsstatus
	, WS_Fiber_HASTIGHED
	, WS_Coax_HASTIGHED
	, WS_XDSL_HASTIGHED
	--, WL_Coax_BB_Styret_afsaetning
	--, Business_BB_Hast_Prodnr
	, BBR_Coax_anlaeg_id
	, WS_RAA_KOBBER_OPERATOER
	, Archetypes_3rd_party
FROM csv.BredbaandData 

)

,  TechnologyInstalled AS (
SELECT
	Adresse_Vejnavn, Adresse_Husnummertal, Adresse_Sidedoer, Adresse_Husnummerbogstav, Adresse_Etage, Adresse_Postnummer, Adresse_Kvhx
	
	,TechnologyInstalled = 
		CASE
			WHEN TDC_Fiber_Enabled = 1 AND (WS_FIBER_OPERATOER <> '' OR  YS_BB_technology = 'Fiber' OR Business_BB_Tech_Fiber > 0) THEN 'Fiber'
			WHEN TDC_Fiber_Enabled = 0 AND (WS_FIBER_OPERATOER <> '' OR  YS_BB_technology = 'Fiber' OR Business_BB_Tech_Fiber > 0) THEN 'Fiber On Other Infrastructure'
			WHEN TDC_Coax_Enabled = 1 AND (WS_COAX_OPERATOER <> '' OR YS_BB_technology = 'Coax' OR Business_BB_Tech_Coax > 0) THEN 'Coax'
			WHEN  TDC_Coax_Enabled = 0 AND (WS_COAX_OPERATOER <> '' OR YS_BB_technology = 'Coax' OR Business_BB_Tech_Coax > 0) THEN 'Coax On Other Infrastructure'
			WHEN WS_XDSL_OPERATOER <> '' OR YS_BB_technology = 'DSL' OR Business_BB_Tech_GSHDSL > 0 OR Business_BB_Tech_XDSL > 0 OR WS_RAA_KOBBER_OPERATOER <> '' THEN 'DSL'
			ELSE 'No Installation'
		END
	, BestPossibleTechnology =
		CASE
			WHEN TDC_Fiber_Enabled = 1 THEN  'Fiber'
			WHEN TDC_Coax_Enabled = 1 THEN 'Coax'
			--WHEN TDC_Coax_Enabled_YouseeOnly = 1 THEN 'Coax'
			WHEN TDC_DSL_Enabled = 1 THEN 'DSL Only'
			ELSE 'No TDC Infrastructure'
		END
	, TDC_Fiber_Enabled
	, TDC_Coax_Enabled_Wholesale
	, TDC_Coax_Enabled_YouseeOnly
	, TDC_Coax_Enabled
	, TDC_DSL_Enabled
	, WS_Fiber_OPERATOER
	, WS_Coax_OPERATOER
	, WS_XDSL_OPERATOER
	, YS_BB_technology
	, Business_BB_Tech_Fiber
	, Business_BB_Tech_Coax
	, Business_BB_Tech_GSHDSL
	, Business_BB_Tech_XDSL
	, WL_Fiber
	, WLEWII_ejer
	, WL_Coax
	, BL_Coax
	, BBR_DSL_Mulig_REV	
	, BBR_MDU_SDU_rev
	, BBR_BbrKode
	, BBR_PB_rev
	, BBR_kobber_downprio_ds
	, WL_Fiber_digging_length
	, WL_Fiber_kapstik
	, WL_Coax_Installationsstatus
	, Dong_Omraade =
		CASE 
			WHEN DO.kvhx is not null THEN 1	
			ELSE 0
		END
	, DO.kvhx dongtest
	, YS_BB_package_name
	--, Business_BB_Hast_Prodnr
	, WS_Fiber_HASTIGHED
	, WS_Coax_HASTIGHED
	, WS_XDSL_HASTIGHED
--	, WL_Coax_BB_Styret_afsaetning
	, RåKobberOperatør = WS_RAA_KOBBER_OPERATOER
	--, BTO = CASE 
	--	WHEN WS_Fiber_Hovedprodukt = 'IPCONNECT FK' THEN 'BTO'
	--	ELSE 'Ikke BTO'
--	END 
	, BBR_Coax_anlaeg_id
	, Archetypes_3rd_party
	, WS_Fiber_Hovedprodukt
FROM TDCNetwork TDC
LEFT JOIN csv.DongOmraade DO
ON TDC.Adresse_Kvhx = DO.kvhx



) 
, BestTechnology AS (
SELECT
	[Adresse_Vejnavn]
	, [Adresse_Husnummertal]
	, [Adresse_Sidedoer]
	, Adresse_Husnummerbogstav
	, Adresse_Etage
	, Adresse_Postnummer
	, Adresse_Kvhx
	, TechnologyInstalled
	, BestPossibleTechnologyType =
	 CASE 		
			WHEN BestPossibleTechnology = 'Coax' AND TDC_Coax_Enabled_Wholesale = 1 THEN 'Coax'
			WHEN  BestPossibleTechnology = 'Coax' AND TDC_Coax_Enabled_YouseeOnly = 1 THEN 'Coax Yousee Only'
			ELSE BestPossibleTechnology
	END
	, WS_Fiber_OPERATOER
	, WS_Coax_OPERATOER
	, WS_XDSL_OPERATOER
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
					WHEN RåKobberOperatør <> '' then RåKobberOperatør
					ELSE ''
				END
			ELSE ''
		END
	, YS_BB_technology
	, Business_BB_Tech_Fiber
	, Business_BB_Tech_Coax
	, Business_BB_Tech_GSHDSL
	, Business_BB_Tech_XDSL
	--, BestPossibleTechnology = 
	--	CASE
	--		WHEN WL_Fiber = '1' THEN 'Fiber'
	--	--	WHEN WLEWII_ejer <> '' THEN 'Fiber EWII'
	--		WHEN TechnologyInstalled = 'Fiber' THEN 'Fiber'
	--		WHEN (WL_Coax = '1' OR BL_Coax = '1') AND WL_Coax_BB_Styret_afsaetning = 'Ja' THEN 'Coax'
	--		WHEN TechnologyInstalled = 'Coax' THEN 'Coax'
	--		WHEN BBR_DSL_Mulig_REV = '1' THEN 'DSL Only'
	--		ELSE 'No Infrastructure'
	--	END
	, BestPossibleTechnology
	, MDU_SDU = 
		CASE 
			WHEN BBR_MDU_SDU_rev > 4 THEN 'MDU'
			ELSE 'SDU'
		END
	, EWII_Whitelist = 
		CASE
			WHEN WLEWII_ejer <> '' THEN 1
			ELSE 0
		END
	, BBR_Type =
		CASE
			WHEN BBR_BbrKode = 0 THEN 'Ukendt'
			WHEN BBR_BbrKode = 1 THEN 'Residential Use'
			WHEN BBR_BbrKode = 2 THEN 'Non-Residential Use'
			WHEN BBR_BbrKode = 3 THEN 'Leisure-Time Use'
			ELSE ''
		END
	, Mulig_Kobber_Download_Hastighed = BBR_kobber_downprio_ds
	, Mulig_Pairbonding = BBR_PB_rev
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
	
	, WL_Fiber_digging_length
	, WL_Fiber
	, Dong_Omraade
	, BL_Coax
	, BBR_BbrKode
	, WL_Coax
	, YS_BB_package_name
--	, Business_BB_Hast_Prodnr
	, WS_Fiber_HASTIGHED
	, WS_Coax_HASTIGHED
	, WS_XDSL_HASTIGHED
	, BTO_Fiber =
		CASE
			WHEN WS_Fiber_Hovedprodukt IN ('IPCONNECT FK', 'DEDIKERET FIBER', 'FIBER BTO ACCESS') THEN CAST(1 as nvarchar(1))
			ELSE CAST(0 as nvarchar(1))
		END
	--, BTO
	, DSLType =
		CASE
			WHEN TechnologyInstalled = 'DSL' THEN
				CASE
					WHEN WS_XDSL_OPERATOER <> '' THEN 'EBSA VULA'
					WHEN YS_BB_technology = 'DSL' THEN 'Yousee'
					WHEN Business_BB_Tech_GSHDSL > 0 OR Business_BB_Tech_XDSL > 0 THEN 'TDC Business'
					WHEN RåKobberOperatør <> '' THEN 'Rå Kobber'
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
	, BBR_Coax_anlaeg_id
	, TDC_Coax_Enabled_Wholesale
	, TDC_Coax_Enabled_YouseeOnly
	, Archetypes_3rd_party
FROM TechnologyInstalled
)
, BestTechnology2 AS 

(

SELECT 

	BK_Adresse = UPPER(Adresse_Kvhx)
	, BK_Tredjepartsinfrastruktur = CAST(Archetypes_3rd_party as nvarchar(50))
	, TechnologyInstalled
	, BK_ServiceProvider = CAST(UPPER(Operatør + '||' + TechnologyInstalled) as nvarchar(150))
	, BestPossibleTechnology
	, BestPossibleTechnologyType
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
	, FiberInstalled =
		CASE
			WHEN TechnologyInstalled = 'Fiber' THEN 1
			ELSE 0
		END
	, FiberInstalledOnOTherInfrastructure =
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
	, EWII_Whitelist
	, Mulig_Kobber_Download_Hastighed = CAST(Mulig_Kobber_Download_Hastighed as numeric(18,0)) 
	, Mulig_Kobber_Download_Hastighed_m_Pairbonding =
		CASE
			WHEN Mulig_Pairbonding = 'PB' THEN CAST(Mulig_Kobber_Download_Hastighed as numeric(18,0))  * 2
			ELSE Mulig_Kobber_Download_Hastighed
		END
	, Mulig_Pairbonding
	, Dong_Omraade
	, BL_Coax
	, BBR_BbrKode
	, Produktområde = 
		CASE
			WHEN Operatør = 'YouSee' THEN 'YouSee'
			WHEN Operatør = 'TDC Business' THEN 'TDC Business'
			WHEN Operatør <> '' THEN 'Wholesale'
			ELSE ''
		END
	, Produktnavn =
		CASE
			WHEN Operatør = 'YouSee' THEN YS_BB_package_name
			WHEN Operatør = 'TDC Business' THEN 'TDC Business'
			WHEN Operatør <> '' THEN 
				CASE
					WHEN TechnologyInstalled = 'Fiber' THEN WS_Fiber_HASTIGHED
					WHEN TechnologyInstalled = 'Coax' THEN WS_Coax_HASTIGHED
					WHEN TechnologyInstalled = 'DSL' THEN WS_XDSL_HASTIGHED
				END
			ELSE ''
		END
	, WL_Coax
	, DSLType
	, BTO_Fiber
	, FiberType
	, BBR_Coax_anlaeg_id
FROM BestTechnology
) 


SELECT
	BK_Teknologi = CAST(UPPER(BestPossibleTechnology + '||' + TechnologyInstalled + '||' + GIG_GDS_Coax_Fiber + '||' + DSLType + '||' + BTO_Fiber + '||' + FiberType) as nvarchar(150))
	, BK_Produkt = CAST(UPPER(BT2.Produktnavn + '||' + BT2.Produktområde) as nvarchar(300))
	, BK_Adresse = CAST(BK_Adresse as nvarchar(40))
	, BK_Operatør = CAST(BK_ServiceProvider as Nvarchar(75))
	, BK_BBRType = CAST(BBR_BbrKode as nvarchar(50))
	, BK_Tredjepartsinfrastruktur
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
	, DSLOnly
	, NoInfrastructure
	, EWII_Whitelist
	, Mulig_Kobber_Download_Hastighed
	, Mulig_Kobber_Download_Hastighed_m_Pairbonding
	, Mulig_Pairbonding = 
		CASE 
			WHEN Mulig_Pairbonding = 'PB' THEN 1
			ELSE 0
		END
	, Dong_Omraade
	, Blacklist_Coax = CAST(BL_Coax as int) 
	, Whitelist_Coax = CAST(WL_Coax as int)
	, DownloadHastighed_KB = CAST(P.DownloadHastighed_KB as numeric(23,1))
	, BK_Anlægsinformation = CAST(BBR_Coax_anlaeg_id as nvarchar(20))

FROM BestTechnology2 BT2
LEFT JOIN [$(edw)].edw.Dim_Produkt P 
ON UPPER(BT2.Produktnavn + '||' + BT2.Produktområde) = P.BK_Produkt