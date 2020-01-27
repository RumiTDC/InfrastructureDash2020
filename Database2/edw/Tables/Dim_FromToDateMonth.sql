CREATE TABLE [edw].[Dim_FromToDateMonth] (
    [FromToDateMonth_Key] INT            NOT NULL,
    [BK_FromToDateMonth]  NVARCHAR (100) NOT NULL,
    [YearMonth]           INT            NOT NULL,
    [FromYearMonth]       INT            NOT NULL,
    [ToYearMonth]         INT            NOT NULL,
    [dw_DateCreated]      DATETIME       CONSTRAINT [DF__Dim_FromT__dw_Da__59904A2C] DEFAULT (getdate()) NULL,
    [dw_DateModified]     DATETIME       NULL,
    [dw_LogID]            BIGINT         NULL,
    [dw_LogDetailID]      BIGINT         NULL,
    CONSTRAINT [PK_edw_Dim_FromToDateMonth] PRIMARY KEY CLUSTERED ([FromToDateMonth_Key] ASC) WITH (FILLFACTOR = 90)
);

