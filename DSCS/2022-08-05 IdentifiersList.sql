declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
declare @PackerBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Neutraubling')




select Dimensions.Customer,LP.Code, LP.[Description], LP.Height, LP.Width,LP.Length, LPI.Identifier from LoosePartIdentifier LPI
inner join LoosePart LP on LPI.LoosePartId = LP.Id
inner join BusinessUnitPermission BUP on LPI.LoosePartId = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id
inner join (
select 
D.name, 
--Case D.name when 'Customer' then DV.Content+' '+isnull(DV.[Description],'.') else DV.Content end as Content, 
--DV.Content+' '+isnull(DV.[Description],'') as Content,
DV.[Description] as Content, 
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Customer','Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
        ) as Dimensions on LP.Id = Dimensions.EntityId



WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosepartId] = LP.Id) AND ([BUP].[BusinessUnitId] = @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosepartId] = LP.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))