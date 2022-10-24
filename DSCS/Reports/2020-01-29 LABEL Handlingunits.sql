SELECT 
       [ENT].[Id] as [EntId]
      ,[ENT].[Code] as [Code]
      ,isnull([HUI].[Identifier],[ENT].[Code]) as [IdCode]
      ,[ENT].[Description]
      ,[ENT].[Length]
      ,[ENT].[Width]
      ,[ENT].[LotNo]
      ,[ENT].[SerialNo]
      ,[ENT].[ColliNumber]
      ,[WC].[QuantityBase] as [Quantity]
      ,ISNULL([HUT].[Code],'') as [UOMCode]
      ,'' as [UOMName]
      ,[HUT].[Description] as Type
      ,[ENT].[Height]
      ,[ENT].[Weight]
      ,[ENT].[Brutto]
      ,[ENT].[Netto]
      ,[ENT].[Volume]
      ,[ENT].[NumberSeriesId]
      ,[ENT].[Surface]
      ,[ENT].[BaseArea]
      ,[CF].*
      ,[D].*
      ,[BU].[Name] as [BuName]
      ,[BU].[DMSSiteName]
     
  FROM [HandlingUnit] as [ENT]

INNER JOIN [BusinessUnitPermission] [BUP] on [ENT].[id] = [BUP].[HandlingUnitId] and [BUP].[BusinessUnitId] = (select [id] from [BusinessUnit] where [name] = 'DEMO Project Client')--$P{ClientBusinessUnitId} 
INNER join [BusinessUnit] as [BU] on [BUP].[BusinessUnitId] = [BU].[Id] and [BU].[Type]='2'
INNER JOIN [WarehouseContent] [WC] on [ENT].[id]  = [WC].[HandlingUnitId]
LEFT JOIN [HandlingUnitIdentifier] [HUI] on [ENT].[id] = [HUI].[HandlingUnitId]
LEFT JOIN [HandlingUnitType] [HUT] on [ENT].[TypeId] =[HUT].[Id]
left join (
SELECT
[CF].[Name] as [CF_Name], 
ISNULL([T].[text],'')+': '+[CV].[Content] as [CV_Content],
[CV].[EntityId] as [EntityID]
FROM [CustomField] [CF]
INNER JOIN [CustomValue] [CV] ON [CF].[Id] = [CV].[CustomFieldId]
LEFT JOIN [Translation] [T] on [CF].[Id] = [T].[EntityId] and [T].[Language] = 'cs'
WHERE [name] in (select [name] from [CustomField] group by [name]) and [CV].[Entity] = 11
) [SRC]
PIVOT (max([SRC].[CV_Content]) for [SRC].[CF_Name]  in ([Description_EN],[OriginCountry]) -- add customfield names here
        ) as [CF] on [ENT].[id] = [CF].[EntityID]

LEFT JOIN (
SELECT [D].[name], [T].[text]+': '+[DV].[Description]+' ['+DV.Content+']' as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
INNER JOIN [DimensionField] [DF] on [D].[Id] = [DF].[DimensionId]
INNER JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Language] = 'cs' and [T].[Column] = 'name'

WHERE [D].[name] in (select [name] from [Dimension] group by [name])
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Project],[Order],[Order_lines])
        )  as [D] on [ENT].[Id] = [D].[EntityId]





Where [ENT].[Id] ='7c1d98b0-af1f-4989-8d4d-b55ef0a7b1d9'



