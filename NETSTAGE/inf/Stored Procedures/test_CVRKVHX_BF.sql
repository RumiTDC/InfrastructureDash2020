

CREATE PROCEDURE [inf].[test_CVRKVHX_BF] as

TRUNCATE TABLE [stg].[Adresse_Inf_BF]
Insert into  [stg].[Adresse_Inf_BF]

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [TDC_KVHX]
      ,map.[cvrnr]
      ,map.[navn_tekst]
      ,[coNavn]
      ,map.[ois_id]
      ,map.[ois_ts]
      ,[ChangedDatetime]
      ,[ValidFromDatetime]
      ,[ValidToDatetime]
      ,[IsCurrent]
      ,[IsDeleted]

	  	   	   
--into  [stg].[test_CVRKVHX_BF]

  FROM [DataMart].[dbo].[KMD_CvrKvhxMapning] MAP

  JOIN [KMDCognitoLocal].[CVR].[Virksomheder] VIR on map.cvrnr = VIR.cvrnr