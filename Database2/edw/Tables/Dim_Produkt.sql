CREATE TABLE [edw].[Dim_Produkt] (
    [Produkt_Key]          INT             NOT NULL,
    [BK_Produkt]           NVARCHAR (300)  NOT NULL,
    [Produktnavn]          NVARCHAR (200)  NULL,
    [DownloadHastighed_KB] NUMERIC (23, 1) NULL,
    [Produktområde]        NVARCHAR (9)    NULL,
    [dw_DateCreated]       DATETIME        CONSTRAINT [DF__Dim_Produ__dw_Da__1C873BEC] DEFAULT (getdate()) NULL,
    [dw_DateModified]      DATETIME        NULL,
    [dw_LogID]             BIGINT          NULL,
    [dw_LogDetailID]       BIGINT          NULL,
    CONSTRAINT [PK_edw_Dim_Produkt] PRIMARY KEY CLUSTERED ([Produkt_Key] ASC) WITH (FILLFACTOR = 90)
);

