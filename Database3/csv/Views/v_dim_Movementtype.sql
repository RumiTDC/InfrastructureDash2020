

CREATE VIEW [csv].[v_dim_Movementtype] AS

SELECT
BK_Movementtype = CAST('Kundevandring' as nvarchar(20))
, Movementtype = CAST('Kundevandring' as nvarchar(20))

UNION ALL

SELECT
BK_Movementtype = CAST('Nytilgang' as nvarchar(20))
, Movementtype = CAST('Nytilgang' as nvarchar(20))

UNION ALL

SELECT
BK_Movementtype = CAST('Churn' as nvarchar(20))
, Movementtype = CAST('Churn' as nvarchar(20))

UNION ALL

SELECT
BK_Movementtype = CAST('Nedgradering' as nvarchar(20))
, Movementtype = CAST('Nedgradering' as nvarchar(20))

UNION ALL

SELECT
BK_Movementtype = CAST('Non-Movement' as nvarchar(20))
, Movementtype = CAST('Non-Movement' as nvarchar(20))