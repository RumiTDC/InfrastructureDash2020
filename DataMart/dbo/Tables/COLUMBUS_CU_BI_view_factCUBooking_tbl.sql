CREATE TABLE [dbo].[COLUMBUS_CU_BI_view_factCUBooking_tbl] (
    [ID]                   INT           NULL,
    [OrdreKategori_key]    SMALLINT      NULL,
    [Ordre_Nummer]         BIGINT        NULL,
    [Booking_Loebe_Nummer] SMALLINT      NULL,
    [Booking_Type_Key]     SMALLINT      NULL,
    [Booking_Dato]         DATE          NULL,
    [Booking_Tid]          TIME (7)      NULL,
    [Lovet_Dato]           DATE          NULL,
    [Udtraek_Dato]         DATE          NULL,
    [Oenske_Dato]          DATE          NULL,
    [Lovet_Start_Tid]      TIME (7)      NULL,
    [Lovet_Slut_Tid]       TIME (7)      NULL,
    [Oenske_Start_Tid]     TIME (7)      NULL,
    [Oenske_Slut_Tid]      TIME (7)      NULL,
    [Booking_Bemaerkning]  VARCHAR (100) NULL,
    [Booking_aarsag_key]   SMALLINT      NULL,
    [Antal_Bookninger]     SMALLINT      NULL,
    [Booking_Interval]     SMALLINT      NULL,
    [ProductID]            VARCHAR (20)  NULL,
    [FromDate]             DATETIME      CONSTRAINT [COLUMBUS_CU_BI_view_factCUBooking_tbl_FromDate_DF] DEFAULT (getdate()) NOT NULL,
    [ToDate]               DATETIME      NULL,
    [IsCurrent]            BIT           CONSTRAINT [COLUMBUS_CU_BI_view_factCUBooking_tbl_IsCurrent_DF] DEFAULT ((1)) NOT NULL,
    [IsDeleted]            BIT           CONSTRAINT [COLUMBUS_CU_BI_view_factCUBooking_tbl_IsDeleted_DF] DEFAULT ((0)) NOT NULL,
    [ChangedDateTime]      DATETIME      CONSTRAINT [COLUMBUS_CU_BI_view_factCUBooking_tbl_ChangedDataTime_DF] DEFAULT (getdate()) NOT NULL
);


GO
CREATE CLUSTERED INDEX [COLUMBUS_CU_BI_view_factCUBooking_tbl_ClusteredIndex]
    ON [dbo].[COLUMBUS_CU_BI_view_factCUBooking_tbl]([FromDate] ASC, [Ordre_Nummer] ASC, [Booking_Loebe_Nummer] ASC) WITH (FILLFACTOR = 90);


GO





CREATE TRIGGER [dbo].[COLUMBUS_CU_BI_view_factCUBooking_tbl_IsCurrentTrigger]
   ON  [dbo].[COLUMBUS_CU_BI_view_factCUBooking_tbl]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;	

    UPDATE BD
	SET [IsCurrent] = 0
	FROM [dbo].[COLUMBUS_CU_BI_view_factCUBooking_tbl] BD
		JOIN inserted I
			ON I.[Ordre_Nummer] = BD.[Ordre_Nummer]	
			AND I.[Booking_Loebe_Nummer] = BD.[Booking_Loebe_Nummer]			
	WHERE
		BD.[IsCurrent] = 1
		AND BD.[ChangedDateTime] < I.[ChangedDateTime]
END