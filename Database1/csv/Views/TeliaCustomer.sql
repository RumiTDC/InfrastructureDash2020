CREATE VIEW [csv].[TeliaCustomer] AS 
SELECT 
	KVH_X
	, DSLType =
		CASE
			WHEN LEFT(LID, 2) = 'EB' THEN 'EBSA'
			WHEN LEFT(LID, 2) = 'EV' THEN 'VULA'
			WHEN LEFT(LID, 2) = 'EN' THEN 'RAA KOBBER'
			ELSE ''
		END
FROM csv.TeliaDataBrian