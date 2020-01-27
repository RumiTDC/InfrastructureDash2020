CREATE TABLE [dbo].[ColumbusFiberOrders_tbl] (
    [KVHX]                    VARCHAR (20)  NULL,
    [CU_ORDRENR]              INT           NOT NULL,
    [CU_LID]                  VARCHAR (20)  NULL,
    [CU_KUSAGKD]              SMALLINT      NULL,
    [CU_ORDREST]              SMALLINT      NULL,
    [CU_ORDDATO]              DATE          NULL,
    [CU_LOEFDATO]             DATE          NULL,
    [CU_OENSKES_UDFOERT_DATO] DATE          NULL,
    [CU_UDFDATO]              DATE          NULL,
    [CU_PRODUCT_NO]           VARCHAR (20)  NULL,
    [CU_SEGMENT]              VARCHAR (20)  NULL,
    [NAME]                    VARCHAR (50)  NULL,
    [CU_KUNDENAVN]            VARCHAR (100) NULL,
    [CU_KUNDEADRESSE]         VARCHAR (200) NULL,
    [CU_KUNDESTEDNAVN]        VARCHAR (100) NULL,
    [CU_KUNDEPOSTNRBY]        VARCHAR (50)  NULL,
    [INSTALLATIONSADRESSE]    VARCHAR (200) NULL,
    [MSISDN]                  BIGINT        NULL,
    [SERVICE_PROVIDER]        VARCHAR (100) NULL,
    [TRANKODE]                VARCHAR (3)   NULL,
    [FIBER_AFV_19]            SMALLINT      NULL,
    [STIK_TYPE]               SMALLINT      NULL,
    [STIK_TEKST]              VARCHAR (20)  NULL,
    [Antal_Kundeinit_ombook]  SMALLINT      NULL,
    [Antal_TDCinit_ombook]    SMALLINT      NULL,
    [Lovet_dato_sidste]       DATE          NULL,
    [FromDate]                DATETIME2 (7) CONSTRAINT [ColumbusFiberOrders_FromDateDF] DEFAULT (getdate()) NOT NULL,
    [ToDate]                  DATETIME2 (7) NULL,
    [IsCurrent]               BIT           CONSTRAINT [ColumbusFiberOrders_IsCurrentDF] DEFAULT ((1)) NOT NULL,
    [IsDeleted]               BIT           CONSTRAINT [ColumbusFiberOrders_IsDeletedDF] DEFAULT ((0)) NOT NULL,
    [LogTime]                 DATETIME      NOT NULL,
    [Annullerings_Dato]       DATE          NULL,
    [ChangedDatetime]         DATETIME      CONSTRAINT [ColumbusFiberOrders_tbl_ChangedDatetime_DF] DEFAULT (getdate()) NOT NULL
);


GO
CREATE CLUSTERED INDEX [ColumbusFiberOrdersClusteredIndex]
    ON [dbo].[ColumbusFiberOrders_tbl]([CU_ORDRENR] ASC, [KVHX] ASC, [FromDate] ASC) WITH (FILLFACTOR = 90);


GO


CREATE TRIGGER [dbo].[ColumbusFiberOrders_IsCurrentTrigger]
   ON  [dbo].[ColumbusFiberOrders_tbl]
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    UPDATE CFO
	SET [IsCurrent] = 0
	FROM [dbo].[ColumbusFiberOrders] CFO
		JOIN inserted I
			ON I.[CU_ORDRENR] = CFO.[CU_ORDRENR]
			AND I.[FromDate] > CFO.[FromDate]
	WHERE
		CFO.[IsCurrent] = 1
END