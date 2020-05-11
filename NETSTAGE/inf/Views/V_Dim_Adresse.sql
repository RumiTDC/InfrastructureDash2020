










CREATE view [inf].[V_Dim_Adresse] as (
Select
		[TDC_KVHX]
      ,[By]
	  ,[Kommunenavn]
      ,[Kommunekode]
      ,[Etage]
      ,[husnummer]
      ,[sidedoer]
      ,[Latitude]
      ,[Longitude]
      ,[Postnummer]
      ,[Vejnavn]
      ,[DongKommuner]
      ,[ois_id]
      ,[In_BBR]
      ,[BBR_Type_Tekst]
      ,[In_BBR_Daekning]
      ,[In_MAD]
      ,[In_Agillic]
      ,[In_BSACoaxBlackList]
      ,[In_BSACoaxWhiteList]
      ,[In_BSACoax_WholeSale]
      ,[In_Columbus_FiberOrders]
      ,[In_Competitors_PDS]
      ,[In_PDS_DKTV]
      ,[In_eBSA_VULA_BB_Gensalg_Wholesale]
      ,[In_Raa_Kobber_og_Delt_RK_Wholesale]
      ,[In_EnergiStyrelsenBredbaand]
      ,[In_TjekDitNet_Coax]
      ,[In_TjekDitNet_Fiber]
      ,[In_Total_utility_Fiber]
      ,[In_WhitelistFtthDetail]
      ,[EWII_Adresse]
      ,[CoaxWhitelist]
      ,[FiberWhitelist]
      ,[CoaxBlacklist]
      ,[MDU_SDU]
      ,[CoaxAnlaegEjer]
      ,[FiberWhitelistDeselectionText]
      ,[MDU_50Plus]
      ,[MDU_SDU_amount]
      ,[IndbyggertalBy]
      ,[Over10KIndbyggereIBy]
      ,[PB_Mulig]
      ,[El-selskab]
	  ,[BBRUSE]
	  ,[PDS_Operatør]
	  , [TDNCoax] 
		,[TDNFiber]
		,[Fiberudrulning]
	    FROM [stg].[Adresse_Inf]
)