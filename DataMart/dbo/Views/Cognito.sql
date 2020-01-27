



CREATE VIEW [dbo].[Cognito]
AS
SELECT
	[Segment]
	,[Komkode]
	,[Vejkode]
	,[Vejnavn]
	,[Husnr]
	,[etage]
	,[Sidedoernr]
	,[Kvhx]
	,[TDC_Kvhx]
	,[DAWA_Kvhx]
	,[ADG_ID]
	,[EAD_ID]
	,[AntalBygninger]
	,[AntalAdgAdresser]
	,[AntalEnhAdresser]
	,[TypeBolig]
	,[UdlejningsforholdKode]
	,[Udlejningsforhold]
	,[EnhedAnvendelseKode]
	,[EnhedAnvendelse]
	,[Bolig_Erhverv]
	,[boligErhverv_DST]
	,[EnhedBoligtypekode]
	,[EnhedBoligtype]
	,[EjendomVurderingBenyttelseKode]
	,[EjendomVurderingBenyttelse]
	,[Ejendomsnummer]
	,[EjerNavn]
	,[EjerforholdsKode]
	,[Ejerforhold]
	,[EjerCVRnummer]
	,[AdministratorNavn]
	,[AdministratorCoNavn]
	,[AdministratorAdresse]
	,[AdministratorSuppBynavn]
	,[AdministratorPostnr]
	,[AdministratorCVRnummer]
	,[VirksomhedNavn]
	,[VirksomhedKomkode]
	,[Virksomhedvejkode]
	,[VirksomhedVejnavn]
	,[VirksomhedHusnr]
	,[VirksomhedEtage]
	,[VirksomhedSideDoernr]
	,[VirksomhedBranchekode]
	,[VirksomhedBranche]
	,[Virksomhedsformkode]
	,[Virksomhedsform]
	,[VirksomhedAntalMedarbejder]
	,[VirksomhedTelefon]
	,[VirksomhedEmail]
	,[Produktionsenheder]
	,[AntalProEnheder]
	,[ProdEnhPnr]
	,[ProdEnhNavn]
	,[ProdEnhKomkode]
	,[ProdEnhvejkode]
	,[ProdEnhVejnavn]
	,[ProdEnhHusnr]
	,[ProdEnhEtage]
	,[ProdEnhSideDoernr]
	,[ProdEnhBranchekode]
	,[ProdEnhBranche]
	,[ProdEnhAntalMedarbejder]
	,[ProdEnhTelefon]
	,[ProdEnhEmail]
	,[Hovedafdeling]
	,[AntalKvhxCVRnr]
	,[PostNr]
    ,[Latitude]
    ,[Longitude]
FROM [dbo].[Cognito_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[Cognito] TO [BaseDataReader]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Cognito] TO [CognitoDataReader]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Cognito] TO [GeneralReportReader]
    AS [dbo];

