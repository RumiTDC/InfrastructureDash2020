







CREATE VIEW [pbi].[Fact_Bredbånd] AS
SELECT [FK_Teknologi]
      ,[FK_Produkt]
      ,[FK_Adresse]
      ,[FK_Operatør]
      ,[FK_BBRType]
	  ,[FK_Anlægsinformation]
	  , FK_Tredjepartsinfrastruktur
	  , FK_Elselskab
	  , FK_TDNFiber
	  , FK_TDNCoax
      ,[M_FiberInstalled]
	  ,[M_FiberInstalledOnOtherInfrastructure]
      ,[M_CoaxInstalled]
	  ,[M_CoaxInstalledOnOtherInfrastructure]
      ,[M_DSLInstalled]
      ,[M_NoInstallation]
      ,[M_HasSubscription]
      ,[M_FiberBestPossible]
      ,[M_CoaxBestPossible_YS]
	  ,[M_CoaxBestPossible_WS_YS]
      ,[M_DSLOnly]
      ,[M_NoInfrastructure]
      ,[M_EWII_Whitelist]
      ,[M_MuligKobber_Download_Hastighed]
      ,[Mulig_Kobber_Download_Hastighed_m_Pairbonding]
      ,[Mulig_Pairbonding]
      ,[Blacklist_Coax]
      ,[Whitelist_Coax]
      ,[Download_Hastighed_Produkt]
      ,[DONG_Omraade]

  FROM [edw].[Fact_Bredbånd]