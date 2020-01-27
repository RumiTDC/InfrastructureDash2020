Create view [Outputs].[TelenorDSLOversigt] AS
With TelenorRåKobber AS (

SELECT Adresse_Kvhx
FROM csv.BredbaandData
where WS_RAA_KOBBER_OPERATOER LIKE '%cybercity%'
)

, TelenorEBSAVula AS (

SELECT Adresse_Kvhx
FROM csv.BredbaandData
where WS_XDSL_OPERATOER like '%Telenor%'
)

, DobbeltDSLTelenor AS (

SELECT Adresse_Kvhx
FROM csv.BredbaandData
where WS_RAA_KOBBER_OPERATOER LIKE '%cybercity%' and WS_XDSL_OPERATOER like '%Telenor%'
)
, Final AS (
SELECT T.BestPossibleTechnology, T.TechnologyInstalled, T.GIG_GDS_Coax_Fiber, 
 DSLType = 'Rå Kobber'
FROM [$(edw)].pbi.Fact_Bredbånd B
LEFT JOIN [$(edw)].pbi.Dim_Adresse A
ON B.FK_Adresse = A.Adresse_Key
LEFT JOIN [$(edw)].pbi.Dim_Teknologi T
ON B.FK_Teknologi = T.Teknologi_Key
LEFT JOIN [$(edw)].pbi.Dim_Operatør O
ON B.FK_Operatør = O.Operatør_Key
LEFT JOIN [$(edw)].pbi.Dim_BBRType BBR
ON B.FK_BBRType = BBR.BBRType_Key

where A.Kvhx IN (SELECT * FROM TelenorRåKobber)
AND BBR_Type_Tekst = 'Residential Use'

UNION ALL 

SELECT T.BestPossibleTechnology, T.TechnologyInstalled, T.GIG_GDS_Coax_Fiber, 
DSLType = 'EBSA Vula'
FROM [$(edw)].pbi.Fact_Bredbånd B
LEFT JOIN [$(edw)].pbi.Dim_Adresse A
ON B.FK_Adresse = A.Adresse_Key
LEFT JOIN [$(edw)].pbi.Dim_Teknologi T
ON B.FK_Teknologi = T.Teknologi_Key
LEFT JOIN [$(edw)].pbi.Dim_Operatør O
ON B.FK_Operatør = O.Operatør_Key
LEFT JOIN [$(edw)].pbi.Dim_BBRType BBR
ON B.FK_BBRType = BBR.BBRType_Key

where A.Kvhx IN (SELECT * FROM TelenorEBSAVula)
AND BBR_Type_Tekst = 'Residential Use'

)

SELECT DSLType, BestPossibleTechnology, TechnologyInstalled, GIG_GDS_Coax_Fiber,  
 COUNT(*) Antal
FROM Final
GROUP BY BestPossibleTechnology, TechnologyInstalled, GIG_GDS_Coax_Fiber, DSLType