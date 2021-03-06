﻿CREATE TABLE [dbo].[TDN_Fiber_tbl] (
    [KVHX]                         NVARCHAR (50) NULL,
    [TDN_Antenneforeningen_Vejen]  VARCHAR (50)  NULL,
    [TDN_Bolignet_Aarhus]          NVARCHAR (50) NULL,
    [TDN_ComX_Networks]            NVARCHAR (50) NULL,
    [TDN_It_Lauget_Parknet]        NVARCHAR (50) NULL,
    [TDN_Altibox]                  NVARCHAR (50) NULL,
    [TDN_Andels_net]               NVARCHAR (50) NULL,
    [TDN_Bolig_net]                NVARCHAR (50) NULL,
    [TDN_Cirque]                   NVARCHAR (50) NULL,
    [TDN_Colt_Technology_Services] NVARCHAR (50) NULL,
    [TDN_Connect_me]               NVARCHAR (50) NULL,
    [TDN_Dansk_Kabel_TV]           NVARCHAR (50) NULL,
    [TDN_Dansk_Net]                NVARCHAR (50) NULL,
    [TDN_Fiberby]                  NVARCHAR (50) NULL,
    [TDN_Flexfone]                 NVARCHAR (50) NULL,
    [TDN_Gigabit]                  NVARCHAR (50) NULL,
    [TDN_GlobalConnect]            NVARCHAR (50) NULL,
    [TDN_Info_Connect]             NVARCHAR (50) NULL,
    [TDN_IP_Group]                 NVARCHAR (50) NULL,
    [TDN_ipvision]                 NVARCHAR (50) NULL,
    [TDN_Jaynet]                   NVARCHAR (50) NULL,
    [TDN_Netgroup]                 NVARCHAR (50) NULL,
    [TDN_Nianet]                   NVARCHAR (50) NULL,
    [TDN_Perspektiv_Bredband]      NVARCHAR (50) NULL,
    [TDN_Sagitta]                  NVARCHAR (50) NULL,
    [TDN_Stofa_fiber]              NVARCHAR (50) NULL,
    [TDN_TDC]                      NVARCHAR (50) NULL,
    [TDN_Telenor]                  NVARCHAR (50) NULL,
    [TDN_Telia]                    NVARCHAR (50) NULL,
    [TDN_Waoo_]                    NVARCHAR (50) NULL,
    [TDN_ZebNET]                   NVARCHAR (50) NULL,
    [TDN_Zen_Systems]              NVARCHAR (50) NULL,
    [Logtime]                      DATETIME      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [TDN_Fiber_tbl_ClusteredIndex]
    ON [dbo].[TDN_Fiber_tbl]([KVHX] ASC) WITH (FILLFACTOR = 90);

