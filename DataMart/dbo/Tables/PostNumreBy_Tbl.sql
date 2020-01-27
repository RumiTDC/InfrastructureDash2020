CREATE TABLE [dbo].[PostNumreBy_Tbl] (
    [Postkode] VARCHAR (4)   NULL,
    [By]       VARCHAR (100) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PostNumreBy_Tbl_ClusteredIndex]
    ON [dbo].[PostNumreBy_Tbl]([Postkode] ASC) WITH (FILLFACTOR = 90);

