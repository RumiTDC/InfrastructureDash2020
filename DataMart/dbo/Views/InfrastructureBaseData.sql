﻿CREATE VIEW [dbo].[InfrastructureBaseData]
AS
SELECT [Filename]
      ,[Month]
      ,[Adresse_By]
      ,[Adresse_Etage]
      ,[Adresse_Husnummerbogstav]
      ,[Adresse_Husnummertal]
      ,[Adresse_Kommunekode]
      ,[Adresse_Kommunenavn]
      ,[Adresse_Kvh]
      ,[Adresse_Kvhx]
      ,[Adresse_Latitude]
      ,[Adresse_Lokalitet]
      ,[Adresse_Longitude]
      ,[Adresse_Postnummer]
      ,[Adresse_Sidedoer]
      ,[Adresse_Stednavn]
      ,[Adresse_Vejkode]
      ,[Adresse_Vejnavn]
      ,[Archetypes_3rd_party]
      ,[Archetypes_ALL]
      ,[BBR_BbrKode]
      ,[BBR_Coax_anlaeg_id]
      ,[BBR_Coax_ejer]
      ,[BBR_Coax_max_coax_ds]
      ,[BBR_Coax_max_coax_us]
      ,[BBR_DSL_Mulig_REV]
      ,[BBR_Fiber_down_rev]
      ,[BBR_Fiber_up_rev]
      ,[BBR_kobber_downprio_ds]
      ,[BBR_kobber_downprio_us]
      ,[BBR_MDU_SDU_rev]
      ,[BBR_PB_rev]
      ,[BL_Coax]
      ,[BL_Coax_Installationsstatus]
      ,[Business_BB_Tech_Coax]
      ,[Business_BB_Tech_Fiber]
      ,[Business_BB_Tech_GSHDSL]
      ,[Business_BB_Tech_XDSL]
      ,[Business_BB_Total]
      ,[WL_Coax]
      ,[WL_Coax_Adgang_Andre_BBOperatoer]
      ,[WL_Coax_BB_Styret_afsaetning]
      ,[WL_Coax_Installationsstatus]
      ,[WL_Coax_KAPGR_Name]
      ,[WL_Coax_sloejfe]
      ,[WL_Coax_Topgruppekode]
      ,[WL_Fiber]
      ,[WL_Fiber_deselection_reasondate]
      ,[WL_Fiber_deselection_reasontekst]
      ,[WL_Fiber_digging_length]
      ,[WL_Fiber_kapstik]
      ,[WL_Fiber_TDC_DIGG]
      ,[WLEWII_ejer]
      ,[WS_Coax_Antal_pr_KVHX]
      ,[WS_Coax_HASTIGHED]
      ,[WS_Coax_OPERATOER]
      ,[WS_Fiber_Antal_pr_KVHX]
      ,[WS_Fiber_HASTIGHED]
      ,[WS_Fiber_Hovedprodukt]
      ,[WS_Fiber_OPERATOER]
      ,[WS_Fiber_OPERATOER_GROUP]
      ,[WS_RAA_KOBBER]
      ,[WS_RAA_KOBBER_OPERATOER]
      ,[WS_XDSL_Antal_pr_KVHX]
      ,[WS_XDSL_HASTIGHED]
      ,[WS_XDSL_OPERATOER]
      ,[WS_XDSL_OPERATOER_GROUP]
      ,[YS_Antal_BB_CHB]
      ,[YS_BB_antal]
      ,[YS_BB_package_name]
      ,[YS_BB_technology]
  FROM [dbo].[InfrastructureBaseData_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[InfrastructureBaseData] TO [GeneralReportReader]
    AS [dbo];

