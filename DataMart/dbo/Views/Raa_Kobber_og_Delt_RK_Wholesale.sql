CREATE VIEW [dbo].[Raa_Kobber_og_Delt_RK_Wholesale]
AS
SELECT 
	[KVHX]
	,[Operatoer]
	,[Product]
	,[LogDatetime]
	,[ValidFromDatetime]
	,[ValidToDatetime]
	,[IsCurrent]
	,[IsDeleted]
FROM [dbo].[Raa_Kobber_og_Delt_RK_Wholesale_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[Raa_Kobber_og_Delt_RK_Wholesale] TO [ColumbusTechnologyInfoReader]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Raa_Kobber_og_Delt_RK_Wholesale] TO [GeneralReportReader]
    AS [dbo];

