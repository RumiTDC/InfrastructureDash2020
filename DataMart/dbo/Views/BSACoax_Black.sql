CREATE VIEW [dbo].[BSACoax_Black]
AS
SELECT 
	[AnlaegsId]
	,[Gadenavn]
	,[Husnummer]
	,[Husbogstav]
	,[Etage]
	,[Doer]
	,[Postnummer]
	,[KVHX]
	,[Installationsstatus]
	,[StikType]
FROM [dbo].[BSACoax_Black_tbl] WITH(NOLOCK)