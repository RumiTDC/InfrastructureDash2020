
CREATE VIEW [pbi].[Dim_Tredjepartsinfrastruktur] AS
SELECT [Tredjepartsinfrastruktur_Key]
      ,[BK_Tredjepartsinfrastruktur]
      ,[Archetypes_3rd_party]
      ,Tredjepartsfiber
	  , Tredjepartscoax
      ,[Archetype_Text]
  FROM [edw].[Dim_Tredjepartsinfrastruktur]
  where tredjepartsinfrastruktur_key NOT IN (-1, -2)