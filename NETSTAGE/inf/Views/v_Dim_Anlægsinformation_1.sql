




/****** Script for SelectTopNRows command from SSMS  ******/
cREATE VIEW inf.[v_Dim_Anlægsinformation] AS

SELECT
	BK_Anlægsinformation = CAST(REPLICATE('0', 10 - LEN([AnlaegsId])) + [AnlaegsId] as nvarchar(50))
	, [Yousee Bredbånd] =
		CASE
			WHEN [BB Styret Afsaetning] NOT IN ('Nej', '') THEN CAST('Ja' as nvarchar(10))
			ELSE CAST('Nej' as nvarchar(10))
		END
	, Topgruppe = CAST(bd.[Topgruppekode] as nvarchar(2))
	, Topgruppenavn = CAST(Topgruppenavn as nvarchar(200))
	, SLOEJFE = CAST(sloejfe as nvarchar(2))
	, [KAPGR Name] = CAST([KAPGR Name] as nvarchar(100))
	, CMTS = 
		CASE
			WHEN [KAPGR Name] LIKE '%CMTS%' THEN CAST('CMTS' as nvarchar(20))
			ELSE CAST('Not CMTS' as nvarchar(20))
		END
FROM [$(DataMart)].[dbo].[BSACoax_Anlaeg_tbl] BD
Join [$(DataMart)].[dbo].[BSACoax_Topgruppenavn_Klassifikation] T on  BD.Topgruppekode = T.Topgruppekode
  --ON REPLICATE('0', 10 - LEN(BD.BBR_Coax_anlaeg_id)) + BD.BBR_Coax_anlaeg_id = A.AnlægsId
  where [AnlaegsId] is not null
    and IsCurrent = 1 and IsDeleted = 0

GROUP BY
	[AnlaegsId]
	, [BB Styret Afsaetning]
	, bd.Topgruppekode
	,Topgruppenavn
		,sloejfe
	, [KAPGR Name]
	, REPLICATE('0', 10 - LEN([AnlaegsId])) + [AnlaegsId]
--	, BK_Anlægsinformation
	, [AnlaegsId]