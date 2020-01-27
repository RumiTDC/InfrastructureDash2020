CREATE VIEW [stage].[v_Dim_Produkt] AS 


WITH YouseeHastigheder AS (

SELECT
	 YS_BB_package_name
	 , Hastighed = dbo.udf_getnumeric(YS_BB_package_name) 
	 , Hast1 = 
	
				CASE 
					WHEN RIGHT(dbo.udf_getnumeric(YS_BB_package_name), 1) = ','
					THEN LEFT(dbo.udf_GetNumeric(YS_BB_package_name), LEN(dbo.udf_GetNumeric(YS_BB_package_name))-1)
					ELSE dbo.udf_GetNumeric(YS_BB_package_name)
				END
	 , YS_BB_technology
FROM csv.BredbaandData
WHERE YS_BB_package_name <> ''
GROUP BY YS_BB_package_name, YS_BB_technology

)

, Intermediate as (
SELECT 
	YS_BB_package_name
	, Hastighed
	, DownUpHastighed =
		CASE 
			WHEN RIGHT(Hast1, 1) = '/' AND LEFT(Hast1, 1) <> '/'
			THEN LEFT(Hast1, LEN(Hast1)-1)
			WHEN LEFT(Hast1, 1) = '/' AND  RIGHT(Hast1, 1) <> '/'
			THEN RIGHT(Hast1, LEN(Hast1)-1)
			WHEN RIGHT(Hast1, 1) = '/' AND LEFT(Hast1, 1) = '/'
			THEN LEFT(RIGHT(Hast1, LEN(Hast1)-1), LEN(RIGHT(Hast1, LEN(Hast1)-1))-1)
			ELSE Hast1
		END
	, Hast1
	,YS_BB_technology
FROM YouseeHastigheder
)


, Intermediate2 AS (
SELECT 
	YS_BB_package_name
	, DownUpHastighed
	, UpHast = 
			CASE 
				WHEN DownUpHastighed <> '' THEN CAST(REPLACE(RIGHT(DownUpHastighed, LEN(DownUpHastighed) - CHARINDEX('/', DownUpHastighed)), ',', '.') as numeric(18,1)) / 1024
				ELSE null
			END
	

	, DownHast = 
		CASE
				WHEN  DownUpHastighed <> '' AND LEN(dbo.udf_GetNumeric(DownUpHastighed)) > 3 THEN CAST(REPLACE(LEFT(DownUpHastighed, CHARINDEX('/', DownUpHastighed)-1), ',', '.') as numeric(18,1)) / 1024
				WHEN  DownUpHastighed <> '' AND LEN(dbo.udf_GetNumericsOnly(DownUpHastighed)) BETWEEN 1 AND 3 AND LEN(dbo.udf_GetSlash(DownUpHastighed)) < 1 THEN CAST(DownUpHastighed as numeric(18,1)) / 1024
				WHEN  DownUpHastighed <> '' AND LEN(dbo.udf_GetNumericsOnly(DownUpHastighed)) BETWEEN 1 AND 3 AND LEN(dbo.udf_GetSlash(DownUpHastighed)) >= 1 THEN CAST(LEFT(DownUpHastighed, CHARINDEX('/', DownUpHastighed)-1) as numeric(18,1)) / 1024
				ELSE null
			END
	, Hastighed1 = 
			CASE
				WHEN  DownUpHastighed <> '' AND LEN(dbo.udf_GetNumeric(DownUpHastighed)) > 3 THEN CAST(REPLACE(LEFT(DownUpHastighed, CHARINDEX('/', DownUpHastighed)-1), ',', '.') as numeric(18,1))
				WHEN  DownUpHastighed <> '' AND LEN(dbo.udf_GetNumericsOnly(DownUpHastighed)) BETWEEN 1 AND 3 AND LEN(dbo.udf_GetSlash(DownUpHastighed)) < 1 THEN CAST(DownUpHastighed as numeric(18,1)) 
				WHEN  DownUpHastighed <> '' AND LEN(dbo.udf_GetNumericsOnly(DownUpHastighed)) BETWEEN 1 AND 3 AND LEN(dbo.udf_GetSlash(DownUpHastighed)) >= 1 THEN CAST(LEFT(DownUpHastighed, CHARINDEX('/', DownUpHastighed)-1) as numeric(18,1)) 
				ELSE null
			END
	, Hastighed2 = 
			CASE 
				WHEN DownUpHastighed <> '' THEN CAST(REPLACE(RIGHT(DownUpHastighed, LEN(DownUpHastighed) - CHARINDEX('/', DownUpHastighed)), ',', '.') as numeric(18,1))
				ELSE null
			END
	, dbo.udf_GetMb(YS_BB_package_name) MB
	, dbo.udf_GetKb(YS_BB_package_name) KB
	, dbo.udf_GetGb(YS_BB_package_name) GB
	, YS_BB_technology
FROM Intermediate
WHERE DownUpHastighed <> ''
)

, Intermediate3 AS (

SELECT
	YS_BB_package_name
	, DownUpHastighed
	, UpHast
	, DownHast
	, MB_KB_GUESS_1_Upload =
		CASE
			WHEN UpHast >= 0.5 OR Uphast = 0.375 OR Uphast = 0.25 OR UpHast = 0.125 THEN 'KB'
			WHEN DownUpHastighed = '1' THEN 'GB'
			ELSE 'MB'
		END
	, MB_KB_GUESS_1_Download = 
		CASE
			WHEN DownHast >= 0.5 OR Downhast = 0.375 OR DownHast = 0.25 OR DownHast = 0.125 THEN 'KB'
			WHEN DownUpHastighed = '1' THEN 'GB'
			ELSE 'MB'
		END
	, MB_KB_From_Name = 
		CASE 
			WHEN MB LIKE '%Mb%' then 'MB'
			WHEN KB LIKE '%Kb%' then 'KB'
			WHEN GB LIKE '%GB%' then 'GB'
			ELSE ''
		END
	, Hastighed1
	, Hastighed2
	, YS_BB_technology
FROM Intermediate2

) 

, Intermediate4 AS (
SELECT 
	YS_BB_package_name
	, DownUpHastighed
	, UpHast
	, DownHast
	, UploadUoverensstemmelse =
		CASE 
			WHEN MB_KB_FROM_Name <> ''  AND MB_KB_GUESS_1_Upload <> MB_KB_From_Name THEN 1
			ELSE 0
		END
	, DownloadUoverensstemmelse =
		CASE
			WHEN MB_KB_From_Name <> '' AND MB_KB_GUESS_1_Download <> MB_KB_From_Name THEN 1
			ELSE 0
		END
	, MB_KB_GUESS_1_Download
	, MB_KB_GUESS_1_Upload
	, MB_KB_From_Name
	, Hastighed1
	, Hastighed2
	, Matcher = 'Ja'	
	, Kombikolonne = 'Nej'
	, YS_BB_technology
FROM Intermediate3
WHERE (MB_KB_From_Name = MB_KB_GUESS_1_Download AND MB_KB_From_Name = MB_KB_GUESS_1_Upload) OR MB_KB_From_Name = ''

UNION ALL

SELECT 
	YS_BB_package_name
	, DownUpHastighed
	, UpHast
	, DownHast
	, UploadUoverensstemmelse =
		CASE 
			WHEN MB_KB_FROM_Name <> ''  AND MB_KB_GUESS_1_Upload <> MB_KB_From_Name THEN 1
			ELSE 0
		END
	, DownloadUoverensstemmelse =
		CASE
			WHEN MB_KB_From_Name <> '' AND MB_KB_GUESS_1_Download <> MB_KB_From_Name THEN 1
			ELSE 0
		END
	, MB_KB_GUESS_1_Download
	, MB_KB_GUESS_1_Upload
	, MB_KB_From_Name
	, Hastighed1
	, Hastighed2
	, Matcher = 'Nej'	
	, Kombikolonne = 
	CASE
		WHEN dbo.udf_GetKb(YS_BB_package_name) LIKE '%Kb%' AND dbo.udf_GetMb(YS_BB_package_name) LIKE '%Mb%'
		THEN 'Ja'
		ELSE 'Nej'
	END 
	, YS_BB_technology
FROM Intermediate3
WHERE (MB_KB_From_Name <> MB_KB_GUESS_1_Download OR MB_KB_From_Name <> MB_KB_GUESS_1_Upload) AND MB_KB_From_Name <> ''
)



, Intermediate5 AS (
SELECT 
	YS_BB_package_name
	, DownUpHastighed
	, Valid =
		CASE
			WHEN Matcher = 'Ja' OR Kombikolonne = 'Ja' THEN 'Best Guess'
			ELSE 'Unsure'
		END
    , MB_KB_GUESS_1_Download
	, MB_KB_GUESS_1_Upload
	, Hastighed1
	, Hastighed2
	, Kombikolonne
	, YS_BB_technology
FROM Intermediate4
)

, Final AS (
SELECT 
	YS_BB_package_name
	, DownUpHastighed
	, DownHastighed =
		CASE 
			WHEN Valid = 'Best Guess' AND MB_KB_GUESS_1_Download = 'MB' THEN Hastighed1 * 1024
			WHEN Valid = 'Best Guess' AND MB_KB_GUESS_1_Download = 'KB' THEN Hastighed1
			WHEN Valid = 'Unsure' THEN Hastighed1 * 1024 -- Vi ser oftest/kun, der er hurtige MB-forbindelser 
		END
	, UpHastighed =
		CASE 
			WHEN Valid = 'Best Guess' AND MB_KB_GUESS_1_Upload = 'MB' THEN Hastighed2 * 1024
			WHEN Valid = 'Best Guess' AND MB_KB_GUESS_1_Upload = 'KB' THEN Hastighed2
			WHEN Valid = 'Unsure' THEN Hastighed2 * 1024 -- Vi ser oftest/kun, der er hurtige MB-forbindelser 
		END
	, DownloadAngivelse = MB_KB_GUESS_1_Download
	, UploadAngivelse = MB_KB_GUESS_1_Upload
	, Valid	
	, Kombikolonne
	, BeAware =
		CASE 
			WHEN Kombikolonne = 'Nej' AND MB_KB_GUESS_1_Download <> MB_KB_GUESS_1_Upload
			THEN 'Ja'
			ELSE 'Nej'
		END
	, YS_BB_technology
FROM Intermediate5

)
, Final_v2 AS (
SELECT
	YS_BB_package_name
	, DownloadHastighed =
		CASE 
			WHEN DownHastighed > UpHastighed THEN DownHastighed
			ELSE UpHastighed
		END
	--, UploadHastighed =
	--	CASE
	--		WHEN DownHastighed < UpHastighed THEN DownHastighed
	--		ELSE UpHastighed
	--	END
--	, DownloadAngivelse
	--, UploadAngivelse
	, AwareOfThisProduct = 
	CASE 
		WHEN BeAware = 'Ja' AND dbo.udf_GetMb(YS_BB_package_name) LIKE '%Mb%' THEN 'Nej'
		WHEN BeAware = 'Ja' AND dbo.udf_GetKb(YS_BB_package_name) LIKE '%Kb%' THEN 'Nej'
		ELSE BeAware
	END
	, YS_BB_technology
FROM Final

)
, YS_Hastighed As (
SELECT
	YS_BB_package_name as YouseeProduktnavn
	, DownloadHastighed =
		CASE 
			WHEN YS_BB_package_name IN
				('TDC Home Internet 1000/500 M, Coax',
				'TDC Erhverv Bredbånd 1000/500, Coax',
				'TDC Home Internet 1000/100 M, Coax',
				'TDC Erhverv Bredbånd 1000/100, Coax') THEN 1000 * 1024
			WHEN YS_BB_package_name = 'TDC MPLS VLAN 1Gbit' THEN 1024 * 1024
			ELSE DownloadHastighed
		END
	, null as UploadHastighed
	, Teknologi = YS_BB_technology 
	, Produktområde = 'YouSee'

FROM Final_v2
) 
,
Hastighed AS (
  SELECT 
	 dbo.udf_GetNumeric2(WS_Fiber_HASTIGHED) as Hastighed
		 , WS_Fiber_HASTIGHED as Produktnavn
		 , Teknologi = 'Fiber'
  FROM csv.BredbaandData
    where WS_Fiber_HASTIGHED <> ''
GROUP BY WS_Fiber_HASTIGHED
	
  UNION ALL
  
  SELECT 
	 dbo.udf_GetNumeric2(WS_Coax_HASTIGHED) as Hastighed
		 , WS_Coax_HASTIGHED as Produktnavn
		 , Teknologi = 'Coax'
  FROM csv.BredbaandData
    where WS_Coax_HASTIGHED <> ''
GROUP BY WS_Coax_HASTIGHED

	UNION ALL

SELECT

---distinct
  Hastighed = 
		CASE
			WHEN LEFT(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED), 1) = '/' and RIGHT(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED), 1) = '/'
			THEN RIGHT(LEFT(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED), LEN(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED))-1), LEN(LEFT(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED), LEN(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED))-1))-1)
			WHEN LEFT(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED), 1) = '/' and RIGHT(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED), 1) <> '/'
			THEN RIGHT(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED), LEN(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED))-1)
			WHEN LEFT(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED), 1) <> '/' and RIGHT(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED), 1) = '/'
			THEN LEFT(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED), LEN(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED))-1)
			WHEN LEFT(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED), 1) <> '/' and RIGHT(dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED), 1) <> '/'
			THEN dbo.udf_GetNumeric2(WS_XDSL_HASTIGHED)
			ELSE ''
		END
, Produktnavn = WS_XDSL_HASTIGHED
, Teknologi = 'DSL'
	
FROM csv.BredbaandData
WHERE WS_XDSL_HASTIGHED <> ''
GROUP BY WS_XDSL_HASTIGHED

 
) 

, Mellemregning AS 
 
 (SELECT 
	Produktnavn
		, Hastighed
		, CHARINDEX('/', Hastighed) charind
		, CASE
			 WHEN Teknologi <> 'DSL' AND CHARINDEX('/', Hastighed) >= 1
			 THEN CAST(LEFT(Hastighed, CHARINDEX('/', Hastighed)-1) as int) * 1024
			 WHEN Teknologi = 'DSL' AND LEN(Hastighed) <= 5 
			 THEN CAST(LEFT(Hastighed, CHARINDEX('/', Hastighed)-1) as int) * 1024
			WHEN CHARINDEX('/', Hastighed) < 1 THEN Hastighed
			 ELSE CAST(LEFT(Hastighed, CHARINDEX('/', Hastighed)-1) as int)
			 END AS MuligDownloadHastighed
		, CASE
			WHEN Teknologi <> 'DSL' 
			THEN CAST(RIGHT(Hastighed, LEN(Hastighed) - CHARINDEX('/', Hastighed)) as int) * 1024
			WHEN Teknologi = 'DSL' AND LEN(Hastighed) <= 5 THEN CAST(RIGHT(Hastighed, LEN(Hastighed) - CHARINDEX('/', Hastighed)) as int) * 1024
			WHEN CHARINDEX('/', Hastighed) < 1 THEN null
			ELSE  CAST(RIGHT(Hastighed, LEN(Hastighed) - CHARINDEX('/', Hastighed)) as int)
		END as MuligUploadHastighed
		, Teknologi
	FROM Hastighed
)
 , WS_Hastighed as (

SELECT 
	Produktnavn
	, DownloadHastighed_KB = 
		CASE 
			WHEN MuligDownloadHastighed < MuligUploadHastighed 
			THEN MuligUploadHastighed
			ELSE MuligDownloadHastighed
		END
	--, UploadHastighed_KB =
	--	CASE
	--		WHEN MuligDownloadHastighed < MuligUploadHastighed
	--		THEN MuligDownloadHastighed
	--		ELSE MuligUploadHastighed
	--	END
	, Teknologi
	, Produktområde = 'Wholesale'
FROM Mellemregning
) 
, Produkter AS (

SELECT 
	Produktnavn
	, DownloadHastighed_KB
	, Teknologi
	, Produktområde
FROM WS_Hastighed

UNION ALL

SELECT 
	Produktnavn = YouseeProduktnavn
	, DownloadHastighed_KB = DownloadHastighed
	, Teknologi
	, Produktområde
FROM YS_Hastighed

--UNION ALL

--SELECT 
--	Produktnavn = 'TDC Business'
--	, DownloadHastighed_KB = NULL
--	, Teknologi = 
--		CASE 
--			WHEN [tek ] IN ('GSHDSL', 'DSL') THEN 'DSL'
--			WHEN [tek ] = 'F' THEN 'Fiber'
--			ELSE [tek ]
--		END
--	, Produktområde = 'TDC Business'
--FROM csv.BusinessProduktHastigheder
)




SELECT 
	BK_Produkt = CAST(UPPER(Produktnavn + '||' + Produktområde) as nvarchar(300))
	, Produktnavn = CAST(PRoduktnavn as nvarchar(100))
	, DownloadHastighed_KB = CAST(DownloadHastighed_KB as numeric(23,1)) 
	, Produktområde = CAST(Produktområde as nvarchar(9))
FROM Produkter
GROUP BY Produktnavn
	, DownloadHastighed_KB 
	, Produktområde