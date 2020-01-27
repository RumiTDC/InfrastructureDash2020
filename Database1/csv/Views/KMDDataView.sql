/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [csv].[KMDDataView] AS 

WITH kvhx as (

SELECT

	PreliminaryKvhx = komkode + REPLICATE('0', 4-LEN(Vejkode)) + Vejkode + husnr
	, etage
	, sidedoer = 
		CASE 
			WHEN ISNUMERIC(Sidedoernr) = 1 THEN REPLICATE('0', 4-LEN(Sidedoernr)) + SideDoernr
			ELSE SideDoernr
		END
	, KomKode
	, Vejkode = REPLICATE('0', 4-LEN(Vejkode)) + Vejkode
	, Husnr
	, husnummerbogstav = CASE
							WHEN ISNUMERIC(LEFT(REVERSE(komkode + vejkode + husnr), 1)) = 0
							THEN 1
							ELSE 0
						END
	  ,[ADG_ID]
      ,[EAD_ID]
      ,[AntalBygninger]
      ,[AntalAdgAdresser]
      ,[AntalEnhAdresser]
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
  FROM csv.KMDData

  )
  

  SELECT
		 KVHX =
			CASE 
				
				WHEN kvhx.husnummerbogstav = 1 AND kvhx.Etage = '' AND SideDoer <> '' THEN PreliminaryKvhx + '  ' + UPPER(SideDoer)
				WHEN kvhx.husnummerbogstav = 0 AND kvhx.Etage = '' AND SideDoer <> '' THEN PreliminaryKvhx  + '   ' + UPPER(SideDoer)
				WHEN kvhx.husnummerbogstav = 1 THEN PreliminaryKvhx + UPPER(kvhx.Etage) + UPPER(sidedoer)
				ELSE PreliminaryKvhx + ' ' + UPPER(kvhx.Etage) + UPPER(sidedoer)
			END
		,[ADG_ID]
      ,[EAD_ID]
      ,[AntalBygninger]
      ,[AntalAdgAdresser]
      ,[AntalEnhAdresser]
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
	, Latitude
	, Longitude
	, Postnummer
	, Kommune
	, Kommunekode
FROM kvhx
LEFT JOIN [$(edw)].pbi.Dim_Adresse A
ON 	CASE 
				
				WHEN kvhx.husnummerbogstav = 1 AND kvhx.Etage = '' AND SideDoer <> '' THEN PreliminaryKvhx + '  ' + UPPER(SideDoer)
				WHEN kvhx.husnummerbogstav = 0 AND kvhx.Etage = '' AND SideDoer <> '' THEN PreliminaryKvhx  + '   ' + UPPER(SideDoer)
				WHEN kvhx.husnummerbogstav = 1 THEN PreliminaryKvhx + UPPER(kvhx.Etage) + UPPER(sidedoer)
				ELSE PreliminaryKvhx + ' ' + UPPER(kvhx.Etage) + UPPER(sidedoer)
			END = A.Kvhx