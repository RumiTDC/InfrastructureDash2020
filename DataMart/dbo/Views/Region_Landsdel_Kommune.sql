CREATE VIEW [dbo].[Region_Landsdel_Kommune]
AS
	SELECT 
		[Country]
		,[RegionKode]
		,[RegionNavn]
		,[LandsdelKode]
		,[LandsdelNavn]
		,[KommuneKode]
		,[KommuneNavn]
		,[ChangedDatetime]
		,[ValidFromDatetime]
		,[ValidToDatetime]
		,[IsCurrent]
		,[IsDeleted]
	FROM [dbo].[Region_Landsdel_Kommune_tbl] WITH(NOLOCK)