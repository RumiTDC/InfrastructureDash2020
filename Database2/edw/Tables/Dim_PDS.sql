CREATE TABLE [edw].[Dim_PDS] (
    [PDS_Key]         INT           NOT NULL,
    [BK_PDS]          NVARCHAR (25) NULL,
    [Kvhx]            VARCHAR (20)  NULL,
    [PDS_Operatør]    VARCHAR (25)  NULL,
    [dw_DateCreated]  DATETIME      NULL,
    [dw_DateModified] DATETIME      NULL,
    [dw_LogID]        BIGINT        NULL,
    [dw_LogDetailID]  BIGINT        NULL,
    PRIMARY KEY CLUSTERED ([PDS_Key] ASC) WITH (FILLFACTOR = 90)
);

