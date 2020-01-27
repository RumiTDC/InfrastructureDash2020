
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [csv].[KonkFiber] AS

SELECT  [KVHX]
	,[TDN_Antenneforeningen_Vejen] -- Ikke Konkurrerede
      ,[TDN_Bolignet_Aarhus] -- Ikke Konkurrerende
      ,[TDN_ComX_Networks] -- Ikke konkurrerende
      ,[TDN_It_Lauget_Parknet] -- Ikke konkurrerende
      ,[TDN_Altibox] -- Ikke konkurrerende
      ,[TDN_Andels_net] -- ikke konkurrerende
      ,[TDN_Bolig_net] -- Ikke Konkurrerende
      ,[TDN_Cirque] -- Ikke konkurrerende
      ,[TDN_Colt_Technology_Services] -- Ikke konkurrerende
      ,[TDN_Connect_me] -- Ikke konkurrerende
      ,[TDN_Dansk_Kabel_TV] -- Ikke Konkurrerende
      ,[TDN_Dansk_Net] -- Konkurrerende
      ,[TDN_Fiberby] -- Ikke konkurrerende
      ,[TDN_Flexfone] -- Ikke konkurrerende
      ,[TDN_Gigabit] -- Konkurrerende
      ,[TDN_GlobalConnect] -- Konkurrerende
      ,[TDN_Info_Connect] -- Ikke konkurrerende
      ,[TDN_IP_Group] -- Ikke konkurrerende
      ,[TDN_ipvision] -- Ikke konkurrerende
      ,[TDN_Jaynet] -- Ikke konkurrerende
      ,[TDN_Netgroup] -- Ikke konkurrerende
      ,[TDN_Nianet] -- Konkurrerende
      ,[TDN_Perspektiv_Bredband] -- Ikke Konkurrerende
      ,[TDN_Sagitta] -- Ikke Konkurrerende
      ,[TDN_Stofa_fiber] -- Konkurrerende
      ,[TDN_TDC] -- Ikke konkurrerende
      ,[TDN_Telenor] -- Ikke Konkurrerende
      ,[TDN_Telia] -- Ikke Konkurrerende
      ,[TDN_Waoo_] -- Indeholder SE, Fibia og 4 andre udbydere (kan disse udspecificeres?)
      ,[TDN_ZebNET]
      ,[TDN_Zen_Systems] -- Ikke Konkurrerende	, Konkurrerende_Elselskab =
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