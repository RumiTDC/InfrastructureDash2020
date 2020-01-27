CREATE VIEW [pbi].[Dim_Movementtype] AS
SELECT  [MovementType_Key]
      ,[BK_MovementType]
      ,[MovementType]

  FROM [edw].[Dim_MovementType]