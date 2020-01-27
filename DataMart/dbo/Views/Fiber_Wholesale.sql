CREATE VIEW [dbo].[Fiber_Wholesale]
AS
SELECT 
	[KVHX]
	,[LID]
	,[Hastighed]
	,[Operatoer]
	,[Hovedprodukt]
	,[LogDatetime]
	,[ValidFromDatetime]
	,[ValidToDatetime]
	,[IsCurrent]
	,[IsDeleted]
FROM [dbo].[Fiber_Wholesale_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[Fiber_Wholesale] TO [ColumbusTechnologyInfoReader]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Fiber_Wholesale] TO [GeneralReportReader]
    AS [dbo];

