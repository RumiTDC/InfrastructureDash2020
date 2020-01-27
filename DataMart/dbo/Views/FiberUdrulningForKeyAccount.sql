CREATE VIEW [dbo].[FiberUdrulningForKeyAccount]
AS
	/*  
	-- 2019-10-04: Info
	-- 38124 Agillic rows
	-- 37754 Joined with Cognito on DAWA_KVHX
	-- 37706 Joined on TDC KVHX
	*/
	SELECT 
		[MatchedInCognito]
		,[MatchedInInfrastructure]
		,[DAWA_KVHX]
		,[TDC_KVHX]
		,[Announcement]
		,[CAMPAIGN_START_DATE]
		,[Segment]
		,[Bolig_Erhverv]
		,[boligErhverv_DST]
		,[EnhedBoligtype]
		,[Ejerforhold]
		,[TopGruppeKode]
	FROM [dbo].[FiberUdrulningForKeyAccount_tbl]
GO
GRANT SELECT
    ON OBJECT::[dbo].[FiberUdrulningForKeyAccount] TO [KeyAccount_FiberUdrulning]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[FiberUdrulningForKeyAccount] TO [GeneralReportReader]
    AS [dbo];

