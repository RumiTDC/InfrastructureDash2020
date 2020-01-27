CREATE VIEW [dbo].[TDN_Coax]
AS
SELECT 
	[KVHX]
	,[TDN_Antenneforeningen_Vejen]
	,[TDN_Bolignet_Aarhus]
	,[TDN_Comflex]
	,[TDN_ComX_Networks]
	,[TDN_Faaborg_Vest_Antenneforening]
	,[TDN_Glentevejs_Antennelaug]
	,[TDN_GVD_Antenneforening]
	,[TDN_It_Lauget_Parknet]
	,[TDN_Kj_rgaard_Nettet]
	,[TDN_Klarup_Antenneforening]
	,[TDN_Korup_Antenneforening]
	,[TDN_NAL_Medienet]
	,[TDN_Nordby_Antenneforening]
	,[TDN_Skagen_Antennelaug]
	,[TDN_Stofa_bredb_nd]
	,[TDN_YouSee]
	,[Logtime]
FROM [dbo].[TDN_Coax_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[TDN_Coax] TO [BaseDataReader]
    AS [dbo];

