






CREATE VIEW [pbi].[Dim_Adresse] AS
SELECT
	[Adresse_Key]
      ,[By]
      ,[Kommunekode]
      ,[Kommune]
      ,[Kvhx]
      ,[Kvh]
      ,[Etage]
      ,[Husnummertal]
      ,[Husnummerbogstav]
	  ,[Sidedør]
      ,[Latitude]
      ,[Longitude]
      ,[Postnummer]
      ,[Vejnavn]
   
	  , [DongKommuner] =
		CASE
			WHEN DongKommuner = 1 THEN 'Yes'
			ELSE 'No'
		END
      ,[EniigPostnummer]
	  , EWIIAdresse
	  , CoaxWhitelist
	  , CoaxBlacklist
	  , FiberWhitelist
	  , FiberWhitelistDeselectionText
	  , MDU_SDU
	  , CoaxAnlaegEjer
	   ,[MDU_50Plus]
      ,[MDU_SDU_Amount]
      ,[IndbyggertalBy]
      ,[Over10KIndbyggereIBy]
	  ,[PB Mulig DSL]
  FROM [edw].[Dim_Adresse]