CREATE TABLE [edw].[Dim_MovementType] (
    [MovementType_Key] INT           NOT NULL,
    [BK_MovementType]  NVARCHAR (40) NOT NULL,
    [MovementType]     NVARCHAR (20) NULL,
    [dw_DateCreated]   DATETIME      NULL,
    [dw_DateModified]  DATETIME      NULL,
    [dw_LogID]         BIGINT        NULL,
    [dw_LogDetailID]   BIGINT        NULL,
    CONSTRAINT [PK_edw_Dim_MovementType] PRIMARY KEY CLUSTERED ([MovementType_Key] ASC) WITH (FILLFACTOR = 90)
);

