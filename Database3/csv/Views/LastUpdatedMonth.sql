CREATE VIEW [csv].[LastUpdatedMonth] AS 

SELECT MAX(HistoryValidDateTimeFrom) LastUpdatedMonth
FROM csv.BredbaandDataForHistory
where HistoryDeletedAtSource = 0