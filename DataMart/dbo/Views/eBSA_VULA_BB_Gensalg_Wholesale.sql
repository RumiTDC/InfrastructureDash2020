CREATE VIEW [dbo].[eBSA_VULA_BB_Gensalg_Wholesale]
AS
SELECT [KVHX]
      ,[LID]
      ,[Hastighed]
      ,[Operatoer]
      ,[LogDatetime]
      ,[ValidFromDatetime]
      ,[ValidToDatetime]
      ,[IsCurrent]
      ,[IsDeleted]
FROM [dbo].[eBSA_VULA_BB_Gensalg_Wholesale_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[eBSA_VULA_BB_Gensalg_Wholesale] TO [ColumbusTechnologyInfoReader]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[eBSA_VULA_BB_Gensalg_Wholesale] TO [GeneralReportReader]
    AS [dbo];

