CREATE TABLE [dbo].[Raa_Kobber_og_Delt_RK_Wholesale_tbl] (
    [KVHX]              VARCHAR (20)  NOT NULL,
    [Operatoer]         VARCHAR (100) NULL,
    [Product]           VARCHAR (50)  NULL,
    [LogDatetime]       DATETIME      CONSTRAINT [Raa_Kobber_og_Delt_RK_Wholesale_LogDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidFromDatetime] DATETIME      CONSTRAINT [Raa_Kobber_og_Delt_RK_Wholesale_ValidFromDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidToDatetime]   DATETIME      NULL,
    [IsCurrent]         BIT           CONSTRAINT [Raa_Kobber_og_Delt_RK_Wholesale_IsCurrent_DF] DEFAULT ((1)) NOT NULL,
    [IsDeleted]         BIT           CONSTRAINT [Raa_Kobber_og_Delt_RK_Wholesale_IsDeleted_DF] DEFAULT ((0)) NOT NULL
);


GO
CREATE CLUSTERED INDEX [Raa_Kobber_og_Delt_RK_Wholesale_ClusteredIndex]
    ON [dbo].[Raa_Kobber_og_Delt_RK_Wholesale_tbl]([KVHX] ASC) WITH (FILLFACTOR = 90);


GO



CREATE TRIGGER [dbo].[Raa_Kobber_og_Delt_RK_Wholesale_tbl_IsCurrentTrigger]
   ON  [dbo].[Raa_Kobber_og_Delt_RK_Wholesale_tbl]
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    UPDATE BW
	SET [IsCurrent] = 0
	FROM [dbo].[Raa_Kobber_og_Delt_RK_Wholesale_tbl] BW
		JOIN inserted I
			ON I.[KVHX] = BW.[KVHX]
			AND ISNULL(I.[Product],'') = ISNULL(BW.[Product],'')
			AND ISNULL(I.[Operatoer],'') = ISNULL(BW.[Operatoer],'')
			AND I.[LogDatetime] > BW.[LogDatetime]
	WHERE
		BW.[IsCurrent] = 1
END