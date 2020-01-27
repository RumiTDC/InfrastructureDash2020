CREATE VIEW [dbo].[whitelist_ftth_announ]
AS
SELECT [KOMMUNENR]
      ,[VEJKODE]
      ,[GADENAVN]
      ,[HUSNR]
      ,[HUSBOGSTAV]
      ,[ETAGE]
      ,[SIDE]
      ,[POSTNR]
      ,[BYNAVN]
      ,[kvh]
      ,[kvha]
      ,[kvhx]
      ,[fiber_enabled]
      ,[deselect_code]
      ,[forventet_dato]
      ,[Logtime]
FROM [dbo].[whitelist_ftth_announ_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[whitelist_ftth_announ] TO [GeneralReportReader]
    AS [dbo];

