CREATE VIEW [dbo].[BSACoax_White]
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
FROM [dbo].[BSACoax_White_tbl] WITH(NOLOCK)