



/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW inf.[V_Dim_TDNCoax] AS
SELECT BK_TDNCoax = KVHX						
      ,[TDN_Antenneforeningen_Vejen]	  =CAST([TDN_Antenneforeningen_Vejen]		as int)
      ,[TDN_Bolignet_Aarhus]				=CAST([TDN_Bolignet_Aarhus]				as int)
      ,[TDN_Comflex]						=CAST([TDN_Comflex]						as int)
      ,[TDN_ComX_Networks]					=CAST([TDN_ComX_Networks]					as int)
      ,[TDN_Faaborg_Vest_Antenneforening]= CAST([TDN_Faaborg_Vest_Antenneforening]	as int)
      ,[TDN_Glentevejs_Antennelaug]			=CAST([TDN_Glentevejs_Antennelaug]		as int)
      ,[TDN_GVD_Antenneforening]			=CAST([TDN_GVD_Antenneforening]			as int)
      ,[TDN_It_Lauget_Parknet]				=CAST([TDN_It_Lauget_Parknet]				as int)
      ,[TDN_Kj_rgaard_Nettet]				=CAST([TDN_Kj_rgaard_Nettet]				as int)
      ,[TDN_Klarup_Antenneforening]			=CAST([TDN_Klarup_Antenneforening]		as int)
      ,[TDN_Korup_Antenneforening]			=CAST([TDN_Korup_Antenneforening]			as int)
      ,[TDN_NAL_Medienet]					=CAST([TDN_NAL_Medienet]					as int)
      ,[TDN_Nordby_Antenneforening]			=CAST([TDN_Nordby_Antenneforening]		as int)
      ,[TDN_Skagen_Antennelaug]				=CAST([TDN_Skagen_Antennelaug]			as int)
      ,[TDN_Stofa_bredb_nd]					=CAST([TDN_Stofa_bredb_nd]				as int)
      ,[TDN_YouSee]							=CAST([TDN_YouSee]						as int)
	  , KonkCoax =
	  CASE
			WHEN  [TDN_Antenneforeningen_Vejen]			=1
				--OR [TDN_Bolignet_Aarhus]				=1
			--	OR [TDN_Comflex]						=1
			--	OR [TDN_ComX_Networks]					=1
				OR [TDN_Faaborg_Vest_Antenneforening]	=1
				OR [TDN_Glentevejs_Antennelaug]			=1
				OR [TDN_GVD_Antenneforening]			=1
				OR [TDN_It_Lauget_Parknet]				=1
				OR [TDN_Kj_rgaard_Nettet]				=1
				OR [TDN_Klarup_Antenneforening]			=1
				OR [TDN_Korup_Antenneforening]			=1
				OR [TDN_NAL_Medienet]					=1
				OR [TDN_Nordby_Antenneforening]			=1
				OR [TDN_Skagen_Antennelaug]				=1
				OR [TDN_Stofa_bredb_nd]					=1
			THEN 1
			ELSE 0
		END
  FROM [csv].[TDN_Coax]