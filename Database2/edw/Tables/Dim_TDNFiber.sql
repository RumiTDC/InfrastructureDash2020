﻿CREATE TABLE [edw].[Dim_TDNFiber] (
    [TDNFiber_Key]                 INT           NOT NULL,
    [BK_TDNFiber]                  NVARCHAR (50) NULL,
    [TDN_Antenneforeningen_Vejen]  INT           NULL,
    [TDN_Bolignet_Aarhus]          INT           NULL,
    [TDN_ComX_Networks]            INT           NULL,
    [TDN_It_Lauget_Parknet]        INT           NULL,
    [TDN_Altibox]                  INT           NULL,
    [TDN_Andels_net]               INT           NULL,
    [TDN_Bolig_net]                INT           NULL,
    [TDN_Cirque]                   INT           NULL,
    [TDN_Colt_Technology_Services] INT           NULL,
    [TDN_Connect_me]               INT           NULL,
    [TDN_Dansk_Kabel_TV]           INT           NULL,
    [TDN_Dansk_Net]                INT           NULL,
    [TDN_Fiberby]                  INT           NULL,
    [TDN_Flexfone]                 INT           NULL,
    [TDN_Gigabit]                  INT           NULL,
    [TDN_GlobalConnect]            INT           NULL,
    [TDN_Info_Connect]             INT           NULL,
    [TDN_IP_Group]                 INT           NULL,
    [TDN_ipvision]                 INT           NULL,
    [TDN_Jaynet]                   INT           NULL,
    [TDN_Netgroup]                 INT           NULL,
    [TDN_Nianet]                   INT           NULL,
    [TDN_Perspektiv_Bredband]      INT           NULL,
    [TDN_Sagitta]                  INT           NULL,
    [TDN_Stofa_fiber]              INT           NULL,
    [TDN_TDC]                      INT           NULL,
    [TDN_Telenor]                  INT           NULL,
    [TDN_Telia]                    INT           NULL,
    [TDN_Waoo_]                    INT           NULL,
    [TDN_ZebNET]                   INT           NULL,
    [TDN_Zen_Systems]              INT           NULL,
    [Konkurrerende_Elselskab]      INT           NULL,
    [dw_DateCreated]               DATETIME      NULL,
    [dw_DateModified]              DATETIME      NULL,
    [dw_LogID]                     BIGINT        NULL,
    [dw_LogDetailID]               BIGINT        NULL,
    CONSTRAINT [PK_edw_Dim_TDNFiber] PRIMARY KEY CLUSTERED ([TDNFiber_Key] ASC) WITH (FILLFACTOR = 90)
);
