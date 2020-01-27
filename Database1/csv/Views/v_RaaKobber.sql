--CREATE VIEW [csv].[v_RaaKobber] AS 

--WITH Raakobber as (

----SELECT KVH_X, OPERATØR, PRODUKT
----FROM csv.RaaKobber RK
----INNER JOIN csv.BBData_AlleLinjer AL
----ON RK.KVH_X = AL.Adresse_Kvhx
----)
----, Operatør AS (
--SELECT KVH_X, OPERATØR
--FROM Raakobber
--GROUP BY KVH_X, OPERATØR
--)
--, Countkvhx AS(
--SELECT KVH_X, COUNT(*) cnt
--FROM Operatør
--GROUP BY KVH_X
--)
--, DistinctKvhx AS (
--SELECT KVH_X
--FROM Countkvhx 
--where cnt = 1
--)

--SELECT DISTINCT DK.KVH_X, OPERATØR
--FROM DistinctKvhx DK
--INNER JOIN RaaKobber RK
--ON  DK.KVH_X = RK.KVH_X