﻿CREATE TABLE [edw].[Dim_Adresse_Churn] (
    [Adresse_Key]                   INT              NOT NULL,
    [BK_Adresse]                    NVARCHAR (200)   NOT NULL,
    [By]                            NVARCHAR (20)    NULL,
    [Kommunekode]                   INT              NULL,
    [Kommune]                       NVARCHAR (20)    NULL,
    [Kvhx]                          NVARCHAR (40)    NULL,
    [Kvh]                           NVARCHAR (15)    NULL,
    [Etage]                         NVARCHAR (2)     NULL,
    [Husnummertal]                  INT              NULL,
    [Husnummerbogstav]              NVARCHAR (1)     NULL,
    [Sidedør]                       NVARCHAR (5)     NULL,
    [Latitude]                      NUMERIC (18, 10) NULL,
    [Longitude]                     NUMERIC (18, 10) NULL,
    [Postnummer]                    INT              NULL,
    [Vejnavn]                       NVARCHAR (50)    NULL,
    [DongKommuner]                  INT              NULL,
    [EniigPostnummer]               NVARCHAR (20)    NULL,
    [EWIIAdresse]                   NVARCHAR (10)    NULL,
    [CoaxWhitelist]                 NVARCHAR (1)     NULL,
    [CoaxBlacklist]                 NVARCHAR (1)     NULL,
    [FiberWhitelist]                NVARCHAR (1)     NULL,
    [MDU_SDU]                       NVARCHAR (10)    NULL,
    [MDU_50Plus]                    INT              NULL,
    [MDU_SDU_Amount]                INT              NULL,
    [IndbyggertalBy]                INT              NULL,
    [Over10KIndbyggereIBy]          INT              NULL,
    [CoaxAnlaegEjer]                NVARCHAR (10)    NULL,
    [PB Mulig DSL]                  INT              NULL,
    [FiberWhitelistDeselectionText] NVARCHAR (40)    NULL,
    [dw_DateCreated]                DATETIME         NULL,
    [dw_DateModified]               DATETIME         NULL,
    [dw_LogID]                      BIGINT           NULL,
    [dw_LogDetailID]                BIGINT           NULL,
    [El-selskab]                    NVARCHAR (100)   NULL
);

