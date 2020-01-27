CREATE TABLE [dbo].[KommuneKoder_tbl] (
    [Gammel kommunekode]  SMALLINT      NULL,
    [Gammelt kommunenavn] VARCHAR (100) NULL,
    [Ny kommunekode]      SMALLINT      NULL,
    [Nyt kommunenavn]     VARCHAR (100) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [KommuneKoder_tbl_ClusteredIndex]
    ON [dbo].[KommuneKoder_tbl]([Ny kommunekode] ASC, [Gammel kommunekode] ASC) WITH (FILLFACTOR = 90);

