Select 
DB_NAME() as [Current Database]
,[DIM].[Project] as [Projektname]
,[DIM].[Order] as [Auftragsnummer]
,[DIM].[Commission] as [Commission]
,[DIM_ENT].[Project] as [ProjektnameEnt]
,[DIM_ENT].[Order] as [AuftragsnummerEnt]
,[DIM_ENT].[Commission] as [CommissionEnt]
,[Ent].[Id]
,[SHCF].[MaterialNo]
,[SHCF].[Position Number]
,[SHCF].[BOMPosition]
,[HU].[Code] [HuCode]
,[HUT].[Code] [HUType]
,[HU].[Length]
,[HU].[Width]
,[HU].[Height]
,[HU].[Weight] as [HuTara]
,[HU].[Brutto]
,[HU].[Netto]
,[HU].[Surface]
,[HU].[Volume]
,[HU].[BaseArea]
,[ENT].[Entity]
,[ENT].[Code] as [HuLpCode]
,[ENT].[Description] as [LpHuDescription]
,coalesce([WcLp].[QuantityBase],1) as [QuantityBase]
,[ENT].[Weight] as [LpHuWeight]
,coalesce([UoMText].[Text],'stk') as [UoMtrans]
,[StatusText].[Text] as [StsTrans]
,[Bin].[Code] as [HuBin]
,[L].[Code] as [HuLocation]
FROM [HandlingUnit]	as [HU] WITH (NOLOCK)
inner join [BusinessUnitPermission] [BUP] WITH (NOLOCK) on [HU].[Id]=[BUP].[HandlingUnitId] and [BUP].[BusinessUnitId]= (select id from BusinessUnit where name = 'KHU Debrecen') --$P{ClientBusinessUnitID} 
left join [HandlingUnitType] [HUT] WITH (NOLOCK) on [HUT].[Id]=[HU].[TypeId]
inner  JOIN [Status] as [Sts] WITH (NOLOCK) ON [HU].[StatusId] = [Sts].[Id]
left join [Bin] WITH (NOLOCK) on [Bin].[Id]=[HU].[ActualBinId]
left join [Location] [L] WITH (NOLOCK) on [L].[Id]=[HU].[ActualLocationId]
Left JOIN [Translation] [StatusText] WITH (NOLOCK) ON [Sts].[Id] = [StatusText].[EntityId] and [StatusText].[Language] = 'de' --$P{Language}   
and [StatusText].[Entity] = '27' and [StatusText].[Column] = 'Name'

inner join (SELECT 'HU' as 'Entity',[Id],[Code],[Weight],[Description],[ParentHandlingUnitId],NULL as [BaseUnitOfMeasureId]  FROM [HandlingUnit] WITH (NOLOCK) 
UNION
SELECT 'LP' as 'Entity',[Id],[Code],[Weight],[Description],[ActualHandlingUnitId] as [ParentHandlingUnitId] ,[BaseUnitOfMeasureId]  FROM [LoosePart]  WITH (NOLOCK) ) as [ENT] 
on [ENT].[ParentHandlingUnitId]=[BUP].[HandlingUnitId]
left JOIN [WarehouseContent] [WcLp] WITH (NOLOCK) ON [ENT].[Id]=[WcLp].[LoosepartId]
left JOIN [UnitOfMeasure] [UoM] WITH (NOLOCK) ON [ENT].[BaseUnitOfMeasureId] = [UoM].[Id]
LEFT JOIN [Translation] [UoMText] WITH (NOLOCK) ON [UoM].[Id] = [UoMText].[EntityId]  and [UoMText].[Language] = 'de' -- $P{Language}  
and [UoMText].[Entity] ='21' and [UoMText].[Column] = 'Code'

Left join (select * from (
select [D].[Name], [DV].[Content], [EDVR].[EntityId] from [DimensionValue] [DV] WITH (NOLOCK) 
inner join [Dimension] [D] WITH (NOLOCK) on [DV].[DimensionId] = [D].[Id]
inner join [EntityDimensionValueRelation] [EDVR] WITH (NOLOCK) on [DV].[Id] = [EDVR].[DimensionValueId]
where [D].[Name] in ('Project','Order','Commission')
) [SRC] 
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Project],[Order],[Commission])
        )as [Dimension]) as [DIM] on [DIM].[EntityId]=[HU].[Id]

Left join (select * from (
select [D].[Name], [DV].[Content], [EDVR].[EntityId] from [DimensionValue] [DV] WITH (NOLOCK) 
inner join [Dimension] [D] WITH (NOLOCK) on [DV].[DimensionId] = [D].[Id]
inner join [EntityDimensionValueRelation] [EDVR] WITH (NOLOCK) on [DV].[Id] = [EDVR].[DimensionValueId]
where [D].[Name] in ('Project','Order','Commission')
) [SRC] 
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Project],[Order],[Commission])
        )as [Dimension]) as [DIM_ENT] on [DIM_ENT].[EntityId]=[Ent].[Id]


Left join (
SELECT
[CustomField].[Name] as [CF_Name],
[CV].[Content] as [CV_Content],
[CV].[EntityId] as [EntityID]
FROM [CustomField] 
INNER JOIN [CustomValue] [CV] WITH (NOLOCK) ON ([CustomField].[Id] = [CV].[CustomFieldId])
where [Name]in ('MaterialNo','Position Number','BOMPosition') and [CV].[Entity] = 15
) [SRC]
PIVOT (max([SRC].[CV_Content]) for [SRC].[CF_Name]  in ([MaterialNo],[Position Number],[BOMPosition])
        ) as [SHCF] on [ENT].[Id] = [SHCF].[EntityID]
        
        
Where [HU].[Id]= '427f4515-2b96-4f1f-919b-f0c170d21745' --$P{HuId}