CREATE TABLE [stg].[Teknologi_Inf] (
    [BK_Teknologi]            NVARCHAR (150) NULL,
    [BestPossibleTechnology]  NVARCHAR (50)  NULL,
    [TechnologyInstalled]     NVARCHAR (50)  NULL,
    [GIG_GDS_Coax_Fiber]      NVARCHAR (50)  NULL,
    [DSLType]                 NVARCHAR (20)  NULL,
    [BestTechSort]            INT            NULL,
    [TechnologyInstalledSort] INT            NULL,
    [BTO_Fiber]               NVARCHAR (1)   NULL,
    [FiberType]               NVARCHAR (20)  NULL,
    [dw_DateTimeLoad]         DATETIME       NOT NULL
);

