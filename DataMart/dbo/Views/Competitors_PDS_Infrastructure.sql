CREATE VIEW [dbo].[Competitors_PDS_Infrastructure]
AS
	SELECT 
		[KVHX],
		[Selskab],
		[LogTime]
	FROM [dbo].[Competitors_PDS_Infrastructure_tbl] WITH(NOLOCK)