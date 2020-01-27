


CREATE VIEW [dbo].[ColumbusFiberOrders]
AS
SELECT 
	[KVHX]
	,[CU_ORDRENR]
	,[CU_LID]
	,[CU_KUSAGKD]
	,[CU_ORDREST]
	,[CU_ORDDATO]
	,[CU_LOEFDATO]
	,[CU_OENSKES_UDFOERT_DATO]
	,[Annullerings_Dato] AS [CU_ANNULLERINGS_DATO]
	,[CU_UDFDATO]
	,[CU_PRODUCT_NO]
	,[CU_SEGMENT]
	,[NAME]
	,[CU_KUNDENAVN]
	,[CU_KUNDEADRESSE]
	,[CU_KUNDESTEDNAVN]
	,[CU_KUNDEPOSTNRBY]
	,[INSTALLATIONSADRESSE]
	,[MSISDN]
	,[SERVICE_PROVIDER]
	,[TRANKODE]
	,[FIBER_AFV_19]
	,[STIK_TYPE]
	,[STIK_TEKST]
	,[Antal_Kundeinit_ombook]
    ,[Antal_TDCinit_ombook]
    ,[Lovet_dato_sidste]	
	,[FromDate]
	,[ToDate]
	,[IsCurrent]
	,[IsDeleted]
	,[LogTime]
FROM [dbo].[ColumbusFiberOrders_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[ColumbusFiberOrders] TO [FiberDashBoradDataReader]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ColumbusFiberOrders] TO [GeneralReportReader]
    AS [dbo];

