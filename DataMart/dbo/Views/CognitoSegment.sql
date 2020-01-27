

CREATE VIEW [dbo].[CognitoSegment]
AS
WITH CountEjerOgKvhx AS(
	SELECT
		C.[EjerNavn] --COLLATE danish_norwegian_cs_as 
		AS [EjerNavn],
		COUNT(KVHX) AS [AntalEjedeKVHX]
	FROM [dbo].[Cognito_tbl] C WITH(NOLOCK)
	WHERE 
		C.[EjerNavn] <> ''
	GROUP BY
		C.[EjerNavn] --COLLATE danish_norwegian_cs_as
)
SELECT
	CASE 
		WHEN [Bolig_Erhverv] = 'Bolig' THEN	CASE
												-------------
												WHEN [TypeBolig] = 'Ingen Adresser' THEN 'Z1 No known addresses'

												WHEN ([Ejerforhold] = 'Private andelsboligforeninger' OR [VirksomhedBranche] = 'Private andelsboligforeninger') AND [AntalEjedeKVHX] > 50 THEN 'C2 AF - Large'
												WHEN ([Ejerforhold] = 'Private andelsboligforeninger' OR [VirksomhedBranche] = 'Private andelsboligforeninger') THEN 'B2 AF - Small'

												WHEN [Ejerforhold] = 'Almen boligorganisation' OR [VirksomhedBranche] ='Almennyttige boligselskaber' THEN 'D Almennyttige  boligorganisationer'
				
												WHEN ([VirksomhedBranche] IN ('Ejerforeninger','Andre organisationer og foreninger i.a.n.') OR [EnhedAnvendelse] = 'Bolig i etageejendom, flerfamiliehus eller to-familiehus') AND [AntalEjedeKVHX] > 50 THEN 'C1 EF - Large' 
												WHEN ([VirksomhedBranche] IN ('Ejerforeninger','Andre organisationer og foreninger i.a.n.') OR [EnhedAnvendelse] = 'Bolig i etageejendom, flerfamiliehus eller to-familiehus') THEN 'B1 EF - Small'

												WHEN ISNULL([Ejerforhold],'') IN ('Region', 'Staten', '', 'Anden primærkommune') THEN 'Z2 Region or state'

												WHEN [Ejerforhold] = 'Privatpersoner, incl. I/S' THEN 'A1 Privatejet'

												WHEN [Ejerforhold] = 'A/S, APS og andre selskaber' OR [VirksomhedBranche] IN ('Udlejning af erhvervsejendomme', 'Anden udlejning af boliger') THEN 'A2 Virksomhedsejet'

												WHEN [Ejerforhold] = 'Andre ejerforhold' AND CHARINDEX('EJERF', C.[EjerNavn]) > 0 AND [AntalEjedeKVHX] > 50 THEN 'C1 EF - Large' 
												WHEN [Ejerforhold] = 'Andre ejerforhold' AND CHARINDEX('EJERF', C.[EjerNavn]) > 0 THEN 'B1 EF - Small'						
												WHEN [Ejerforhold] = 'Andre ejerforhold' AND CHARINDEX('E/F', C.[EjerNavn]) > 0 AND [AntalEjedeKVHX] > 50 THEN 'C1 EF - Large' 
												WHEN [Ejerforhold] = 'Andre ejerforhold' AND CHARINDEX('E/F', C.[EjerNavn]) > 0 THEN 'B1 EF - Small' 																																				
												WHEN [Ejerforhold] = 'Andre ejerforhold' AND CHARINDEX('EJERBO', C.[EjerNavn]) > 0 AND [AntalEjedeKVHX] > 50 THEN 'C1 EF - Large' 
												WHEN [Ejerforhold] = 'Andre ejerforhold' AND CHARINDEX('EJERBO', C.[EjerNavn]) > 0 THEN 'B1 EF - Small' 
												WHEN [Ejerforhold] = 'Andre ejerforhold' AND CHARINDEX('EJERL', C.[EjerNavn]) > 0 AND [AntalEjedeKVHX] > 50 THEN 'C1 EF - Large' 
												WHEN [Ejerforhold] = 'Andre ejerforhold' AND CHARINDEX('EJERL', C.[EjerNavn]) > 0 THEN 'B1 EF - Small' 
												WHEN [Ejerforhold] = 'Andre ejerforhold' AND CHARINDEX('MODEREJ', C.[EjerNavn]) > 0 AND [AntalEjedeKVHX] > 50 THEN 'C1 EF - Large' 
												WHEN [Ejerforhold] = 'Andre ejerforhold' AND CHARINDEX('MODEREJ', C.[EjerNavn]) > 0 THEN 'B1 EF - Small' 
												WHEN [Ejerforhold] = 'Andre ejerforhold' AND CHARINDEX('ANDELS', C.[EjerNavn]) > 0 AND [AntalEjedeKVHX] > 50 THEN 'C1 EF - Large' 
												WHEN [Ejerforhold] = 'Andre ejerforhold' AND CHARINDEX('ANDELS', C.[EjerNavn]) > 0 THEN 'B1 EF - Small' 

												ELSE 'Z0 ' + REPLACE(ISNULL(C.[Ejerforhold],''),' ','')
												---------------------
											END
		ELSE 'Z3 '+ REPLACE(ISNULL(C.[Bolig_Erhverv],''),' ','')
	END AS [Segment]
	,[Kvhx]
	FROM [dbo].[Cognito_tbl] C WITH(NOLOCK)
	LEFT JOIN CountEjerOgKvhx CE
		--ON CE.[EjerNavn] COLLATE danish_norwegian_cs_as = C.[EjerNavn] COLLATE danish_norwegian_cs_as
		ON CE.[EjerNavn] = C.[EjerNavn]
GO
GRANT SELECT
    ON OBJECT::[dbo].[CognitoSegment] TO [BaseDataReader]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[CognitoSegment] TO [GeneralReportReader]
    AS [dbo];

