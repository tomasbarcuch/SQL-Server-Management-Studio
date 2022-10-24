DECLARE @Login as NVARCHAR(250) = 'tomas.barcuch'
DECLARE @Language as VARCHAR(2) = 'de'
DECLARE @VolumeUnitDec as INT = 3



SELECT 
       U.[Login]
      ,[ENT].[Id] as [EntId]
      ,[ENT].[Code] as [Code]
      ,[ENT].[Description]
      ,[ENT].[Length]*DUOM.BasicUnitCoef [Length]
      ,[ENT].[Width]*DUOM.BasicUnitCoef [Width]
      ,[ENT].[Height]*DUOM.BasicUnitCoef [Height]
      ,B.Text BasicUnitName
      ,[ENT].[Weight]*DUOM.WeightUnitCoef [Weight]
      ,[ENT].[Brutto]*DUOM.WeightUnitCoef [Brutto]
      ,[ENT].[Netto]*DUOM.WeightUnitCoef [Netto]
      ,W.Text WeightUnitName 
      ,[ENT].[Volume]*DUOM.VolumeUnitCoef [Volume]
      ,V.Text VolumeUnitName
      ,[ENT].[Surface]*DUOM.AreaUnitCoef [Surface]
      ,[ENT].[BaseArea]*DUOM.AreaUnitCoef [BaseArea]
      ,A.Text AreaUnitName
      ,[ENT].[LotNo]
      ,[ENT].[SerialNo]
      ,[ENT].[ColliNumber]
      ,[WC].[QuantityBase] as [Quantity]
      ,ISNULL([HUT].[Code],'') as [UOMCode]
      ,'' as [UOMName]
      ,[HUT].[Description] as Type
      ,[CF].*
      ,[D].*
      ,[CUSTOMER].Customer as Client
       ,BU.name as ClientBusinessUnitName
       ,PackerBusinessUnitName = (select name from BusinessUnit where id = 'a896347a-9aa2-42ad-aa02-c9c4e8a5a09a') -- $P{BusinessUnitID})
      ,CASE WHEN BU.name = 'DEUFOL CUSTOMERS' and CUSTOMER.Customer is not null then CUSTOMER.[Customer] else BU.Name end as [BuName]
      ,CASE WHEN LEN([BU].[DMSSiteName]) = 0 then (Select DMSSiteName from BusinessUnit where id = 'a896347a-9aa2-42ad-aa02-c9c4e8a5a09a' --$P{BusinessUnitID} 
      ) ELSE [BU].[DMSSiteName] END as [DMSSiteName]
      ,CASE WHEN LEN([BU].[ISPM15SiteName]) = 0 then (Select ISPM15SiteName from BusinessUnit where id = 'a896347a-9aa2-42ad-aa02-c9c4e8a5a09a' --$P{BusinessUnitID} 
      ) ELSE [BU].[ISPM15SiteName] END as [ISPM15SiteName]
    ,DUOM.WeightUnitDec
    ,DUOM.VolumeUnitDec
    ,DUOM.LengthUnitDec
    ,DUOM.AreaUnitDec
    ,DUOM.BasicUnitDec
  FROM [HandlingUnit] [ENT]

INNER JOIN [BusinessUnitPermission] [BUP] on [ENT].[id] = [BUP].[HandlingUnitId] and [BUP].[BusinessUnitId] = '3b15a324-a7ae-4777-97a8-ba5e9ecf8d4c'--$P{ClientBusinessUnitId} 
INNER join [BusinessUnit] as [BU] on [BUP].[BusinessUnitId] = [BU].[Id] and [BU].[Type]='2'
INNER JOIN [WarehouseContent] [WC] on [ENT].[id]  = [WC].[HandlingUnitId] and wc.LoosePartId is null
LEFT JOIN [HandlingUnitType] [HUT] on [ENT].[TypeId] =[HUT].[Id]
left join (
SELECT
[CF].[Name] as [CF_Name], 
ISNULL([T].[text],'')+': '+[CV].[Content] as [CV_Content],
[CV].[EntityId] as [EntityID]
FROM [CustomField] [CF]
INNER JOIN [CustomValue] [CV] ON [CF].[Id] = [CV].[CustomFieldId]
LEFT JOIN [Translation] [T] on [CF].[Id] = [T].[EntityId] and [T].[Language] = 'de'-- $P{Language} 
WHERE [name] in (select [name] from [CustomField] group by [name]) and [CV].[Entity] = 11
) [SRC]
PIVOT (max([SRC].[CV_Content]) for [SRC].[CF_Name]  in ([DUTIABLE_GOODS]) -- add customfield names here
        ) as [CF] on [ENT].[id] = [CF].[EntityID]

LEFT JOIN (
SELECT [D].[name], [DV].[Description] as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
LEFT JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Language] = 'de'--  $P{Language}
   and [T].[Column] = 'Name'

WHERE [D].[name] in ('CUSTOMER')
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Customer])
        )  as [CUSTOMER] on [ENT].[Id] = [CUSTOMER].[EntityId]


LEFT JOIN (
SELECT [D].[name], [T].[text]+': '+[DV].[Description]+' ['+DV.Content+']' as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
LEFT JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Language] = 'de'--$P{Language}  
and [T].[Column] = 'name'

WHERE [D].[name] in (select [name] from [Dimension] group by [name])
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Customer],[Project],[Order],[Commission])
        )  as [D] on [ENT].[Id] = [D].[EntityId]
,[User] U
inner join DisplayUOM DUOM on U.DisplayUOMId = DUOM.Id
inner join Translation A on DUOM.id = A.EntityId and A.Language = @Language and A.[Column] = 'AreaUnitName'
inner join Translation B on DUOM.id = B.EntityId and B.Language = @Language and B.[Column] = 'BasicUnitName'
inner join Translation L on DUOM.id = L.EntityId and L.Language = @Language and L.[Column] = 'LengthUnitName'
inner join Translation V on DUOM.id = V.EntityId and V.Language = @Language and V.[Column] = 'VolumeUnitName'
inner join Translation W on DUOM.id = W.EntityId and W.Language = @Language and W.[Column] = 'WeightUnitName'

--WHERE $X{IN, ENT.Id, HandlingUnitIDs}

WHERE ENT.Id in ('e72db65c-52a2-4948-a014-528eae884c8b',
'bb39d080-9730-49ea-8d8d-e9b1f226e022',
'8bdc7e7e-3cf4-4b06-86a0-46077cc8d67a')
And U.LOGIN = @Login
order by [ENT].[Code]


select U.FirstName+' '+U.LastName from [User] U  