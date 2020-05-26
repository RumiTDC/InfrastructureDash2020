CREATE TABLE [dbo].[BSACoax_Anlaeg_tbl] (
    [CMTS Id]                                VARCHAR (20)  NULL,
    [KAPGR Name]                             VARCHAR (100) NULL,
    [OLT NQA Name]                           VARCHAR (20)  NULL,
    [AnlaegsId]                              BIGINT        NULL,
    [BB Styret Afsaetning]                   VARCHAR (100) NULL,
    [Adgang for Andre Bredbaandsoperatoerer] VARCHAR (5)   NULL,
    [Bredbaand U/TV]                         VARCHAR (5)   NULL,
    [Docsis Type]                            VARCHAR (5)   NULL,
    [MaxDownSpeed]                           BIGINT        NULL,
    [MaxUpSpeed]                             BIGINT        NULL,
    [Topgruppekode]                          SMALLINT      NULL,
    [Forsyningspostnummer]                   VARCHAR (5)   NULL,
    [Installations adresser]                 INT           NULL,
    [Anlaeggets Forventet IdriftDato]        DATE          NULL,
    [Anlaeggets IdriftDato]                  DATE          NULL,
    [Anlaeggets InAktivDato]                 DATE          NULL,
    [Preinstalleret Modem]                   VARCHAR (4)   NULL,
    [SLOEJFE]                                VARCHAR (2)   NULL,
    [ChangedDatetime]                        DATETIME      CONSTRAINT [BSACoax_Anlaeg_ChangedDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidFromDatetime]                      DATETIME      CONSTRAINT [BSACoax_Anlaeg_ValidFromDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidToDatetime]                        DATETIME      NULL,
    [IsCurrent]                              BIT           CONSTRAINT [BSACoax_Anlaeg_IsCurrent_DF] DEFAULT ((1)) NULL,
    [IsDeleted]                              BIT           CONSTRAINT [BSACoax_Anlaeg_IsDeleted_DF] DEFAULT ((0)) NULL
);




GO
CREATE TRIGGER [dbo].[BSACoax_Anlaeg_tbl_IsCurrentTrigger]
   ON  [dbo].[BSACoax_Anlaeg_tbl]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;	

    UPDATE BD
	SET 
		[IsCurrent] = 0,
		[ValidToDatetime] = I.[ValidFromDatetime],
		[ChangedDatetime] = GETDATE()
	FROM [dbo].[BSACoax_Anlaeg_tbl] BD
		JOIN inserted I
			ON I.[AnlaegsId] = BD.[AnlaegsId]			
			AND I.[ChangedDatetime] > BD.[ChangedDatetime]					
	WHERE
		BD.[IsCurrent] = 1
END