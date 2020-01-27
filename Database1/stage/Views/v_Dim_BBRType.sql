




CREATE VIEW [stage].[v_Dim_BBRType] AS

SELECT
	BK_BBRType = CAST(BBR_BbrKode as nvarchar(1))
	, BBR_Type_Tekst =
		CASE
			WHEN BBR_BbrKode = 0 THEN CAST('Ukendt' as nvarchar(25)) 
			WHEN BBR_BbrKode = 1 THEN CAST('Residential Use' as nvarchar(25))
			WHEN BBR_BbrKode = 2 THEN CAST('Non-Residential Use' as nvarchar(25))
			WHEN BBR_BbrKode = 3 THEN CAST('Leisure-time use' as nvarchar(25))
			ELSE ''
		END
FROM csv.BredbaandData
GROUP BY BBR_BbrKode