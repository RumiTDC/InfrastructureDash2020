CREATE TABLE [INF].[Dim_Teknologi] (
    [Teknologi_Key]           INT            NOT NULL,
    [BK_Teknologi]            NVARCHAR (150) NOT NULL,
    [BestPossibleTechnology]  NVARCHAR (50)  NULL,
    [TechnologyInstalled]     NVARCHAR (50)  NULL,
    [GIG_GDS_Coax_Fiber]      NVARCHAR (50)  NULL,
    [DSLType]                 NVARCHAR (20)  NULL,
    [FiberType]               NVARCHAR (20)  NULL,
    [BestTechSort]            INT            NULL,
    [TechnologyInstalledSort] INT            NULL,
    [BTO_Fiber]               INT            NULL,
    [dw_DateTimeCreated]		DATETIME       CONSTRAINT [DF__Dim_Tekno__dw_Da__30592A6F] DEFAULT (getdate()) NULL,
    [dw_DateTimeLoad]			DATETIME       NULL,

    CONSTRAINT [PK_edw_Dim_Teknologi] PRIMARY KEY CLUSTERED ([Teknologi_Key] ASC) WITH (FILLFACTOR = 90)
);

