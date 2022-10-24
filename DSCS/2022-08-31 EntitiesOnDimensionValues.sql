declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
declare @PackerBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Nürnberg')
declare @DimensionValueId as UNIQUEIDENTIFIER = '82f69a8c-4109-4e25-9715-eaa3da622407'
declare @Language as CHAR (2) = 'de'

select 
DV.Id DimensionValueId
,ENT.Id EntityId
,DV.Content
,DV.[Description]
,ISNULL(T.Text,D.[Description]) Dimension
,ENT.Code as Code
,ENT.[Description] Description
,L.Name ActualLocation
,ISNULL(TS.Text, S.Name) as Status
,EDVR.Entity
,Dimensions.Customer
,Dimensions.Project
,Dimensions.[Order]
,Dimensions.Commission
from DimensionValue DV
inner join Dimension D on DV.DimensionId = D.Id AND DV.id = @DimensionValueId
left join Translation T on D.Id = T.EntityId and T.[Language] = @Language and T.[Column] = 'Name'
INNER join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
INNER join LoosePart ENT on EDVR.EntityId = ENT.Id
INNER JOIN Status S on ENT.StatusId = S.id
LEFT JOIN Translation TS on S.Id = TS.EntityId and TS.[Language] = @Language and TS.[Column] = 'Name'

LEFT join LOCATION L on ENT.ActualLocationId = L.Id

LEFT JOIN (
select 
D.name, 
DV.Content+' '+isnull(DV.[Description],'') as content,
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Customer','Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
        ) as Dimensions on EDVR.EntityId = Dimensions.EntityId



WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosepartId] = ENT.Id) AND ([BUP].[BusinessUnitId] = @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosepartId] = ENT.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))

UNION

select 
DV.Id DimensionValueId
,ENT.Id EntityId
,DV.Content
,DV.[Description]
,ISNULL(T.Text,D.[Description]) Dimension
,ENT.Code as Code
,ENT.[Description] Description
,L.Name ActualLocation
,ISNULL(TS.Text, S.Name) as Status
,EDVR.Entity
,Dimensions.Customer
,Dimensions.Project
,Dimensions.[Order]
,Dimensions.Commission
from DimensionValue DV
inner join Dimension D on DV.DimensionId = D.Id AND DV.id = @DimensionValueId
left join Translation T on D.Id = T.EntityId and T.[Language] = @Language and T.[Column] = 'Name'
INNER join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
INNER join HandlingUnit ENT on EDVR.EntityId = ENT.Id
INNER JOIN Status S on ENT.StatusId = S.id
LEFT JOIN Translation TS on S.Id = TS.EntityId and TS.[Language] = @Language and TS.[Column] = 'Name'
LEFT join LOCATION L on ENT.ActualLocationId = L.Id

LEFT JOIN (
select 
D.name, 
DV.Content+' '+isnull(DV.[Description],'') as content,
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Customer','Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
        ) as Dimensions on EDVR.EntityId = Dimensions.EntityId



WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = ENT.Id) AND ([BUP].[BusinessUnitId] = @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = ENT.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))


UNION

select 
DV.Id DimensionValueId
,ENT.Id EntityId
,DV.Content
,DV.[Description]
,ISNULL(T.Text,D.[Description]) Dimension
,ENT.Code as Code
,ENT.[Description] Description
,L.Name ActualLocation
,ISNULL(TS.Text, S.Name) as Status
,EDVR.Entity
,Dimensions.Customer
,Dimensions.Project
,Dimensions.[Order]
,Dimensions.Commission
from DimensionValue DV
inner join Dimension D on DV.DimensionId = D.Id AND DV.id = @DimensionValueId
left join Translation T on D.Id = T.EntityId and T.[Language] = @Language and T.[Column] = 'Name'
INNER join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
INNER join ShipmentHeader ENT on EDVR.EntityId = ENT.Id
INNER JOIN Status S on ENT.StatusId = S.id
LEFT JOIN Translation TS on S.Id = TS.EntityId and TS.[Language] = @Language and TS.[Column] = 'Name'
LEFT join LOCATION L on ENT.FromLocationId = L.Id

LEFT JOIN (
select 
D.name, 
DV.Content+' '+isnull(DV.[Description],'') as content,
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Customer','Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
        ) as Dimensions on EDVR.EntityId = Dimensions.EntityId



WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentHeaderId] = ENT.Id) AND ([BUP].[BusinessUnitId] = @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentHeaderId] = ENT.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))

UNION

select 
DV.Id DimensionValueId
,ENT.Id EntityId
,DV.Content
,DV.[Description]
,ISNULL(T.Text,D.[Description]) Dimension
,ENT.Code as Code
,ENT.[Description] Description
,L.Name ActualLocation
,ISNULL(TS.Text, S.Name) as Status
,EDVR.Entity
,Dimensions.Customer
,Dimensions.Project
,Dimensions.[Order]
,Dimensions.Commission
from DimensionValue DV
inner join Dimension D on DV.DimensionId = D.Id AND DV.id = @DimensionValueId
left join Translation T on D.Id = T.EntityId and T.[Language] = @Language and T.[Column] = 'Name'
INNER join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
INNER join PackingOrderHeader ENT on EDVR.EntityId = ENT.Id
INNER JOIN Status S on ENT.StatusId = S.id
LEFT JOIN Translation TS on S.Id = TS.EntityId and TS.[Language] = @Language and TS.[Column] = 'Name'
LEFT join LOCATION L on ENT.LocationId = L.Id

LEFT JOIN (
select 
D.name, 
DV.Content+' '+isnull(DV.[Description],'') as content,
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Customer','Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
        ) as Dimensions on EDVR.EntityId = Dimensions.EntityId



WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[PackingOrderHeaderId] = ENT.Id) AND ([BUP].[BusinessUnitId] = @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[PackingOrderHeaderId] = ENT.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))