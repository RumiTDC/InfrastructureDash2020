
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE procedure [inf].[Dim_Movementtype] AS




SELECT 
FK_Movementtype = 
CAST(
CASE
	WHEN 
		[BK_Movement] = 'Churn'			THEN		101
	WHEN 
		[BK_Movement] = 'Kundevandring'	THEN		102
	WHEN 
		[BK_Movement] = 'Nedgradering'	THEN		103
	WHEN 
		[BK_Movement] = 'Non-Movement'	THEN		104
	WHEN 
		[BK_Movement] = 'Nytilgang'		THEN		105
	
	Else											-1
End
AS smallint)

,	BK_MovementType		= ISNULL([BK_Movement], 'Unknown')
,	[BK_Movement]		= ISNULL([BK_Movement], 'Unknown')

--INTO [inf].[Dim_Movementtype]
FROM [stg].[Infrastructure] BD

GROUP BY
[BK_Movement]