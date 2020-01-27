
CREATE VIEW [stage].[v_Dim_Adresse] as
 
 WITH CityCount AS (
	SELECT Adresse_By, COUNT(*) CityCount
	FROM csv.BredbaandData
	GROUP BY Adresse_By
 )
 
  , Adresse AS (
  
  SELECT
	BK_Adresse = CAST(Adresse_Kvhx as nvarchar(40))
	, [By] = CAST(Adresse_By as nvarchar(20))
	, Kommunekode = CAST(Adresse_Kommunekode as int)
	, Kommune = 
			SUBSTRING(SUBSTRING(Adresse_Kommunenavn, 1, LEN(Adresse_Kommunenavn)-1), 3, LEN(Adresse_Kommunenavn))
	, Kvhx = Adresse_Kvhx
	, Kvh = Adresse_Kvh
	, Etage = Adresse_Etage
	, Husnummertal = Adresse_Husnummertal
	, Husnummerbogstav = Adresse_Husnummerbogstav
	, BBR_Coax_ejer
	, Latitude = 
		CASE 
			WHEN adresse_latitude IS NOT NULL
			THEN Adresse_Latitude
			--THEN LEFT(REPLACE(Adresse_Latitude, '.', ''), 2) + ',' + REPLACE(SUBSTRING(adresse_latitude, 3, LEN(adresse_latitude)), '.', '')
			ELSE ''
		END
	, Longitude =  
		--CASE 
		--	WHEN adresse_longitude IS NOT NULL and CAST(LEFT(adresse_longitude, 1) as int) = 1
		--	THEN LEFT(REPLACE(Adresse_Longitude, '.', ''), 2) + ',' + REPLACE(SUBSTRING(Adresse_Longitude, 3, LEN(Adresse_Longitude)), '.', '')
		--	WHEN adresse_latitude <> '' and CAST(LEFT(adresse_longitude, 1) as int) <> 1
		--	THEN LEFT(REPLACE(Adresse_Longitude, '.', ''), 1) + ',' + REPLACE(SUBSTRING(Adresse_Longitude, 2, LEN(Adresse_Longitude)), '.', '')
		--	ELSE ''
		--END
		CASE
			WHEN Adresse_Longitude is not null
			THEN Adresse_Longitude 
			ELSE ''
		END
	, Postnummer = Adresse_Postnummer
	, Vejnavn = Adresse_Vejnavn
	, Sidedør = Adresse_Sidedoer
	, WLEWII_ejer
	, WL_Coax
	, WL_Fiber
	, WL_Fiber_deselection_reasontekst
	, BL_Coax
	, MDU_SDU = CASE
					WHEN COUNT(Adresse_Kvhx) OVER(PARTITION BY Adresse_Kvh) >= 4 THEN 'MDU'
					ELSE 'SDU'
				END
	, MDU_50Plus =
		CASE
			WHEN COUNT(Adresse_Kvhx) OVER(PARTITION BY Adresse_Kvh) > 49 then 1
			ELSE 0
		END
	, MDU_SDU_Amount = COUNT(Adresse_Kvhx) OVER(PARTITION BY Adresse_Kvh)
	, PB_Mulig = 
		CASE 
			WHEN BBR_PB_rev = 'PB' THEN 1
			ELSE 0
		END
  FROM csv.BredbaandData


)

SELECT 
	 BK_Adresse
	, [By] = A.[By] 
	, A.Kommunekode 
	, Kommune = CAST(REPLACE(A.Kommune, 'Vesthimmerland', 'Vesthimmerlands') as nvarchar(20))
	, Kvhx = CAST(A.Kvhx as nvarchar(40))
	, Kvh = CAST(A.Kvh as nvarchar(15))
	, Etage = CAST(A.Etage as nvarchar(2))
	, Husnummertal = CAST(A.Husnummertal as int)
	, Husnummerbogstav = CAST(A.Husnummerbogstav as nvarchar(1)) 
	, Sidedør = CAST(A.sidedør as nvarchar(5))
	, Latitude  
		--CASE
		--	WHEN ISNUMERIC(A.Latitude) = 1
		--	THEN CAST(REPLACE(A.Latitude, ',', '.') as numeric(18,10))
		--	ELSE null
		--END
	, Longitude  
	--	CASE
	--		WHEN ISNUMERIC(A.Longitude) = 1
	--		THEN CAST(REPLACE(A.Longitude, ',', '.') as numeric(18,10))
	--		ELSE null
	--	END
	, Postnummer = CAST(A.Postnummer as int)
	, Vejnavn = CAST(A.Vejnavn as nvarchar(50)) 

	 , DongKommuner =
	CASE 
		WHEN Kommunekode IN (101,147,151,153,155,157,159,161,163,165,167,169,173,175,183,185,187,190,201,210,217,219,223,230,240,250)
		AND WL_Fiber = 1 THEN 1
		ELSE 0
	END
	, EniigPostnummer =
		CASE
			WHEN EP.Elselskab is not null
			THEN CAST(EP.Elselskab as nvarchar(20))
			ELSE CAST('Ikke Eniig' as nvarchar(20))
		END
	, EWII_Adresse = 
		CASE
			WHEN A.WLEWII_ejer <> '' THEN CAST('EWII' as nvarchar(10))
			ELSE CAST('Ikke EWII' as nvarchar(10)) 
		END
--	, Meldte_Boliger_I_Kommune = MB.[Meldte Boliger]
	--, CAST(MåIkkeSælgesCoax as nvarchar(10)) as MåIkkeSælgesCoax
	, CoaxWhitelist = CAST(WL_Coax as nvarchar(1))	 
	, FiberWhitelist = CAST(WL_Fiber as nvarchar(1))
	, CoaxBlacklist = CAST(BL_Coax as nvarchar(1)) 
	, MDU_SDU = CAST(MDU_SDU as nvarchar(10)) 
	, CoaxAnlaegEjer = CAST(BBR_Coax_ejer as nvarchar(10))
	, FiberWhitelistDeselectionText = CAST(WL_Fiber_deselection_reasontekst as nvarchar(40))
	, MDU_50Plus
	, MDU_SDU_amount = MDU_SDU_Amount
	, IndbyggertalBy = CC.CityCount
	, Over10KIndbyggereIBy =
		CASE
			WHEN cc.CityCount >= 10000 THEN 1
			ELSE 0
		END
	, PB_Mulig
FROM Adresse A
LEFT JOIN csv.EniigPostnumre EP
ON A.Postnummer = EP.Postnummer
LEFT JOIN CityCount CC
ON A.[By] = CC.Adresse_By
--LEFT JOIN csv.MeldteBoliger MB
--ON A.Kommune = MB.Kommune