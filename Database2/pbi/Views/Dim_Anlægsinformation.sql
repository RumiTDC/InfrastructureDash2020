



CREATE View [pbi].[Dim_Anlægsinformation] AS 
SELECT [Anlægsinformation_Key]
      ,[BK_Anlægsinformation]
      ,[Yousee Bredbånd]
      ,[Topgruppe]
      ,Sloejfe
	  , Kapgruppe
	  , CMTS
FROM [edw].[Dim_Anlægsinformation]
where Anlægsinformation_Key NOT IN (-1, -2)