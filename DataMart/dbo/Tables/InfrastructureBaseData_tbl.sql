﻿CREATE TABLE [dbo].[InfrastructureBaseData_tbl] (
    [Filename]                         VARCHAR (50)  NULL,
    [Month]                            DATE          NULL,
    [Adresse_By]                       VARCHAR (100) NULL,
    [Adresse_Etage]                    VARCHAR (5)   NULL,
    [Adresse_Husnummerbogstav]         VARCHAR (5)   NULL,
    [Adresse_Husnummertal]             SMALLINT      NULL,
    [Adresse_Kommunekode]              SMALLINT      NULL,
    [Adresse_Kommunenavn]              VARCHAR (50)  NULL,
    [Adresse_Kvh]                      VARCHAR (20)  NULL,
    [Adresse_Kvhx]                     VARCHAR (20)  NULL,
    [Adresse_Latitude]                 FLOAT (53)    NULL,
    [Adresse_Lokalitet]                VARCHAR (50)  NULL,
    [Adresse_Longitude]                FLOAT (53)    NULL,
    [Adresse_Postnummer]               VARCHAR (5)   NULL,
    [Adresse_Sidedoer]                 VARCHAR (5)   NULL,
    [Adresse_Stednavn]                 VARCHAR (100) NULL,
    [Adresse_Vejkode]                  SMALLINT      NULL,
    [Adresse_Vejnavn]                  VARCHAR (100) NULL,
    [Archetypes_3rd_party]             VARCHAR (10)  NULL,
    [Archetypes_ALL]                   VARCHAR (10)  NULL,
    [BBR_BbrKode]                      SMALLINT      NULL,
    [BBR_Coax_anlaeg_id]               BIGINT        NULL,
    [BBR_Coax_ejer]                    VARCHAR (50)  NULL,
    [BBR_Coax_max_coax_ds]             VARCHAR (50)  NULL,
    [BBR_Coax_max_coax_us]             VARCHAR (50)  NULL,
    [BBR_DSL_Mulig_REV]                BIT           NULL,
    [BBR_Fiber_down_rev]               VARCHAR (20)  NULL,
    [BBR_Fiber_up_rev]                 VARCHAR (20)  NULL,
    [BBR_kobber_downprio_ds]           VARCHAR (20)  NULL,
    [BBR_kobber_downprio_us]           VARCHAR (20)  NULL,
    [BBR_MDU_SDU_rev]                  BIT           NULL,
    [BBR_PB_rev]                       VARCHAR (10)  NULL,
    [BL_Coax]                          BIT           NULL,
    [BL_Coax_Installationsstatus]      SMALLINT      NULL,
    [Business_BB_Tech_Coax]            SMALLINT      NULL,
    [Business_BB_Tech_Fiber]           SMALLINT      NULL,
    [Business_BB_Tech_GSHDSL]          SMALLINT      NULL,
    [Business_BB_Tech_XDSL]            SMALLINT      NULL,
    [Business_BB_Total]                SMALLINT      NULL,
    [WL_Coax]                          SMALLINT      NULL,
    [WL_Coax_Adgang_Andre_BBOperatoer] VARCHAR (5)   NULL,
    [WL_Coax_BB_Styret_afsaetning]     VARCHAR (50)  NULL,
    [WL_Coax_Installationsstatus]      SMALLINT      NULL,
    [WL_Coax_KAPGR_Name]               VARCHAR (50)  NULL,
    [WL_Coax_sloejfe]                  VARCHAR (10)  NULL,
    [WL_Coax_Topgruppekode]            SMALLINT      NULL,
    [WL_Fiber]                         SMALLINT      NULL,
    [WL_Fiber_deselection_reasondate]  VARCHAR (20)  NULL,
    [WL_Fiber_deselection_reasontekst] VARCHAR (50)  NULL,
    [WL_Fiber_digging_length]          FLOAT (53)    NULL,
    [WL_Fiber_kapstik]                 VARCHAR (5)   NULL,
    [WL_Fiber_TDC_DIGG]                SMALLINT      NULL,
    [WLEWII_ejer]                      VARCHAR (20)  NULL,
    [WS_Coax_Antal_pr_KVHX]            SMALLINT      NULL,
    [WS_Coax_HASTIGHED]                VARCHAR (50)  NULL,
    [WS_Coax_OPERATOER]                VARCHAR (50)  NULL,
    [WS_Fiber_Antal_pr_KVHX]           SMALLINT      NULL,
    [WS_Fiber_HASTIGHED]               VARCHAR (50)  NULL,
    [WS_Fiber_Hovedprodukt]            VARCHAR (50)  NULL,
    [WS_Fiber_OPERATOER]               VARCHAR (100) NULL,
    [WS_Fiber_OPERATOER_GROUP]         VARCHAR (100) NULL,
    [WS_RAA_KOBBER]                    VARCHAR (50)  NULL,
    [WS_RAA_KOBBER_OPERATOER]          VARCHAR (50)  NULL,
    [WS_XDSL_Antal_pr_KVHX]            SMALLINT      NULL,
    [WS_XDSL_HASTIGHED]                VARCHAR (100) NULL,
    [WS_XDSL_OPERATOER]                VARCHAR (100) NULL,
    [WS_XDSL_OPERATOER_GROUP]          VARCHAR (100) NULL,
    [YS_Antal_BB_CHB]                  SMALLINT      NULL,
    [YS_BB_antal]                      SMALLINT      NULL,
    [YS_BB_package_name]               VARCHAR (100) NULL,
    [YS_BB_technology]                 VARCHAR (10)  NULL,
    [CreateLogDatetime]                DATETIME2 (7) CONSTRAINT [InfrastructureBaseData_tbl_CreateLogDatetime_DF] DEFAULT (getdate()) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [InfrastructureBaseData_tbl_ClusteredIndex]
    ON [dbo].[InfrastructureBaseData_tbl]([Month] ASC, [Adresse_Kvhx] ASC) WITH (FILLFACTOR = 90);

