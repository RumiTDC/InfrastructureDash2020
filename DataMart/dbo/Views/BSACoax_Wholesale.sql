

CREATE VIEW [dbo].[BSACoax_Wholesale]
AS
SELECT 
	[KVHX]
	,[LID]
	,[Hastighed]
	,[Operatoer]
	,[LogDatetime]
	,[ValidFromDatetime]
	,[ValidToDatetime]
	,[IsCurrent]
	,[IsDeleted]
FROM [dbo].[BSACoax_Wholesale_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[BSACoax_Wholesale] TO [ColumbusTechnologyInfoReader]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[BSACoax_Wholesale] TO [GeneralReportReader]
    AS [dbo];

