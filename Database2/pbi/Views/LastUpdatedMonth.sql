CREATE VIEW [pbi].[LastUpdatedMonth] AS 

SELECT LastUpdatedMonth
FROM [$(EDW_Stage_History)].csv.LastUpdatedMonth