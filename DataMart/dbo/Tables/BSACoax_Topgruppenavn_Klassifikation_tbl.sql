CREATE TABLE [dbo].[BSACoax_Topgruppenavn_Klassifikation_tbl] (
    [Topgruppekode] SMALLINT      NOT NULL,
    [Topgruppenavn] VARCHAR (100) NOT NULL,
    [Logtime]       DATETIME      DEFAULT (getdate()) NOT NULL
);

