CREATE VIEW [stage].[v_Fact_MeldteBoliger] AS 

SELECT 
	Kommune
	, [Meldte Boliger]
FROM csv.MeldteBoliger