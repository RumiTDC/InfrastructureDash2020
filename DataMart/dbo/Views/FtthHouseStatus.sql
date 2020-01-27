
CREATE VIEW [dbo].[FtthHouseStatus]
AS

	/*	How To Use

	SELECT
		FS.[FtthStatus],
		COUNT(FS.[KVHX]) AS Antal
	FROM [dbo].[FtthHouseStatus] FS
	GROUP BY
		FS.[FtthStatus]

	SELECT
		FS.[KVHX],
		FS.[FtthStatus],
		FS.[FtthHouseActivated],
		FS.[FtthHouseConnected],
		FS.[FtthHousePassed]
	FROM [dbo].[FtthHouseStatus] FS
	
	*/

WITH Klassifikation AS (
	SELECT 'HP' AS [FtthStatus], 1 AS [Prioritet]
	UNION ALL
	SELECT 'HC' AS [FtthStatus], 2 AS [Prioritet]
	UNION ALL
	SELECT 'HA' AS [FtthStatus], 3 AS [Prioritet]
)
, Infrastructure AS (
	SELECT 
		IL.[Adresse_Kvhx] AS [KVHX],
		'HA' AS [FtthStatus]
	FROM [dbo].[InfrastructureBaseData_LastLoadedMonth] IL WITH(NOLOCK)
	WHERE
		IL.[YS_BB_technology] = 'Fiber'
)
, FiberWhiteList AS (
	SELECT
		[KVHX],            
		CASE			
			WHEN [kapstik] = 'Ja' THEN 'HC'
			WHEN ISNULL([kapstik_service_id],'') <> '' THEN 'HC'    -- Der har været et kapstik?
			--WHEN [TDC_DIGG] IN (1,2,3,4) THEN 'HP'
			ELSE 'HP'
		END AS [FtthStatus]               
	FROM [dbo].[WhitelistFtthDetail] WITH(NOLOCK)
)
, CombineResult AS (
	SELECT I.[KVHX], I.[FtthStatus], K.[Prioritet]
	FROM [Infrastructure] I  WITH(NOLOCK)
		JOIN [Klassifikation] K
			ON K.[FtthStatus] = I.[FtthStatus]
	UNION ALL
	SELECT W.[KVHX], W.[FtthStatus], K.[Prioritet]
	FROM [FiberWhiteList] W
		JOIN Klassifikation K
			ON K.[FtthStatus] = W.[FtthStatus]
)
, PreResult AS (
	SELECT
		CR.[KVHX],
		(SELECT [FtthStatus] FROM [Klassifikation] WHERE [Prioritet] = MAX(CR.[Prioritet])) AS [FtthStatus]
	FROM [CombineResult] CR	
	GROUP BY
		CR.[KVHX]
)
SELECT
	FS.[KVHX],
	FS.[FtthStatus],
	CASE WHEN FS.[FtthStatus] = 'HA' THEN 1 ELSE 0 END AS [FtthHouseActivated],
	CASE WHEN FS.[FtthStatus] IN ('HC','HA') THEN 1 ELSE 0 END AS [FtthHouseConnected],
	CASE WHEN FS.[FtthStatus] IN ('HC','HA', 'HP') THEN 1 ELSE 0 END AS [FtthHousePassed]	
FROM [PreResult] FS