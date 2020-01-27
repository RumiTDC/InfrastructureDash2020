CREATE TABLE [dbo].[Region_Landsdel_Kommune_tbl] (
    [Country]           VARCHAR (50) NULL,
    [RegionKode]        SMALLINT     NULL,
    [RegionNavn]        VARCHAR (50) NULL,
    [LandsdelKode]      SMALLINT     NULL,
    [LandsdelNavn]      VARCHAR (50) NULL,
    [KommuneKode]       SMALLINT     NULL,
    [KommuneNavn]       VARCHAR (50) NULL,
    [ChangedDatetime]   DATETIME     CONSTRAINT [Region_Landsdel_Kommune_ChangedDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidFromDatetime] DATETIME     CONSTRAINT [Region_Landsdel_Kommune_ValidFromDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidToDatetime]   DATETIME     NULL,
    [IsCurrent]         BIT          CONSTRAINT [Region_Landsdel_Kommune_IsCurrent_DF] DEFAULT ((1)) NULL,
    [IsDeleted]         BIT          CONSTRAINT [Region_Landsdel_Kommune_IsDeleted_DF] DEFAULT ((0)) NULL
);


GO
CREATE CLUSTERED INDEX [Region_Landsdel_Kommune_tbl_ClusteredIndex]
    ON [dbo].[Region_Landsdel_Kommune_tbl]([IsCurrent] ASC, [KommuneKode] ASC) WITH (FILLFACTOR = 90);

