CREATE TABLE [dbo].[Infrastructure_NuudayData_tbl] (
    [Adresse_Kvh]             VARCHAR (11)  NULL,
    [Adresse_Kvhx]            VARCHAR (17)  NULL,
    [Archetypes_3rd_party]    VARCHAR (5)   NULL,
    [Archetypes_ALL]          VARCHAR (10)  NULL,
    [Business_BB_Tech_Coax]   SMALLINT      NULL,
    [Business_BB_Tech_Fiber]  SMALLINT      NULL,
    [Business_BB_Tech_GSHDSL] SMALLINT      NULL,
    [Business_BB_Tech_XDSL]   SMALLINT      NULL,
    [Business_BB_Total]       SMALLINT      NULL,
    [YS_BB_Antal]             SMALLINT      NULL,
    [YS_BB_Produktnr]         VARCHAR (200) NULL,
    [YS_BB_Produktteknologi]  VARCHAR (10)  NULL,
    [YS_Nyeste_dato]          DATE          NULL,
    [Koerselsdato]            DATE          NULL,
    [ChangedDatetime]         DATETIME      CONSTRAINT [Infrastructure_NuudayData_ChangedDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidFromDatetime]       DATETIME      CONSTRAINT [Infrastructure_NuudayData_ValidFromDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidToDatetime]         DATETIME      NULL,
    [IsCurrent]               BIT           CONSTRAINT [Infrastructure_NuudayData_IsCurrent_DF] DEFAULT ((1)) NULL,
    [IsDeleted]               BIT           CONSTRAINT [Infrastructure_NuudayData_IsDeleted_DF] DEFAULT ((0)) NULL
);


GO
CREATE CLUSTERED INDEX [Infrastructure_NuudayData_tbl_ClusteredIndex]
    ON [dbo].[Infrastructure_NuudayData_tbl]([Adresse_Kvhx] ASC) WITH (FILLFACTOR = 90);


GO





CREATE TRIGGER [dbo].[Infrastructure_NuudayData_tbl_IsCurrentTrigger]
   ON  [dbo].[Infrastructure_NuudayData_tbl]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;	

    UPDATE BD
	SET [IsCurrent] = 0
	FROM [dbo].[Infrastructure_NuudayData_tbl] BD
		JOIN inserted I
			ON I.[Adresse_Kvhx] = BD.[Adresse_Kvhx]			
			AND I.[ChangedDatetime] > BD.[ChangedDatetime]					
	WHERE
		BD.[IsCurrent] = 1
END