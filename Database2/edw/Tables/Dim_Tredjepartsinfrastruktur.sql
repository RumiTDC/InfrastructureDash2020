CREATE TABLE [edw].[Dim_Tredjepartsinfrastruktur] (
    [Tredjepartsinfrastruktur_Key] INT           NOT NULL,
    [BK_Tredjepartsinfrastruktur]  NVARCHAR (50) NULL,
    [Archetypes_3rd_party]         NVARCHAR (5)  NULL,
    [Tredjepartsfiber]             INT           NULL,
    [Tredjepartscoax]              INT           NULL,
    [Archetype_Text]               NVARCHAR (50) NULL,
    [dw_DateCreated]               DATETIME      CONSTRAINT [DF__Dim_Tredj__dw_Da__22401542] DEFAULT (getdate()) NULL,
    [dw_DateModified]              DATETIME      NULL,
    [dw_LogID]                     BIGINT        NULL,
    [dw_LogDetailID]               BIGINT        NULL,
    CONSTRAINT [PK_edw_Tredjepartsinfrastruktur] PRIMARY KEY CLUSTERED ([Tredjepartsinfrastruktur_Key] ASC) WITH (FILLFACTOR = 90)
);

