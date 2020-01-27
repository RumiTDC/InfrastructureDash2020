CREATE TABLE [dbo].[FiberUdrulningForKeyAccount_tbl] (
    [MatchedInCognito]        INT            NOT NULL,
    [MatchedInInfrastructure] INT            NOT NULL,
    [DAWA_KVHX]               CHAR (19)      NULL,
    [TDC_KVHX]                VARCHAR (20)   NULL,
    [Announcement]            VARCHAR (50)   NULL,
    [CAMPAIGN_START_DATE]     DATE           NULL,
    [Segment]                 VARCHAR (50)   NULL,
    [Bolig_Erhverv]           NVARCHAR (100) NULL,
    [boligErhverv_DST]        NVARCHAR (28)  NULL,
    [EnhedBoligtype]          NVARCHAR (100) NULL,
    [Ejerforhold]             NVARCHAR (50)  NULL,
    [TopGruppeKode]           SMALLINT       NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [FiberUdrulningForKeyAccount_tbl_seekIdx_I]
    ON [dbo].[FiberUdrulningForKeyAccount_tbl]([DAWA_KVHX] ASC) WITH (FILLFACTOR = 90);


GO
CREATE UNIQUE CLUSTERED INDEX [FiberUdrulningForKeyAccount_tbl_ClusteredIndex]
    ON [dbo].[FiberUdrulningForKeyAccount_tbl]([TDC_KVHX] ASC) WITH (FILLFACTOR = 90);

