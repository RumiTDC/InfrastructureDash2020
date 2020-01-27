CREATE VIEW [dbo].[whitelist_ftth_raa_adr]
AS
SELECT [ctr]
      ,[node]
      ,[node_s34_x]
      ,[node_s34_y]
      ,[VEJNAVN]
      ,[HUSNR]
      ,[POSTNR]
      ,[POSTDISTRIKT]
      ,[KOMMUNENR]
      ,[VEJKODE]
      ,[adr_utm32ed50_x]
      ,[adr_utm32ed50_y]
      ,[adr_s34_x]
      ,[adr_s34_y]
      ,[aftsand_til_node_meter]
      ,[retning_til_node]
      ,[Logtime]
FROM [dbo].[whitelist_ftth_raa_adr_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[whitelist_ftth_raa_adr] TO [GeneralReportReader]
    AS [dbo];

