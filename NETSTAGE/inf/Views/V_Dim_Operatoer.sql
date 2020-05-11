







/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [inf].[V_Dim_Operatoer]
AS

WITH DSL AS (

SELECT
	 [Operatør] = 
		CASE
			WHEN WS_XDSL_OPERATOER <> '' THEN WS_XDSL_OPERATOER
			WHEN WS_RAA_KOBBER_OPERATOER <> '' then WS_RAA_KOBBER_OPERATOER
			ELSE ''
		END
	 , [Operatør Gruppering] = WS_XDSL_OPERATOER_GROUP
	 , Teknologi = 'DSL'
	-- , BTO = 'Ikke BTO'
	-- , Op = RK.OPERATØR
FROM [dm].[InfrastructureBaseDataV2] BD
WHERE IsCurrent = 1 AND IsDeleted = 0
)

, Operatør AS (

SELECT
	 [Operatør] = WS_Fiber_OPERATOER
	 , [Operatør Gruppering] = WS_Fiber_OPERATOER_GROUP
	 , Teknologi = 'Fiber'
	-- , BTO = CASE 
	--	WHEN WS_Fiber_Hovedprodukt = 'IPCONNECT FK' THEN 'BTO'
	--	ELSE 'Ikke BTO'
--	END 
FROM [dm].[InfrastructureBaseDataV2]
WHERE IsCurrent = 1 AND IsDeleted = 0

AND WS_Fiber_OPERATOER <> ''
GROUP BY
	WS_Fiber_OPERATOER
	 , WS_Fiber_OPERATOER_GROUP
	-- , WS_Fiber_Hovedprodukt

UNION ALL

SELECT
	 [Operatør] = WS_Fiber_OPERATOER
	 , [Operatør Gruppering] = WS_Fiber_OPERATOER_GROUP
	 , Teknologi = 'Fiber On Other Infrastructure'
	-- , BTO = CASE 
	--	WHEN WS_Fiber_Hovedprodukt = 'IPCONNECT FK' THEN 'BTO'
	--	ELSE 'Ikke BTO'
--	END 
FROM [dm].[InfrastructureBaseDataV2]
WHERE IsCurrent = 1 AND IsDeleted = 0
AND WS_Fiber_OPERATOER <> ''

GROUP BY
	WS_Fiber_OPERATOER
	 , WS_Fiber_OPERATOER_GROUP
--	 , WS_Fiber_Hovedprodukt
	 

UNION ALL

SELECT
	 [Operatør] = WS_Coax_OPERATOER
	 , [Operatør Gruppering] = WS_Coax_OPERATOER
	 , Teknologi = 'Coax'
	-- , BTO = 'Ikke BTO'
FROM [dm].[InfrastructureBaseDataV2]

WHERE WS_coax_OPERATOER <> ''
AND  IsCurrent = 1 AND IsDeleted = 0

GROUP BY
	WS_Coax_OPERATOER

UNION ALL

SELECT
	 [Operatør] = WS_Coax_OPERATOER
	 , [Operatør Gruppering] = WS_Coax_OPERATOER
	 , Teknologi = 'Coax On Other Infrastructure'
	-- , BTO = 'Ikke BTO'
FROM [dm].[InfrastructureBaseDataV2]
WHERE WS_coax_OPERATOER <> ''
AND IsCurrent = 1 AND IsDeleted = 0

GROUP BY
	WS_Coax_OPERATOER

UNION ALL

SELECT
	Operatør
	, [Operatør Gruppering]
	, Teknologi
	--, BTO = 'Ikke BTO'
FROM DSL
GROUP BY Operatør, [Operatør Gruppering], Teknologi

UNION ALL

SELECT Operatør = 'YouSee'
	  , [Operatør Gruppering] = 'YouSee'
	  , YS_BB_technology
	--  , BTO = 'Ikke BTO'
FROM [dm].[InfrastructureBaseDataV2]
WHERE IsCurrent = 1 AND IsDeleted = 0
AND YS_BB_technology <> ''

GROUP BY
	YS_BB_technology

UNION ALL

SELECT Operatør = 'YouSee'
	  , [Operatør Gruppering] = 'YouSee'
	  , YS_BB_technology = 
		CASE
			WHEN YS_BB_technology = 'Fiber' THEN 'Fiber On Other Infrastructure'
			WHEN YS_BB_technology = 'Coax' THEN 'Coax On Other Infrastructure'
			ELSE ''
		END
	--  , BTO = 'Ikke BTO'
FROM [dm].[InfrastructureBaseDataV2]
WHERE IsCurrent = 1 AND IsDeleted = 0
AND YS_BB_technology <> ''

GROUP BY
	YS_BB_technology

UNION ALL

 
SELECT 
	Operatør
	, [Operatør Gruppering] 
	, Teknologi
	--, BTO = 'Ikke BTO'
FROM 
(SELECT
	Operatør = 'TDC Business'
	, [Operatør Gruppering] = 'TDC Business'
	, Teknologi = 
		CASE 
			WHEN WL_Fiber = 1 THEN
				CASE
					WHEN Business_BB_Tech_Fiber > 0 THEN 'Fiber'
					WHEN Business_BB_Tech_Coax > 0 THEN 'Coax'
					WHEN Business_BB_Tech_XDSL > 0 OR Business_BB_Tech_GSHDSL > 0 THEN 'DSL'
					ELSE ''
				END
			WHEN WL_Fiber = 0 THEN
				CASE
					WHEN Business_BB_Tech_Fiber > 0 THEN 'Fiber On Other Infrastructure'
					WHEN Business_BB_Tech_Coax > 0 THEN 'Coax On Other Infrastructure'
					WHEN Business_BB_Tech_XDSL > 0 OR Business_BB_Tech_GSHDSL > 0 THEN 'DSL'
					ELSE ''
				END
			END
FROM [dm].[InfrastructureBaseDataV2]
WHERE Business_BB_Tech_Fiber > 0 OR Business_BB_Tech_Coax > 0 OR Business_BB_Tech_XDSL > 0 OR Business_BB_Tech_XDSL > 0
AND IsCurrent = 1 AND IsDeleted = 0

) TDCBusiness
GROUP BY Operatør, [Operatør Gruppering], Teknologi
)

SELECT
	BK_Operatør = CAST(UPPER(O.Operatør + '||' + O.Teknologi) as nvarchar(150))
	, Operatør = CAST(O.Operatør as nvarchar(50))
	, OperatørGruppering = CAST(O.[Operatør Gruppering] as nvarchar(50))
	, Teknologi = CAST(O.Teknologi as nvarchar(50))
	, [ServiceProvider] = 
		CASE
			WHEN O.Operatør = 'YouSee' THEN CAST('YouSee' as nvarchar(50))
			WHEN Operatør = 'TDC Business' THEN CAST('TDC Business' as nvarchar(50))
			ELSE CAST(SP.[Service Provider] as nvarchar(50))
		END
	--, BTO = CAST(BTO as nvarchar(20))
	, [dw_DateTimeLoad] = GETDATE()

FROM Operatør O
LEFT JOIN csv.ServiceProviders SP
ON O.Operatør = SP.[Fiber Operatør]	
GROUP BY o.Operatør, O.Teknologi, [Operatør Gruppering], SP.[Service Provider]