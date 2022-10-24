SELECT 
       [ENT].[Id] as [EntId]
      ,[ENT].[Code] as [Code]
      ,isnull([LPI].[Identifier],[ENT].[Code]) as [IdCode]
      ,[ENT].[Description]
      ,[ENT].[Length]
      ,[ENT].[Width]
      ,[ENT].[Weight]
      ,[ENT].[LotNo]
      ,[ENT].[SerialNo]
      ,[WC].[QuantityBase] as [Quantity]
      ,[UOMCode].[Text] as [UOMCode]
      ,[UOMName].[Text] as [UOMName]
      ,[ENT].[Height]
      ,[ENT].[Weight] as [Netto]
      ,[ENT].[Volume]
      ,[ENT].[NumberSeriesId]
      ,[ENT].[Surface]
      ,[ENT].[BaseArea]
      ,[CF].*
      ,[D].*
      ,[BU].[Name] as [BuName]
      ,[BU].[DMSSiteName]
     
  FROM [Loosepart] as [ENT]

INNER JOIN [BusinessUnitPermission] [BUP] on [ENT].[id] = [BUP].[LoosePartId] and [BUP].[BusinessUnitId] = (select [id] from [BusinessUnit] where [name] = 'DEMO Project Client')--$P{ClientBusinessUnitId} 
INNER join [BusinessUnit] as [BU] on [BUP].[BusinessUnitId] = [BU].[Id] and [BU].[Type]='2'
INNER join [UnitOfMeasure] [UOM] on [ENT].[BaseUnitOfMeasureId] = [UOM].[Id]   
INNER JOIN [WarehouseContent] [WC] on [ENT].[id]  = [WC].[LoosePartId]
LEFT JOIN [LoosepartIdentifier] [LPI] on [ENT].[id] = [LPI].[LoosepartId]
LEFT JOIN [Translation] [UOMName] on [UOM].[Id] = [UOMName].[EntityId] and [UOMName].[Language] = $P{Language}  and [UOMName].[Column] = 'Name'
LEFT JOIN [Translation] [UOMCode] on [UOM].[Id] = [UOMCode].[EntityId] and [UOMCode].[Language] = $P{Language}  and [UOMCode].[Column] = 'Code'
left join (
SELECT
[CF].[Name] as [CF_Name], 
ISNULL([T].[text],'')+': '+[CV].[Content] as [CV_Content],
[CV].[EntityId] as [EntityID]
FROM [CustomField] [CF]
INNER JOIN [CustomValue] [CV] ON [CF].[Id] = [CV].[CustomFieldId]
LEFT JOIN [Translation] [T] on [CF].[Id] = [T].[EntityId] and [T].[Language] = $P{Language} 
WHERE [name] in (select [name] from [CustomField] group by [name]) and [CV].[Entity] = 15
) [SRC]
PIVOT (max([SRC].[CV_Content]) for [SRC].[CF_Name]  in ([Description_EN],[OriginCountry])
        ) as [CF] on [ENT].[id] = [CF].[EntityID]

LEFT JOIN (
SELECT [D].[name], [T].[text]+': '+[DV].[Description]+' ['+DV.Content+']' as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
INNER JOIN [DimensionField] [DF] on [D].[Id] = [DF].[DimensionId]
INNER JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Language] = $P{Language}  and [T].[Column] = 'name'

WHERE [D].[name] in (select [name] from [Dimension] group by [name])
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Project],[Order],[Order_lines])
        )  as [D] on [ENT].[Id] = [D].[EntityId]



--WHERE $X{IN, [Ent].[Id], LoosePartIDs}

Where [ENT].[Id] ='47134e4b-3213-4c86-b3c1-3e1c6e066330'



