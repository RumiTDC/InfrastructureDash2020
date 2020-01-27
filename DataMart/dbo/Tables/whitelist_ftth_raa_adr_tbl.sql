CREATE TABLE [dbo].[whitelist_ftth_raa_adr_tbl] (
    [ctr]                    VARCHAR (200) NULL,
    [node]                   VARCHAR (200) NULL,
    [node_s34_x]             FLOAT (53)    NULL,
    [node_s34_y]             FLOAT (53)    NULL,
    [VEJNAVN]                VARCHAR (40)  NULL,
    [HUSNR]                  VARCHAR (4)   NULL,
    [POSTNR]                 INT           NULL,
    [POSTDISTRIKT]           VARCHAR (40)  NULL,
    [KOMMUNENR]              INT           NULL,
    [VEJKODE]                VARCHAR (4)   NULL,
    [adr_utm32ed50_x]        FLOAT (53)    NULL,
    [adr_utm32ed50_y]        FLOAT (53)    NULL,
    [adr_s34_x]              FLOAT (53)    NULL,
    [adr_s34_y]              FLOAT (53)    NULL,
    [aftsand_til_node_meter] INT           NULL,
    [retning_til_node]       VARCHAR (30)  NULL,
    [Logtime]                DATETIME      CONSTRAINT [whitelist_ftth_raa_adr_tbl_LogtimeDF] DEFAULT (getdate()) NOT NULL
);


GO
CREATE CLUSTERED INDEX [whitelist_ftth_raa_adr_tblClusteredIndex]
    ON [dbo].[whitelist_ftth_raa_adr_tbl]([node] ASC) WITH (FILLFACTOR = 90);

