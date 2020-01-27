



/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[v_Dim_Anlægsinformation] AS

SELECT
	BK_Anlægsinformation = CAST(REPLICATE('0', 10 - LEN(BBR_Coax_anlaeg_id)) + BBR_Coax_anlaeg_id as nvarchar(50))
	, [Yousee Bredbånd] =
		CASE
			WHEN WL_Coax_BB_Styret_afsaetning NOT IN ('Nej', '') THEN CAST('Ja' as nvarchar(10))
			ELSE CAST('Nej' as nvarchar(10))
		END
	, Topgruppe = CAST(WL_Coax_Topgruppekode as nvarchar(1))
	, Topgruppenavn = CAST(Topgruppenavn as nvarchar(200))
	, SLOEJFE = CAST(WL_Coax_sloejfe as nvarchar(2))
	, [KAPGR Name] = CAST(WL_Coax_KAPGR_Name as nvarchar(100))
	, CMTS = 
		CASE
			WHEN WL_Coax_KAPGR_Name LIKE '%CMTS%' THEN CAST('CMTS' as nvarchar(20))
			ELSE CAST('Not CMTS' as nvarchar(20))
		END
  FROM [csv].BredbaandData BD
  LEFT JOIN csv.Anlaegsoversigt A
  ON REPLICATE('0', 10 - LEN(BD.BBR_Coax_anlaeg_id)) + BD.BBR_Coax_anlaeg_id = A.AnlægsId
  where BBR_Coax_anlaeg_id is not null
  GROUP BY
  	BBR_Coax_anlaeg_id

	, WL_Coax_BB_Styret_afsaetning
	, 	 WL_Coax_Topgruppekode
	, Topgruppenavn
		, WL_Coax_sloejfe
	, WL_Coax_KAPGR_Name
	,[CMTS Id]