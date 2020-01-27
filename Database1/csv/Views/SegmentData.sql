



CREATE VIEW [csv].[SegmentData] AS 
With Kvhx as (
  SELECT 
	kvhx
	,PreliminaryKvhx = komkode + vejkode + husnr
	, etage
	, sidedoer = 
		CASE 
			WHEN ISNUMERIC(sidedoer) = 1 THEN REPLICATE('0', 4-LEN(sidedoer)) + SideDoer
			ELSE SideDoer
		END
	, KomKode
	, Vejkode
	, Husnr
	, husnummerbogstav = CASE
							WHEN ISNUMERIC(LEFT(REVERSE(komkode + vejkode + husnr), 1)) = 0
							THEN 1
							ELSE 0
						END
	, Segment
	, TypeBolig
  FROM csv.SegmentKvhx

  )
  , Overblik AS (

  SELECT-- Kvhx
	--	, Kvh = KomKode + Vejkode + Husnr
	--	, husnummerbogstav
		 KVHX =
			CASE 
				
				WHEN kvhx.husnummerbogstav = 1 AND kvhx.Etage = '' AND SideDoer <> '' THEN PreliminaryKvhx + '  ' + UPPER(SideDoer)
				WHEN kvhx.husnummerbogstav = 0 AND kvhx.Etage = '' AND SideDoer <> '' THEN PreliminaryKvhx  + '   ' + UPPER(SideDoer)
				WHEN kvhx.husnummerbogstav = 1 THEN PreliminaryKvhx + UPPER(kvhx.Etage) + UPPER(sidedoer)
				ELSE PreliminaryKvhx + ' ' + UPPER(kvhx.Etage) + UPPER(sidedoer)
			END
			, Segment
	, kvhx.TypeBolig
	, Latitude
	, Longitude
	, Postnummer
	, A.Vejnavn
	, Husnummertal
	, A.Husnummerbogstav
	, A.Etage
	, Sidedør
	, A.Kommune
	, A.Kommunekode
	, Region =
		CASE 
			WHEN A.Postnummer >= 6000 THEN 'Jylland'
			WHEN A.Postnummer >= 5000 THEN 'Fyn'
			WHEN A.Kommunekode  IN (101,147,151,153,155,157,159,161,163,165,167,169,173,175,183,185,187,190,201,210,217,219,223,230,240,250)  THEN 'Dong'
			WHEN A.Postnummer BETWEEN 3700 AND 3799 THEN 'Bornholm'
			ELSE 'Sjælland'
		END
	, TechnologyInstalled
	, BestPossibleTechnology
	, A.CoaxWhitelist
	, A.CoaxBlacklist

	, PrivatCoaxProxy = 
						CASE
							WHEN A.CoaxBlacklist = 1 and CoaxWhitelist = 0 and BestPossibleTechnology = 'DSL Only'
							THEN 1
							ELSE 0
						END
	, TDN.KonkCoax
	, KD.EjerNavn
  FROM Kvhx
  LEFT JOIN [$(edw)].pbi.Dim_Adresse A
  ON 		CASE 
				
				WHEN kvhx.husnummerbogstav = 1 AND kvhx.Etage = '' AND SideDoer <> '' THEN PreliminaryKvhx + '  ' + UPPER(SideDoer)
				WHEN kvhx.husnummerbogstav = 0 AND kvhx.Etage = '' AND SideDoer <> '' THEN PreliminaryKvhx  + '   ' + UPPER(SideDoer)
				WHEN kvhx.husnummerbogstav = 1 THEN PreliminaryKvhx + UPPER(kvhx.Etage) + UPPER(sidedoer)
				ELSE PreliminaryKvhx + ' ' + UPPER(kvhx.Etage) + UPPER(sidedoer)
			END = A.Kvhx

LEFT JOIN [$(edw)].pbi.Fact_Bredbånd B
ON A.Adresse_Key = B.FK_Adresse
LEFT JOIN [$(edw)].pbi.Dim_Teknologi T
ON B.FK_Teknologi = T.Teknologi_Key
LEFT JOIN [$(edw)].pbi.Dim_TDNCoax TDN
ON B.FK_TDNCoax = TDN.TDNCoax_Key
LEFT JOIN csv.KMDData KD
ON kvhx.Kvhx = KD.Kvhx
where BestPossibleTechnology <> 'No TDC Infrastructure'
)


SELECT
*
, CoaxType = 
	CASE 
		WHEN BestPossibleTechnology = 'Coax' THEN 'TDC Coax'
		WHEN KonkCoax = 1 THEN 'Competitive Coax'
		ELSE 'DSL Only'
	END
FROM Overblik