CREATE TABLE [dbo].[Competitors_PDS_Infrastructure_tbl] (
    [KVHX]    VARCHAR (20)  NOT NULL,
    [Selskab] VARCHAR (100) NULL,
    [LogTime] DATETIME2 (7) CONSTRAINT [Competitors_PDS_Infrastructure_tbl_Logtime_DF] DEFAULT (getdate()) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [Competitors_PDS_Infrastructure_tbl_ClusteredIndex]
    ON [dbo].[Competitors_PDS_Infrastructure_tbl]([KVHX] ASC, [Selskab] ASC) WITH (FILLFACTOR = 90);

