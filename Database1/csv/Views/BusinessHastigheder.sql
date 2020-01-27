

CREATE VIEW [csv].[BusinessHastigheder] AS 
SELECT DISTINCT  --[C-nummer]
      Produktnavn = [Tekst]
      ,DownloadHastighed_KB = [Hastighed] * 1024
      ,Teknologi =
		CASE
			WHEN [tek ] = 'F' THEN 'Fiber'
			WHEN [tek ] = 'GSHDSL' THEN 'DSL'
			WHEN [tek ] = 'XDSL' THEN 'DSL'
			ELSE [tek ] 
		END
	  , Produktområde = 'Erhverv'
  FROM [csv].[BusinessProduktHastigheder]
  where  [C-nummer] <> 'C0011319016'