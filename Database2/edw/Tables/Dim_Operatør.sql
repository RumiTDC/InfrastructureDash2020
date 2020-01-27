CREATE TABLE [edw].[Dim_Operatør] (
    [Operatør_Key]       INT            NOT NULL,
    [BK_Operatør]        NVARCHAR (150) NOT NULL,
    [Operatør]           NVARCHAR (50)  NULL,
    [OperatørGruppering] NVARCHAR (50)  NULL,
    [Teknologi]          NVARCHAR (50)  NULL,
    [ServiceProvider]    NVARCHAR (50)  NULL,
    [BTO]                NVARCHAR (20)  NULL,
    [dw_DateCreated]     DATETIME       CONSTRAINT [DF__Dim_Opera__dw_Da__19AACF41] DEFAULT (getdate()) NULL,
    [dw_DateModified]    DATETIME       NULL,
    [dw_LogID]           BIGINT         NULL,
    [dw_LogDetailID]     BIGINT         NULL,
    CONSTRAINT [PK_edw_Dim_Operatør] PRIMARY KEY CLUSTERED ([Operatør_Key] ASC) WITH (FILLFACTOR = 90)
);

