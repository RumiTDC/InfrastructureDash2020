CREATE TABLE [dbo].[whitelist_ftth_announ_tbl] (
    [KOMMUNENR]      INT          NULL,
    [VEJKODE]        FLOAT (53)   NULL,
    [GADENAVN]       VARCHAR (40) NULL,
    [HUSNR]          FLOAT (53)   NULL,
    [HUSBOGSTAV]     VARCHAR (4)  NULL,
    [ETAGE]          VARCHAR (10) NULL,
    [SIDE]           VARCHAR (10) NULL,
    [POSTNR]         INT          NULL,
    [BYNAVN]         VARCHAR (40) NULL,
    [kvh]            VARCHAR (10) NULL,
    [kvha]           VARCHAR (11) NULL,
    [kvhx]           VARCHAR (17) NULL,
    [fiber_enabled]  VARCHAR (5)  NULL,
    [deselect_code]  VARCHAR (20) NULL,
    [forventet_dato] DATETIME     NULL,
    [Logtime]        DATETIME     CONSTRAINT [whitelist_ftth_announ_tbl_LogtimeDF] DEFAULT (getdate()) NOT NULL
);


GO
CREATE CLUSTERED INDEX [whitelist_ftth_announ_tblClusteredIndex]
    ON [dbo].[whitelist_ftth_announ_tbl]([kvhx] ASC) WITH (FILLFACTOR = 90);

