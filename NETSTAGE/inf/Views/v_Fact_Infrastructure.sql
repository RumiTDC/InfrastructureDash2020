
CREATE view  [inf].[V_Fact_Infrastructure] as
(
select *
FROM [stg].[Infrastructure]
--WHERE [BK_DateTo] is null

)