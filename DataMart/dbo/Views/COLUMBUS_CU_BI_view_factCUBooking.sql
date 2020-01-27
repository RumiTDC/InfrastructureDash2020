CREATE VIEW [dbo].[COLUMBUS_CU_BI_view_factCUBooking]
AS
SELECT [ID]
      ,[OrdreKategori_key]
      ,[Ordre_Nummer]
      ,[Booking_Loebe_Nummer]
      ,[Booking_Type_Key]
      ,[Booking_Dato]
      ,[Booking_Tid]
      ,[Lovet_Dato]
      ,[Udtraek_Dato]
      ,[Oenske_Dato]
      ,[Lovet_Start_Tid]
      ,[Lovet_Slut_Tid]
      ,[Oenske_Start_Tid]
      ,[Oenske_Slut_Tid]
      ,[Booking_Bemaerkning]
      ,[Booking_aarsag_key]
      ,[Antal_Bookninger]
      ,[Booking_Interval]
      ,[ProductID]
      ,[FromDate]
      ,[ToDate]
      ,[IsCurrent]
      ,[IsDeleted]
      ,[ChangedDateTime]
FROM [dbo].[COLUMBUS_CU_BI_view_factCUBooking_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[COLUMBUS_CU_BI_view_factCUBooking] TO [FiberDashBoradDataReader]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[COLUMBUS_CU_BI_view_factCUBooking] TO [GeneralReportReader]
    AS [dbo];

