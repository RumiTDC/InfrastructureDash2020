CREATE TABLE [dbo].[TDN_Coax_tbl] (
    [KVHX]                             NVARCHAR (50) NULL,
    [TDN_Antenneforeningen_Vejen]      VARCHAR (50)  NULL,
    [TDN_Bolignet_Aarhus]              NVARCHAR (50) NULL,
    [TDN_Comflex]                      NVARCHAR (50) NULL,
    [TDN_ComX_Networks]                NVARCHAR (50) NULL,
    [TDN_Faaborg_Vest_Antenneforening] NVARCHAR (50) NULL,
    [TDN_Glentevejs_Antennelaug]       NVARCHAR (50) NULL,
    [TDN_GVD_Antenneforening]          NVARCHAR (50) NULL,
    [TDN_It_Lauget_Parknet]            NVARCHAR (50) NULL,
    [TDN_Kj_rgaard_Nettet]             NVARCHAR (50) NULL,
    [TDN_Klarup_Antenneforening]       NVARCHAR (50) NULL,
    [TDN_Korup_Antenneforening]        NVARCHAR (50) NULL,
    [TDN_NAL_Medienet]                 NVARCHAR (50) NULL,
    [TDN_Nordby_Antenneforening]       NVARCHAR (50) NULL,
    [TDN_Skagen_Antennelaug]           NVARCHAR (50) NULL,
    [TDN_Stofa_bredb_nd]               NVARCHAR (50) NULL,
    [TDN_YouSee]                       NVARCHAR (50) NULL,
    [Logtime]                          DATETIME      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [TDN_Coax_tbl_ClusteredIndex]
    ON [dbo].[TDN_Coax_tbl]([KVHX] ASC) WITH (FILLFACTOR = 90);

