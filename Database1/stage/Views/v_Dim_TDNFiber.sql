



CREATE VIEW [stage].[v_Dim_TDNFiber] AS

SELECT  BK_TDNFiber = [KVHX]
, [TDN_Antenneforeningen_Vejen] = CAST([TDN_Antenneforeningen_Vejen] as int) -- Ikke Konkurrerede
      ,[TDN_Bolignet_Aarhus] = CAST([TDN_Bolignet_Aarhus] as int) -- Ikke Konkurrerende
      ,[TDN_ComX_Networks] = CAST([TDN_ComX_Networks] as int) -- Ikke konkurrerende
      ,[TDN_It_Lauget_Parknet] = CAST([TDN_It_Lauget_Parknet] as int) -- Ikke konkurrerende
      ,[TDN_Altibox]				 = cast([TDN_Altibox]					as int)		-- Ikke konkurrerende
      ,[TDN_Andels_net]				= cast([TDN_Andels_net]					as int)	-- ikke konkurrerende
      ,[TDN_Bolig_net]				= cast([TDN_Bolig_net]					as int)-- Ikke Konkurrerende
      ,[TDN_Cirque]					= cast([TDN_Cirque]						as int)	-- Ikke konkurrerende
      ,[TDN_Colt_Technology_Services]= cast([TDN_Colt_Technology_Services]	as int)		-- Ikke konkurrerende
      ,[TDN_Connect_me]				= cast([TDN_Connect_me]					as int)	 -- Ikke konkurrerende
      ,[TDN_Dansk_Kabel_TV]			= cast([TDN_Dansk_Kabel_TV]				as int)		-- Ikke Konkurrerende
      ,[TDN_Dansk_Net]				= cast([TDN_Dansk_Net]					as int)		-- Konkurrerende
      ,[TDN_Fiberby]				= cast([TDN_Fiberby]					as int)		 -- Ikke konkurrerende
      ,[TDN_Flexfone]				= cast([TDN_Flexfone]					as int)	 -- Ikke konkurrerende
      ,[TDN_Gigabit]				= cast([TDN_Gigabit]					as int)		-- Konkurrerende
      ,[TDN_GlobalConnect]			= cast([TDN_GlobalConnect]				as int)		-- Konkurrerende
      ,[TDN_Info_Connect]			= cast([TDN_Info_Connect]				as int)		 -- Ikke konkurrerende
      ,[TDN_IP_Group]				= cast([TDN_IP_Group]					as int)		-- Ikke konkurrerende
      ,[TDN_ipvision]				= cast([TDN_ipvision]					as int)			-- Ikke konkurrerende
      ,[TDN_Jaynet]					= cast([TDN_Jaynet]						as int)			-- Ikke konkurrerende
      ,[TDN_Netgroup]				= cast([TDN_Netgroup]					as int)		 -- Ikke konkurrerende
      ,[TDN_Nianet]					= cast([TDN_Nianet]						as int)			-- Konkurrerende
      ,[TDN_Perspektiv_Bredband]	= cast([TDN_Perspektiv_Bredband]		as int)		-- Ikke Konkurrerende
      ,[TDN_Sagitta]				= cast([TDN_Sagitta]					as int)		-- Ikke Konkurrerende
      ,[TDN_Stofa_fiber]			= cast([TDN_Stofa_fiber]				as int)			 -- Konkurrerende
      ,[TDN_TDC]					= cast([TDN_TDC]						as int)		-- Ikke konkurrerende
      ,[TDN_Telenor]				= cast([TDN_Telenor]					as int)		-- Ikke Konkurrerende
      ,[TDN_Telia]					= cast([TDN_Telia]						as int)		-- Ikke Konkurrerende
      ,[TDN_Waoo_]					= cast([TDN_Waoo_]						as int)		-- Indeholder SE, Fibia og 4 andre udbydere (kan disse udspecificeres?)
      ,[TDN_ZebNET]					 = cast([TDN_ZebNET]						as int)
      ,[TDN_Zen_Systems]			= cast([TDN_Zen_Systems]				as int)		 -- Ikke Konkurrerende	, Konkurrerende_Elselskab =
	, Konkurrerende_Elselskab =		 
		CASE
			WHEN TDN_Dansk_Net = 1 THEN 1
			WHEN TDN_Gigabit = 1 then 1
			WHEN TDN_GlobalConnect = 1 then 1
			WHEN TDN_Nianet = 1 THEN 1
			WHEN TDN_Waoo_ = 1 THEN 1
			ELSE 0
		END 
	 FROM [csv].[TDN_Fiber]

 

  -- Hvis der er gensælger og konkurrerende, kan der måske? lægges en regel på, om der også er TDC-netværk