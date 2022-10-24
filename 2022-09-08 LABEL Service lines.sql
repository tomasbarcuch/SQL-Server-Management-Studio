
declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
declare @BusinessUnitID as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Frankenthal')
declare @ServiceLinesIDs as UNIQUEIDENTIFIER = '5b1585d5-c589-4d5a-b51b-8a1c4e245170'
declare @Language as VARCHAR(2) = 'de'

select
 [CUSTOMER].Customer as Client
 ,ClientBusinessUnitName = (select name from BusinessUnit where id = @ClientBusinessUnitId)
 ,CASE WHEN BU.name = 'DEUFOL CUSTOMERS' and CUSTOMER.Customer is not null then CUSTOMER.[Customer] else BU.Name end as [BuName]
 ,CASE WHEN LEN([BU].[DMSSiteName]) = 0 then (Select DMSSiteName from BusinessUnit where id = @BusinessUnitID ) ELSE [BU].[DMSSiteName] END as [DMSSiteName]
,SL.Id
,SL.Description
,ISNULL(T.Text,ST.Code) as Code
,SL.EntityId
,S.Name STATUS
,CF.PRODUCTION_DATE
,SL.Entity
,Ent.Code
,Dimensions.[Description]
,Dimensions.Project
,Dimensions.[Order]
,Dimensions.Commission
from ServiceLine SL 
inner join ServiceType ST on SL.ServiceTypeId = ST.Id
inner join BusinessUnitPermission BUP on ST.id = BUP.ServiceTypeId and BUP.BusinessUnitId = @ClientBusinessUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.ID
inner join [Status] S on SL.StatusId = S.Id-- and S.Name = 'PLANNED'
inner join (
    select Id,Code,ActualBinId from HandlingUnit
        WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HandlingUnit.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
        AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HandlingUnit.Id) AND ([BUP].[BusinessUnitId] = @BusinessUnitID)) --$P{PackerBusinessUnitId})) 
    union 
    select Id,Code,ActualBinId from LoosePart
        WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosePartId] = LoosePart.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
        AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosePartId] = LoosePart.Id) AND ([BUP].[BusinessUnitId] = @BusinessUnitID)) --$P{PackerBusinessUnitId}))  
    union 
    select Id,Code,NULL from ShipmentHeader 
        WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentHeaderId] = ShipmentHeader.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
        AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentHeaderId] = ShipmentHeader.Id) AND ([BUP].[BusinessUnitId] = @BusinessUnitID)) --$P{PackerBusinessUnitId})) 
    ) ENT on SL.EntityId = Ent.Id

LEFT JOIN Translation T on ST.id = T.EntityId and T.[Language] = 'de' AND T.[Column] = 'Description'
left join (
SELECT
CustomField.Name as CF_Name, 
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId) and CustomField.Entity = 48

where name in (select name from CustomField where ClientBusinessUnitId = @ClientBusinessUnitId group by name) and CV.Entity = 48
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([PRODUCTION_DATE])
        ) as CF on SL.id = CF.EntityID

left join (
select D.name, DV.[Description],'['+DV.Content+']' as Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId

where D.name in ('Project','Order','Commission')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions on SL.EntityId = Dimensions.EntityId

LEFT JOIN (
SELECT [D].[name], [DV].[Description] as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
LEFT JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Language] = @Language   and [T].[Column] = 'name'

WHERE [D].[name] in ('CUSTOMER')
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Customer])
        )  as [CUSTOMER] on [ENT].[Id] = [CUSTOMER].[EntityId]


WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ServiceLineId] = SL.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ServiceLineId] = SL.Id) AND ([BUP].[BusinessUnitId] = @BusinessUnitID)) --$P{PackerBusinessUnitId}))
AND SL.Id in (@ServiceLinesIDs)

