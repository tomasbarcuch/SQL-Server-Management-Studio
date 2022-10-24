SELECT 
       [HU].[Id] as HuId
      ,[HU].[Code]
      ,[HU].[Description]
      ,[HU].[TypeId]
      ,[HU].[ParentHandlingUnitId]
      ,[HU].[Length]
      ,[HU].[Width]
      ,[HU].[Weight]
      ,[HU].[LotNo]
      ,[HU].[SerialNo]
      ,[HU].[ColliNumber]
      ,[HU].[ActualLocationId]
      ,[HU].[ActualZoneId]
      ,[HU].[ActualBinId]
      ,[HU].[Height]
      ,T.[Text] as [Status]
      ,[HU].[PackingRuleType]
      ,[HU].[PackingRuleDimensionId]
      ,[HU].[ShipmentHeaderId]
      ,[HU].[LoadCapacity]
      ,[HU].[Netto]
      ,[HU].[Brutto]
      ,[HU].[Volume]
      ,[HU].[NumberSeriesId]
      ,[HU].[Empty]
      ,[HU].[TopHandlingUnitId]
      ,[HU].[PackingOrderHeaderId]
      ,[HU].[Surface]
      ,[HU].[BaseArea]
      ,[HU].[NettoCalc]
      ,[HU].[BruttoCalc]
      ,[HU].[CapacityCheckDisabled]
      ,DimVal01.Content as [Order]
      ,BU.Name as [BuName]
      ,BU.DMSSiteName as [DMSSiteName]
  FROM [HandlingUnit] as HU

 LEFT OUTER JOIN [Status] S ON S.[Id] = [HU].[StatusId] 
 LEFT OUTER JOIN [Translation] T ON T.[EntityId] = [HU].[StatusId] and T.[Language] = 'de'
 LEFT OUTER JOIN [Location] L ON L.[Id] = [HU].[ActualLocationId] 
 LEFT OUTER JOIN [Zone] Z ON Z.[Id] = [HU].[ActualZoneId] 
 LEFT OUTER JOIN [Bin] B ON B.[Id] = [HU].[ActualBinId]
 LEFT OUTER JOIN (SELECT HandlingUnitId,BusinessUnitId FROM [BusinessUnitPermission] WHERE HandlingUnitId is not null) as BUPlp01 on HU.Id = BUPlp01.HandlingUnitId
 INNER join BusinessUnit as BU on Bu.Id=BUPlp01.BusinessUnitId and BU.[Type]='2'

 left outer join [EntityDimensionValueRelation] Edvr01 on HU.Id = Edvr01.entityid
 left outer join [DimensionValue] as DimVal01 on Edvr01.DimensionValueId = DimVal01.Id
 INNER join [Dimension] as DM01 on DM01.Id=DimVal01.DimensionId and DM01.Name='Order'

 

WHERE HU.id = (Select id from HandlingUnit where code = '2067301904230890')
order by [Code] asc