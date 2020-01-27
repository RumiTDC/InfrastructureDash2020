CREATE TABLE [edw].[Dim_BBRType] (
    [BBRType_Key]     INT           NOT NULL,
    [BK_BBRType]      NVARCHAR (1)  NOT NULL,
    [BBR_Type_Tekst]  NVARCHAR (25) NULL,
    [dw_DateCreated]  DATETIME      CONSTRAINT [DF__Dim_BBRTy__dw_Da__16CE6296] DEFAULT (getdate()) NULL,
    [dw_DateModified] DATETIME      NULL,
    [dw_LogID]        BIGINT        NULL,
    [dw_LogDetailID]  BIGINT        NULL,
    CONSTRAINT [PK_edw_Dim_BBRType] PRIMARY KEY CLUSTERED ([BBRType_Key] ASC) WITH (FILLFACTOR = 90)
);

