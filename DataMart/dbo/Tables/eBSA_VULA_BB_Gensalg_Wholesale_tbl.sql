CREATE TABLE [dbo].[eBSA_VULA_BB_Gensalg_Wholesale_tbl] (
    [KVHX]              VARCHAR (20)  NOT NULL,
    [LID]               VARCHAR (20)  NOT NULL,
    [Hastighed]         VARCHAR (50)  NULL,
    [Operatoer]         VARCHAR (100) NULL,
    [LogDatetime]       DATETIME      CONSTRAINT [eBSA_VULA_BB_Gensalg_Wholesale_LogDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidFromDatetime] DATETIME      CONSTRAINT [eBSA_VULA_BB_Gensalg_Wholesale_ValidFromDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidToDatetime]   DATETIME      NULL,
    [IsCurrent]         BIT           CONSTRAINT [eBSA_VULA_BB_Gensalg_Wholesale_IsCurrent_DF] DEFAULT ((1)) NOT NULL,
    [IsDeleted]         BIT           CONSTRAINT [eBSA_VULA_BB_Gensalg_Wholesale_IsDeleted_DF] DEFAULT ((0)) NOT NULL
);


GO
CREATE CLUSTERED INDEX [eBSA_VULA_BB_Gensalg_Wholesale_ClusteredIndex]
    ON [dbo].[eBSA_VULA_BB_Gensalg_Wholesale_tbl]([KVHX] ASC) WITH (FILLFACTOR = 90);


GO



CREATE TRIGGER [dbo].[eBSA_VULA_BB_Gensalg_Wholesale_tbl_IsCurrentTrigger]
   ON  [dbo].[eBSA_VULA_BB_Gensalg_Wholesale_tbl]
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    UPDATE BW
	SET [IsCurrent] = 0
	FROM [dbo].[eBSA_VULA_BB_Gensalg_Wholesale_tbl] BW
		JOIN inserted I
			ON I.[KVHX] = BW.[KVHX]
			AND I.[LID] = BW.[LID]
			AND ISNULL(I.[Hastighed],'') = ISNULL(BW.[Hastighed],'')
			AND ISNULL(I.[Operatoer],'') = ISNULL(BW.[Operatoer],'')
			AND I.[LogDatetime] > BW.[LogDatetime]
	WHERE
		BW.[IsCurrent] = 1
END