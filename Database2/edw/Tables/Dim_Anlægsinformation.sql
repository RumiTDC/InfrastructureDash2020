CREATE TABLE [edw].[Dim_Anlægsinformation] (
    [Anlægsinformation_Key] INT            NOT NULL,
    [BK_Anlægsinformation]  NVARCHAR (50)  NOT NULL,
    [Yousee Bredbånd]       NVARCHAR (10)  NULL,
    [Topgruppe]             NVARCHAR (1)   NULL,
    [Sloejfe]               NVARCHAR (2)   NULL,
    [Kapgruppe]             NVARCHAR (100) NULL,
    [CMTS]                  NVARCHAR (20)  NULL,
    [dw_DateCreated]        DATETIME       NULL,
    [dw_DateModified]       DATETIME       NULL,
    [dw_LogID]              BIGINT         NULL,
    [dw_LogDetailID]        BIGINT         NULL,
    CONSTRAINT [PK_edw_Dim_Anlægsinformation] PRIMARY KEY CLUSTERED ([Anlægsinformation_Key] ASC) WITH (FILLFACTOR = 90)
);

