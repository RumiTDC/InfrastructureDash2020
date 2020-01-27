CREATE TABLE [edw].[Fact_MeldteBoliger] (
    [FK_Kommune]      INT      NOT NULL,
    [M_MeldteBoliger] INT      NULL,
    [dw_DateCreated]  DATETIME CONSTRAINT [DF__Fact_Meld__dw_Da__02FC7413] DEFAULT (getdate()) NULL
);

