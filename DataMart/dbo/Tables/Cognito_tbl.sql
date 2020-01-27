﻿CREATE TABLE [dbo].[Cognito_tbl] (
    [Segment]                        VARCHAR (50)     NULL,
    [Komkode]                        INT              NOT NULL,
    [Vejkode]                        INT              NOT NULL,
    [Vejnavn]                        NVARCHAR (100)   NOT NULL,
    [Husnr]                          NVARCHAR (4)     NOT NULL,
    [etage]                          NVARCHAR (2)     NOT NULL,
    [Sidedoernr]                     NVARCHAR (4)     NOT NULL,
    [Kvhx]                           NVARCHAR (20)    NULL,
    [TDC_Kvhx]                       NVARCHAR (20)    NULL,
    [DAWA_KVHX]                      NVARCHAR (20)    NULL,
    [ADG_ID]                         UNIQUEIDENTIFIER NULL,
    [EAD_ID]                         UNIQUEIDENTIFIER NULL,
    [AntalBygninger]                 INT              NULL,
    [AntalAdgAdresser]               INT              NULL,
    [AntalEnhAdresser]               INT              NULL,
    [TypeBolig]                      NVARCHAR (30)    NULL,
    [UdlejningsforholdKode]          INT              NULL,
    [Udlejningsforhold]              NVARCHAR (100)   NULL,
    [EnhedAnvendelseKode]            INT              NULL,
    [EnhedAnvendelse]                NVARCHAR (200)   NULL,
    [Bolig_Erhverv]                  NVARCHAR (100)   NULL,
    [boligErhverv_DST]               NVARCHAR (28)    NOT NULL,
    [EnhedBoligtypekode]             NVARCHAR (5)     NULL,
    [EnhedBoligtype]                 NVARCHAR (100)   NULL,
    [EjendomVurderingBenyttelseKode] INT              NULL,
    [EjendomVurderingBenyttelse]     NVARCHAR (100)   NULL,
    [Ejendomsnummer]                 INT              NULL,
    [EjerNavn]                       NVARCHAR (100)   NULL,
    [EjerforholdsKode]               INT              NULL,
    [Ejerforhold]                    NVARCHAR (50)    NULL,
    [EjerCVRnummer]                  INT              NULL,
    [AdministratorNavn]              NVARCHAR (100)   NULL,
    [AdministratorCoNavn]            NVARCHAR (100)   NULL,
    [AdministratorAdresse]           NVARCHAR (100)   NULL,
    [AdministratorSuppBynavn]        NVARCHAR (100)   NULL,
    [AdministratorPostnr]            NVARCHAR (100)   NULL,
    [AdministratorCVRnummer]         INT              NULL,
    [VirksomhedNavn]                 NVARCHAR (200)   NULL,
    [VirksomhedKomkode]              SMALLINT         NULL,
    [Virksomhedvejkode]              SMALLINT         NULL,
    [VirksomhedVejnavn]              NVARCHAR (200)   NULL,
    [VirksomhedHusnr]                NVARCHAR (200)   NULL,
    [VirksomhedEtage]                NVARCHAR (200)   NULL,
    [VirksomhedSideDoernr]           NVARCHAR (200)   NULL,
    [VirksomhedBranchekode]          INT              NULL,
    [VirksomhedBranche]              NVARCHAR (200)   NULL,
    [Virksomhedsformkode]            INT              NULL,
    [Virksomhedsform]                NVARCHAR (200)   NULL,
    [VirksomhedAntalMedarbejder]     NVARCHAR (200)   NULL,
    [VirksomhedTelefon]              NVARCHAR (200)   NULL,
    [VirksomhedEmail]                NVARCHAR (200)   NULL,
    [Produktionsenheder]             NVARCHAR (MAX)   NULL,
    [AntalProEnheder]                INT              NULL,
    [ProdEnhPnr]                     INT              NULL,
    [ProdEnhNavn]                    NVARCHAR (200)   NULL,
    [ProdEnhKomkode]                 SMALLINT         NULL,
    [ProdEnhvejkode]                 SMALLINT         NULL,
    [ProdEnhVejnavn]                 NVARCHAR (200)   NULL,
    [ProdEnhHusnr]                   NVARCHAR (200)   NULL,
    [ProdEnhEtage]                   NVARCHAR (200)   NULL,
    [ProdEnhSideDoernr]              NVARCHAR (200)   NULL,
    [ProdEnhBranchekode]             INT              NULL,
    [ProdEnhBranche]                 NVARCHAR (200)   NULL,
    [ProdEnhAntalMedarbejder]        NVARCHAR (200)   NULL,
    [ProdEnhTelefon]                 NVARCHAR (20)    NULL,
    [ProdEnhEmail]                   NVARCHAR (200)   NULL,
    [Hovedafdeling]                  NVARCHAR (3)     NULL,
    [AntalKvhxCVRnr]                 INT              NULL,
    [PostNr]                         VARCHAR (5)      NULL,
    [Latitude]                       FLOAT (53)       NULL,
    [Longitude]                      FLOAT (53)       NULL
);


GO
CREATE CLUSTERED INDEX [Cognito_tblClusteredIndex]
    ON [dbo].[Cognito_tbl]([Kvhx] ASC) WITH (FILLFACTOR = 100);
