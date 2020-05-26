﻿CREATE TABLE [csv].[OK_Base] (
    [KVHX]                    NVARCHAR (20)  NULL,
    [Kommune]                 VARCHAR (50)   NULL,
    [Landsdel]                VARCHAR (50)   NULL,
    [Region]                  VARCHAR (50)   NULL,
    [By]                      VARCHAR (100)  NULL,
    [PostNr]                  VARCHAR (5)    NULL,
    [Vejnavn]                 NVARCHAR (100) NOT NULL,
    [Husnr]                   NVARCHAR (4)   NOT NULL,
    [etage]                   NVARCHAR (2)   NOT NULL,
    [Sidedoernr]              NVARCHAR (4)   NOT NULL,
    [Segment]                 VARCHAR (50)   NULL,
    [Bolig_Erhverv]           NVARCHAR (100) NULL,
    [boligErhverv_DST]        NVARCHAR (28)  NOT NULL,
    [EnhedBoligtype]          NVARCHAR (100) NULL,
    [Ejerforhold]             NVARCHAR (50)  NULL,
    [AdministratorNavn]       NVARCHAR (100) NULL,
    [EjerNavn]                NVARCHAR (100) NULL,
    [Latitude]                FLOAT (53)     NULL,
    [Longitude]               FLOAT (53)     NULL,
    [Fiber_Konkurrende_Owner] VARCHAR (50)   NULL,
    [CLUSTER]                 VARCHAR (50)   NULL,
    [AREA]                    VARCHAR (50)   NULL,
    [WAVE]                    VARCHAR (50)   NULL,
    [Wishlist]                INT            NOT NULL,
    [FiberTDC]                INT            NOT NULL,
    [FiberCompetitor]         INT            NOT NULL
);
