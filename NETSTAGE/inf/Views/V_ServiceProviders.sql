



Create view [inf].[V_ServiceProviders] as (
Select
	[Fiber Operatør]
      ,[OldServiceProvider] = [Service Provider]
	  ,[Service Provider] =
		CASE 
			WHEN 
				[Service Provider] = 'Stofa' AND Teknologi = 'Coax'
			THEN 'Boxer'
		ELSE
			[Service Provider]
		END
      ,[Teknologi]


 FROM [csv].[ServiceProviders]
)