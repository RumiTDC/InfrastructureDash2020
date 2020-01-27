CREATE VIEW [pbi].[Fact_MeldteBoliger] AS
SELECT  [FK_Kommune]
      ,[M_MeldteBoliger]
    
  FROM [edw].[Fact_MeldteBoliger]