CREATE TABLE [dm].[HHI_KVHX] (
    [TDC_KVHX]                           VARCHAR (19)     NOT NULL,
    [DAWA_KVHX]                          VARCHAR (19)     NOT NULL,
    [kommuneKode]                        INT              NULL,
    [KommuneNavn]                        VARCHAR (50)     NULL,
    [vejkode]                            INT              NULL,
    [vejnavn]                            VARCHAR (40)     NULL,
    [husnummer]                          VARCHAR (4)      NOT NULL,
    [etage]                              VARCHAR (2)      NULL,
    [sidedoer]                           VARCHAR (4)      NULL,
    [postnummer]                         VARCHAR (5)      NULL,
    [By]                                 VARCHAR (100)    NULL,
    [LandsdelKode]                       SMALLINT         NULL,
    [LandsdelNavn]                       VARCHAR (50)     NULL,
    [RegionKode]                         SMALLINT         NULL,
    [RegionNavn]                         VARCHAR (50)     NULL,
    [adgadr_id]                          UNIQUEIDENTIFIER NULL,
    [ois_id]                             INT              NULL,
    [In_BBR]                             BIT              NOT NULL,
    [In_BBR_Daekning]                    BIT              NULL,
    [In_MAD]                             BIT              NOT NULL,
    [In_Agillic]                         BIT              NOT NULL,
    [In_BSACoaxBlackList]                BIT              NOT NULL,
    [In_BSACoaxWhiteList]                BIT              NOT NULL,
    [In_BSACoax_WholeSale]               BIT              NOT NULL,
    [In_Columbus_FiberOrders]            BIT              NOT NULL,
    [In_Competitors_PDS]                 BIT              NOT NULL,
    [In_PDS_DKTV]                        BIT              NOT NULL,
    [In_eBSA_VULA_BB_Gensalg_Wholesale]  BIT              NOT NULL,
    [In_Raa_Kobber_og_Delt_RK_Wholesale] BIT              NOT NULL,
    [In_EnergiStyrelsenBredbaand]        BIT              NOT NULL,
    [In_TjekDitNet_Coax]                 BIT              NOT NULL,
    [In_TjekDitNet_Fiber]                BIT              NOT NULL,
    [In_Total_utility_Fiber]             BIT              NOT NULL,
    [In_WhitelistFtthDetail]             BIT              NOT NULL,
    [In_DONG]                            BIT              NOT NULL,
    [ChangedDatetime]                    DATETIME         NOT NULL,
    [ValidFromDatetime]                  DATETIME         NOT NULL,
    [ValidToDatetime]                    DATETIME         NULL,
    [IsCurrent]                          BIT              NULL,
    [IsDeleted]                          BIT              NULL
);


GO
CREATE CLUSTERED INDEX [HHI_KVHX_tbl_ClusteredIndexStage]
    ON [dm].[HHI_KVHX]([TDC_KVHX] ASC) WITH (FILLFACTOR = 90);

