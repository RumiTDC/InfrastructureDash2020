CREATE TABLE [edw].[Dim_Elselskab] (
    [Elselskab_Key]   INT           NOT NULL,
    [BK_Elselskab]    NVARCHAR (40) NOT NULL,
    [Kvhx]            NVARCHAR (40) NULL,
    [Elselskab]       NVARCHAR (10) NULL,
    [dw_DateCreated]  DATETIME      NULL,
    [dw_DateModified] DATETIME      NULL,
    [dw_LogID]        BIGINT        NULL,
    [dw_LogDetailID]  BIGINT        NULL,
    CONSTRAINT [PK_edw_Dim_Elselskab] PRIMARY KEY CLUSTERED ([Elselskab_Key] ASC) WITH (FILLFACTOR = 90)
);

