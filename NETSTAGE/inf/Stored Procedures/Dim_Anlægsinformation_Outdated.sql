
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE procedure [inf].[Dim_Anlægsinformation_Outdated] AS

SELECT 
	 FK_Anlaegsinformation = CAST(REPLICATE('0', 10 - LEN(BK_AnlægsinformationID)) + BK_AnlægsinformationID as int)
	,BK_Anlaegsinformation = REPLICATE('0', 10 - LEN(BK_AnlægsinformationID)) + BK_AnlægsinformationID 
	,[Yousee Bredbånd] =
		CASE
			WHEN WL_Coax_BB_Styret_afsaetning NOT IN ('Nej', '') THEN CAST('Ja' as nvarchar(10))
			ELSE CAST('Nej' as nvarchar(10))
		END
	, Topgruppe =		ISNULL(WL_Coax_Topgruppekode, '-1')
--	, SLOEJFE =			ISNULL(CAST(WL_Coax_sloejfe as nvarchar(2)), 'Ukendt')

--	, BK_DateFrom
 FROM [stg].[Infrastructure] BD
 WHERE   WL_Coax_KAPGR_Name is not null and BK_AnlægsinformationID is not null
 AND ISCURRENT = 1
 AND BK_DateTo IS NULL 
 --A AND BK_DateToND FromToDate
 
 GROUP BY
  	  BK_AnlægsinformationID
	, WL_Coax_KAPGR_Name
	, WL_Coax_BB_Styret_afsaetning
	, WL_Coax_Topgruppekode
--	,  BK_DateFrom


order by BK_AnlægsinformationID