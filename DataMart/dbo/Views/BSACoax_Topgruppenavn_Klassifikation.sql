CREATE VIEW [dbo].[BSACoax_Topgruppenavn_Klassifikation]
AS
SELECT 
	[Topgruppekode]
	,[Topgruppenavn]
	,[Logtime]
FROM [dbo].[BSACoax_Topgruppenavn_Klassifikation_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[BSACoax_Topgruppenavn_Klassifikation] TO [BaseDataReader]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[BSACoax_Topgruppenavn_Klassifikation] TO [GeneralReportReader]
    AS [dbo];

