﻿CREATE TABLE [inf].[Fact_Kundevandring] (
    [FK_FromTeknologi]        INT           NOT NULL,
    [FK_ToTeknologi]          INT           NOT NULL,
    [FK_Adresse]              INT           NOT NULL,
    [FK_FromOperator]         INT           NOT NULL,
    [FK_ToOperator]           INT           NOT NULL,
    [FK_BBRType]              INT           NOT NULL,
    [FK_FromDate]             INT           NOT NULL,
    [FK_ToDate]               INT           NOT NULL,
    [FK_FromToDatePeriod]     NVARCHAR (20) NOT NULL,
    [FK_Movementtype]         INT           NULL,
    [F_Movement]              INT           NULL,
    [F_Churn]                 INT           NULL,
    [F_Nytilgang]             INT           NULL,
    [F_Kundevandring]         INT           NULL,
    [F_Nedgradering]          INT           NULL,
    [M_DSLChurn]              INT           NOT NULL,
    [M_DSLNewCustomer]        INT           NOT NULL,
    [M_DSLUpgradeToCoax]      INT           NOT NULL,
    [M_DSLDowngradeFromCoax]  INT           NOT NULL,
    [M_DSLUpgradeToFiber]     INT           NOT NULL,
    [M_DSLDowngradeFromFiber] INT           NOT NULL,
    [dw_DateCreated]          DATETIME      NULL
);

