CREATE procedure [dbo].[GetDateForDaniel] as
Begin
DROP TABLE #tmp
CREATE TABLE #tmp (
	KomKode float
	,Kommune varchar(255)
)


INSERT INTO #tmp VALUES(259,'Køge')
INSERT INTO #tmp VALUES(329,'Ringsted')
INSERT INTO #tmp VALUES(265,'Roskilde')
INSERT INTO #tmp VALUES(330,'Slagelse')
INSERT INTO #tmp VALUES(370,'Næstved')


DECLARE @EF as VARCHAR(max) = 'A2 Virksomhedsejet,B1 EF - Small,B2 AF - Small,C1 EF - Large,C2 AF - Large,D Almennyttige  boligorganisationer';
SELECT 
S.KVHX,t.KomKode,AL.Adresse_Postnummer,AL.Adresse_Vejnavn,AL.Adresse_Husnummertal,Adresse_Husnummerbogstav,AL.Adresse_Etage,Al.Adresse_Sidedoer,S.Segment,T.Kommune,K.EjerNavn,Ejerforhold,AdministratorNavn,BBR_Coax_anlaeg_id,WL_Coax_Topgruppekode 
FROM [csv].[SegmentKvhx] S 
INNER JOIN	#tmp t ON  S.KomKode  = t.KomKode
LEFT JOIN [csv].[KMDData] K ON K.Kvhx = S.KVHX
INNER JOIN STRING_SPLIT(@EF,',') EF ON S.Segment = EF.[Value]
LEFT JOIN [csv].[BredbaandData] AL ON [dbo].[GenerateDawaKvhxFromKvhx] ('Cognito',K.Kvhx) =[dbo].[GenerateDawaKvhxFromKvhx] ('AlleLinjer',AL.Adresse_Kvhx)

--SELECT top 1000 * FROM csv.BredbaandData
--SELECT top 1000 * FROM 
--SELECT * FROM csv.Anlaegsoversigt

--SELECT 
--SELECT * FROM 
--(SELECT top 1000 'Cognito' as a,* from [csv].[KMDData]) K
--CROSS APPLY 
--( 
--	SELECT [dbo].[GenerateDawaKvhxFromKvhx] (K.a,K.Kvhx) as Dawa 
--) as conv


--SELECT [dbo].[GenerateDawaKvhxFromKvhx] ('Cognito','2596103139040001')


SELECT      c.name  AS 'ColumnName'
            ,t.name AS 'TableName'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%top%'
ORDER BY    TableName
            ,ColumnName;

			SELECT * FROM [csv].[Anlaegsoversigt]

END