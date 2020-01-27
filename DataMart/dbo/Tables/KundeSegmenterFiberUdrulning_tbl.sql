CREATE TABLE [dbo].[KundeSegmenterFiberUdrulning_tbl] (
    [Announced]           INT            NOT NULL,
    [Announcement]        VARCHAR (50)   NULL,
    [CAMPAIGN_START_DATE] DATE           NULL,
    [Segment]             VARCHAR (50)   NULL,
    [Kvhx]                NVARCHAR (20)  NULL,
    [TDC_Kvhx]            NVARCHAR (20)  NULL,
    [DAWA_Kvhx]           NVARCHAR (20)  NULL,
    [Latitude]            FLOAT (53)     NULL,
    [Longitude]           FLOAT (53)     NULL,
    [Bolig_Erhverv]       NVARCHAR (100) NULL,
    [boligErhverv_DST]    NVARCHAR (28)  NOT NULL,
    [EnhedBoligtype]      NVARCHAR (100) NULL,
    [Ejerforhold]         NVARCHAR (50)  NULL,
    [VirksomhedBranche]   NVARCHAR (200) NULL,
    [AntalKvhxCVRnr]      INT            NULL,
    [TopGruppeKode]       SMALLINT       NULL,
    [COAX Whitelisted]    INT            NULL,
    [DSL Possible]        INT            NOT NULL,
    [XDSL possible]       INT            NOT NULL,
    [Kobber Possible]     INT            NOT NULL,
    [WishListRegistred]   INT            NOT NULL,
    [EjerNavn]            NVARCHAR (100) NULL,
    [PostNr]              NVARCHAR (5)   NULL,
    [Vejnavn]             NVARCHAR (100) NULL,
    [Husnr]               NVARCHAR (4)   NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20191016-151129]
    ON [dbo].[KundeSegmenterFiberUdrulning_tbl]([DAWA_Kvhx] ASC) WITH (FILLFACTOR = 90);


GO
CREATE CLUSTERED INDEX [ClusteredIndex-20191016-151102]
    ON [dbo].[KundeSegmenterFiberUdrulning_tbl]([TDC_Kvhx] ASC) WITH (FILLFACTOR = 90);

