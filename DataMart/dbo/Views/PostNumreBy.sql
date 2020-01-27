CREATE VIEW [dbo].[PostNumreBy]
AS
	SELECT 
		[Postkode],
		[By]
	FROM [dbo].[PostNumreBy_Tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[PostNumreBy] TO PUBLIC
    AS [dbo];

