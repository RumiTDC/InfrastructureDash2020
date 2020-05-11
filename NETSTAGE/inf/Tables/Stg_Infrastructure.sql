﻿CREATE TABLE [stg].[Infrastructure] (
    [BK_TDC_KVHX]                                   NVARCHAR (20)  NULL,
    [BK_AnlægsinformationID]                        NVARCHAR (50)  NULL,
    [BK_BBRType]                                    NVARCHAR (1)   NULL,
    [BK_FromTeknologiLag]                           NVARCHAR (250) NULL,
    [BK_FromTeknologi]                              NVARCHAR (250) NULL,
    [BK_ToTeknologi]                                NVARCHAR (250) NULL,
    [BK_FromOperator]                               NVARCHAR (150) NULL,
    [BK_FromOperatorTwoTimeLag]                     NVARCHAR (150) NULL,
    [BK_ToOperator]                                 NVARCHAR (150) NULL,
    [BK_Tredjepartsinfrastruktur]                   NVARCHAR (50)  NULL,
    [BK_Movement]                                   NVARCHAR (20)  NULL,
    [BK_DateFrom]                                   DATE           NULL,
    [BK_DateTo]                                     DATE           NULL,
    [FromToDate_Key]                                NVARCHAR (20)  NULL,
    [BK_Produkt]                                    NVARCHAR (300) NULL,
    [F_Movement]                                    INT            NOT NULL,
    [F_Churn]                                       INT            NOT NULL,
    [ChurnCategoryDSL]                              INT            NULL,
    [ChurnCategoryCoax]                             INT            NULL,
    [ChurnCategoryFiber]                            INT            NULL,
    [ChurnCategoryUtility]                          INT            NULL,
    [ChurnCategoryUdrulning]                        INT            NULL,
    [ChurnCategory]                                 VARCHAR (7)    NOT NULL,
    [F_ChurnTwoTimeLag]                             INT            NOT NULL,
    [F_Nytilgang]                                   INT            NOT NULL,
    [F_Kundevandring]                               INT            NOT NULL,
    [F_Nedgradering]                                INT            NOT NULL,
    [M_DSLChurn]                                    INT            NOT NULL,
    [M_DSLNewCustomer]                              INT            NOT NULL,
    [M_DSLUpgradeToCoax]                            INT            NOT NULL,
    [M_DSLDowngradeFromCoax]                        INT            NOT NULL,
    [M_DSLUpgradeToFiber]                           INT            NOT NULL,
    [M_DSLDowngradeFromFiber]                       INT            NOT NULL,
    [FiberInstalled]                                INT            NOT NULL,
    [FiberInstalledOnOTherInfrastructure]           INT            NOT NULL,
    [CoaxInstalled]                                 INT            NOT NULL,
    [CoaxInstalledOnOTherInfrastructure]            INT            NOT NULL,
    [DSLInstalled]                                  INT            NOT NULL,
    [NoInstallation]                                INT            NOT NULL,
    [HasSubscription]                               INT            NOT NULL,
    [FiberBestPossbile]                             INT            NOT NULL,
    [CoaxBestPossible_WS_YS]                        INT            NOT NULL,
    [CoaxYouseeBestPossible]                        INT            NOT NULL,
    [NoInfrastructure]                              INT            NOT NULL,
    [EWII_Whitelist]                                INT            NOT NULL,
    [Mulig_Kobber_Download_Hastighed]               NUMERIC (18)   NULL,
    [Mulig_Kobber_Download_Hastighed_m_Pairbonding] NUMERIC (20)   NULL,
    [Mulig_Pairbonding]                             INT            NOT NULL,
    [Blacklist_Coax]                                INT            NULL,
    [Whitelist_Coax]                                INT            NULL,
    [IsCurrent]                                     BIT            NULL,
    [WL_Coax_KAPGR_Name]                            VARCHAR (50)   NULL,
    [WL_Coax_BB_Styret_afsaetning]                  VARCHAR (50)   NULL,
    [WL_Coax_Topgruppekode]                         SMALLINT       NULL,
    [WL_Coax_sloejfe]                               VARCHAR (10)   NULL
);







