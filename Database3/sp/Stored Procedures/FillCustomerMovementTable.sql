CREATE PROCEDURE [sp].[FillCustomerMovementTable] 
AS

WITH TEST AS (

SELECT 
adresse_kvhx,
 TDC_Fiber_Enabled =
	CASE
		WHEN WL_Fiber = '1' THEN 1
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
	, HistoryValidDateTimeFrom
	, HistoryValidDateTimeTo
	, HistoryCurrentRec
	, HistoryModifiedDate
	, KørselsTidspunkt = CAST(DATEADD(month, DATEDIFF(month, 0,DATEADD(month, -1, GETDATE())), 0) as date)
FROM csv.BredbaandDataForHistory BD
where HistoryDeletedAtSource = 0


)

, TEST2 AS (
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
FROM TEST
)  
, ServiceProvider AS (
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
	, BBR_BbrKode
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
	,CAST(HistoryValidDateTimeFrom as varchar(50)) as HistoryVARCHAR
	, HistoryCurrentRec
	, KørselsTidspunkt
FROM TEST2
) 

, LEADLAG AS (
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
FROM ServiceProvider SP
LEFT JOIN (
SELECT [Fiber Operatør], [Service Provider]
FROM EDW_Stage.csv.ServiceProviders
GROUP BY [Fiber Operatør], [Service Provider]) SP2
ON SP.Operatør = SP2.[Fiber Operatør]
) 

, PreparedData AS (
SELECT 
	Adresse_Kvhx
, BBR_BbrKode
, LaterHistoryValidTimeFrom = CASE
									WHEN LaterHistoryValidTimeFrom = '0' THEN NULL
									ELSE LaterHistoryValidTimeFrom
								END  
, PriorTechnologyInstalled =
		CASE
			WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.0000001' THEN TechnologyInstalled
			ELSE PriorTechnologyInstalled
		END
	, TechnologyInstalled
	, Operator 
	, PriorOperator =
		CASE
			WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.0000001' THEN Operator 
			ELSE PriorOperator
		END
	, ServiceProvider
	, PriorServiceProvider = 
		CASE
			WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.0000001' THEN ServiceProvider 
			ELSE PriorServiceProvider
		END
	, BestPossibleTechnology
	, PriorBestPossibleTechnology = 
		CASE
			WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.0000001' THEN BestPossibleTechnology
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
			WHEN (TechnologyInstalled <> 'No Installation' AND PriorTechnologyInstalled = 'No Installation') OR (PriorTechnologyInstalled = '0' AND HistoryValidDateTimeFrom <> '2019-05-01 00:00:00.0000001' AND TechnologyInstalled <> 'No Installation') THEN 'Nytilgang'
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
	, F_Movement = 
		CASE 
			WHEN PriorTechnologyInstalled = '0' and TechnologyInstalled = 'No Installation' THEN 0
			ELSE

				CASE 
					WHEN (PriorTechnologyInstalled <> TechnologyInstalled OR 
						 PriorOperator <> Operator)
						 AND (PriorTechnologyInstalled <> '0' OR (PriorTechnologyInstalled = '0' and TechnologyInstalled <> 'No Installation'))
					THEN 1
					ELSE 0
				END
		END
	, WS_XDSL_OPERATOER
	, WS_RAA_KOBBER_OPERATOER
	, BTO_Fiber
	, PRIORBTO_Fiber
	, FiberType
	, PriorFiberType
	, YS_BB_technology
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
FROM LEADLAG
) 
, GIGGDS AS (

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
	, F_Movement
	, F_Movement_LAG1 = LAG(F_Movement,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
	, Non_Movement_Extra_Row =
		CASE
			WHEN F_Movement = 1
			AND DATEDIFF(month, HistoryValidDateTimeFrom, HistoryValidDateTimeTo) >= 1 
			AND MovementType <> 'Non-Movement'
		  AND CAST(HistoryValidDateTimeFrom as date) <> KørselsTidspunkt
			THEN 1
			ELSE 0
		END
	, BBR_Coax_anlaeg_id
	, KørselsTidspunkt
		, BTO_Fiber
	, PRIORBTO_Fiber
	, FiberType
	, PriorFiberType
	, Datediff(Month,HistoryValidDateTimeFromMonth, KørselsTidspunkt) as datedifference
FROM PreparedData
) 

, AddRows AS (
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
	, F_Movement
	, F_Movement_LAG1
	, Non_Movement_Extra_Row
, Newrowadded = 0
FROM GIGGDS

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
	, F_Movement
	, F_Movement_LAG1
	, Non_Movement_Extra_Row
	, Newrowadded = 1
FROM GIGGDS
where Non_Movement_Extra_Row = 1
)

, LAGLogic AS (
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
	, F_Movement
	, F_Movement_LAG1
	, Non_Movement_Extra_Row
	, Newrowadded
FROM AddRows
) 

, LAGGIGGDS AS (

SELECT
	BK_Adresse = CAST(Adresse_Kvhx as nvarchar(200))
	, BK_AnlægsinformationID = CAST(BBR_Coax_anlaeg_id as nvarchar(50))
	, BK_BBRType = CAST(BBR_BbrKode as nvarchar(1))
	, BK_FromTeknologi = 
			CAST(UPPER(PriorBestPossibleTechnology + '||' + PriorTechnologyInstalled + '||' +
				CASE
					WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.0000001' THEN GIG_GDS_Coax_Fiber
					ELSE LAG(GIG_GDS_Coax_Fiber,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
				END
				 + '||' +
				 CASE
					WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.0000001' THEN DSLType
					ELSE LAG(DSLType,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
				END
				+ '||' + 
				CASE
					WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.0000001' THEN BTO_Fiber
					ELSE LAG(BTO_Fiber,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
				END
			   + '||' + 
			 CASE
					WHEN HistoryValidDateTimeFrom = '2019-05-01 00:00:00.0000001' THEN FiberType
					ELSE LAG(FiberType,1,0) OVER (PARTITION BY Adresse_kvhx ORDER BY HistoryValidDateTimeFrom)
				END) as nvarchar(250))
	, BK_ToTeknologi = CAST(UPPER(BestPossibleTechnology + '||' + TechnologyInstalled + '||' + GIG_GDS_Coax_Fiber + '||' + DSLType + '||' + BTO_Fiber + '||' + FiberType) as nvarchar(250))
	, BK_FromOperator = CAST(UPPER(PriorOperator + '||' + PriorTechnologyInstalled) as nvarchar(150))
	, BK_ToOperator = CAST(UPPER(Operator + '||' + TechnologyInstalled) as nvarchar(150))
	, MovementType = CAST(MovementType as nvarchar(20))
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
	 , F_Movement = 
		CASE
			WHEN MovementType <> 'Non-Movement' THEN 1
			ELSE 0
		END
	, F_Churn =
		CASE
			WHEN MovementType = 'Churn' THEN 1
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
FROM LAGLogic
)

INSERT INTO csv.CustomerMovementsAndNonMovementsFilled
SELECT *
FROM LAGGIGGDS