






CREATE VIEW [stage].[v_Dim_Tredjepartsinfrastruktur] as 
SELECT 
	BK_Tredjepartsinfrastruktur = CAST(Archetypes_3rd_party as nvarchar(50))
	, Archetypes_3rd_party = CAST(Archetypes_3rd_party as nvarchar(5))
	, Archetype_Text =
	 CASE
		WHEN Archetypes_3rd_party = 'H3' THEN CAST('TDC Fiber HP w/o. comp. fiber or coax' as nvarchar(50))
		WHEN archetypes_3rd_party = 'H5' THEN CAST('Competitor Fiber HC'				   as nvarchar(50))
		WHEN archetypes_3rd_party = 'H6' THEN CAST('Competitor Fiber HP w/o TDC Coax'	   as nvarchar(50))
		WHEN archetypes_3rd_party = 'H7' THEN CAST('Competitor Fiber HP w TDC Coax'		   as nvarchar(50))
		WHEN archetypes_3rd_party = 'H9' THEN CAST('Competitor coax HH'					   as nvarchar(50))
		WHEN archetypes_3rd_party = 'H10'THEN CAST('Competitor coax HH w/ pr. network'	   as nvarchar(50))
		WHEN archetypes_3rd_party = 'B10'THEN CAST('Comp. coax business w/ pr. network'	   as nvarchar(50))
		WHEN archetypes_3rd_party = 'B3' THEN CAST('TDC fiber bus. passed w/ comp.'		   as nvarchar(50))
		WHEN archetypes_3rd_party = 'B5' THEN CAST(''									   as nvarchar(50))
		WHEN archetypes_3rd_party = 'B6' THEN CAST('Comp. fiber bus. passed – w/o TDC coax'as nvarchar(50))
		WHEN archetypes_3rd_party = 'B7' THEN CAST('Comp. Fiber b. passed – w/ TDC coax'   as nvarchar(50))
		WHEN archetypes_3rd_party = 'B9' THEN CAST('Comp. coax business'				   as nvarchar(50))
		WHEN archetypes_3rd_party = 'I10'THEN CAST('Comp. coax business w/ pr. network'	   as nvarchar(50))
		WHEN archetypes_3rd_party = 'I3' THEN CAST('TDC fiber bus. passed w/ comp.'		   as nvarchar(50))
		WHEN archetypes_3rd_party = 'I6' THEN CAST('Comp. fiber b. passed – w/o TDC coax'  as nvarchar(50))
		WHEN Archetypes_3rd_party = 'I7' THEN CAST('Comp. Fiber b. passed – w/ TDC coax'   as nvarchar(50))
		ELSE ''
	END		
		, Tredjepartsfiber =
		CASE 
			WHEN Archetypes_3rd_party IN ('B6', 'B7', 'H5', 'H6', 'H7', 'I3', 'I6', 'I7')
			THEN CAST(1 as int)
			ELSE CAST(0 as int)
		END
	, Tredjepartscoax =
		CASE
			WHEN Archetypes_3rd_party IN ('B10', 'B9', 'H10', 'H9', 'I10')
			THEN CAST(1 as int)
			ELSE CAST(0 as int)
		END	
  FROM [csv].[BredbaandData]
  where Archetypes_3rd_party is not null
  group by Archetypes_3rd_party