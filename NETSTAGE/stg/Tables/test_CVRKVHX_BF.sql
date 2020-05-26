CREATE TABLE [stg].[test_CVRKVHX_BF] (
    [TDC_KVHX]          VARCHAR (19)  NOT NULL,
    [cvrnr]             INT           NOT NULL,
    [navn_tekst]        VARCHAR (300) NULL,
    [coNavn]            CHAR (40)     NULL,
    [ois_id]            INT           NOT NULL,
    [ois_ts]            VARCHAR (26)  NOT NULL,
    [ChangedDatetime]   DATETIME      NOT NULL,
    [ValidFromDatetime] DATETIME      NOT NULL,
    [ValidToDatetime]   DATETIME      NULL,
    [IsCurrent]         BIT           NULL,
    [IsDeleted]         BIT           NULL
);

