
CREATE VIEW [dbo].[KundeSegmenterFiberUdrulning]
AS
SELECT [Announced]
      ,[Announcement]
      ,[CAMPAIGN_START_DATE]
      ,[Segment]
      ,[Kvhx]
      ,[TDC_Kvhx]
      ,[DAWA_Kvhx]
	  ,[EjerNavn]
	  ,[PostNr] 		
	  ,[Vejnavn]
	  ,[Husnr]
      ,[Latitude]
      ,[Longitude]
      ,[Bolig_Erhverv]
      ,[boligErhverv_DST]
      ,[EnhedBoligtype]
      ,[Ejerforhold]
      ,[VirksomhedBranche]
      ,[AntalKvhxCVRnr]
      ,[TopGruppeKode]
      ,[COAX Whitelisted]
      ,[DSL Possible]
      ,[XDSL possible]
      ,[Kobber Possible]
      ,[WishListRegistred]
FROM [dbo].[KundeSegmenterFiberUdrulning_tbl]
GO
GRANT SELECT
    ON OBJECT::[dbo].[KundeSegmenterFiberUdrulning] TO [GeneralReportReader]
    AS [dbo];

