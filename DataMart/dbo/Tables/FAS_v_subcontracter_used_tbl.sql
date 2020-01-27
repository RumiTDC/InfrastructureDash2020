CREATE TABLE [dbo].[FAS_v_subcontracter_used_tbl] (
    [faso]              VARCHAR (20)  NULL,
    [creation_time]     DATETIME      NULL,
    [title]             VARCHAR (200) NULL,
    [s_title]           VARCHAR (200) NULL,
    [fault_id]          VARCHAR (10)  NULL,
    [subcon]            SMALLINT      NULL,
    [ChangedDatetime]   DATETIME      CONSTRAINT [FAS_v_subcontracter_used_ChangedDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidFromDatetime] DATETIME      CONSTRAINT [FAS_v_subcontracter_used_ValidFromDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidToDatetime]   DATETIME      NULL,
    [IsCurrent]         BIT           CONSTRAINT [FAS_v_subcontracter_used_IsCurrent_DF] DEFAULT ((1)) NULL,
    [IsDeleted]         BIT           CONSTRAINT [FAS_v_subcontracter_used_IsDeleted_DF] DEFAULT ((0)) NULL
);


GO
CREATE TRIGGER [dbo].[FAS_v_subcontracter_used_tbl_IsCurrentTrigger]
   ON  [dbo].[FAS_v_subcontracter_used_tbl]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;	

    UPDATE BD
	SET [IsCurrent] = 0
	FROM [dbo].[FAS_v_subcontracter_used_tbl] BD
		JOIN inserted I
			ON I.[faso] = BD.[faso]			
			AND I.[ChangedDatetime] > BD.[ChangedDatetime]					
	WHERE
		BD.[IsCurrent] = 1
END