
CREATE VIEW [dbo].[WhitelistFtthDetail_v] as
SELECT 
	[kvhx]
      ,[adr_x]
      ,[adr_y]
      ,[deselection_reason]
      ,[deselection_reason_date]
      ,[infrastruktur_tekst]
      ,[deselection_reason_tekst]
	  ,TDC_DIGG
  FROM [dbo].[WhitelistFtthDetail]
GO
GRANT SELECT
    ON OBJECT::[dbo].[WhitelistFtthDetail_v] TO [GeneralReportReader]
    AS [dbo];

