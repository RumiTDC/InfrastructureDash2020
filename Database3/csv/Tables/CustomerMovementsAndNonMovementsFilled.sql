﻿CREATE TABLE [csv].[CustomerMovementsAndNonMovementsFilled] (
    [BK_Adresse]              NVARCHAR (200) NULL,
    [BK_AnlægsinformationID]  NVARCHAR (50)  NULL,
    [BK_BBRType]              NVARCHAR (1)   NULL,
    [BK_FromTeknologi]        NVARCHAR (250) NULL,
    [BK_ToTeknologi]          NVARCHAR (250) NULL,
    [BK_FromOperator]         NVARCHAR (150) NULL,
    [BK_ToOperator]           NVARCHAR (150) NULL,
    [MovementType]            NVARCHAR (20)  NULL,
    [BK_DateFrom]             DATE           NULL,
    [BK_DateTo]               DATE           NULL,
    [FromToDate_Key]          NVARCHAR (20)  NULL,
    [F_Movement]              INT            NOT NULL,
    [F_Churn]                 INT            NOT NULL,
    [F_Nytilgang]             INT            NOT NULL,
    [F_Kundevandring]         INT            NOT NULL,
    [F_Nedgradering]          INT            NOT NULL,
    [M_DSLChurn]              INT            NOT NULL,
    [M_DSLNewCustomer]        INT            NOT NULL,
    [M_DSLUpgradeToCoax]      INT            NOT NULL,
    [M_DSLDowngradeFromCoax]  INT            NOT NULL,
    [M_DSLUpgradeToFiber]     INT            NOT NULL,
    [M_DSLDowngradeFromFiber] INT            NOT NULL
);

