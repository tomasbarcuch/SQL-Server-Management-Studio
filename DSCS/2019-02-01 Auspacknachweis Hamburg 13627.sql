select 
POH.Code,
ent.code,
isnull(lppr.code,hupr.code) as Verpackungvorschrift,
SealNo.content 'Seal No.',
ContNo.content as 'Container No.'

from PackingOrderLine POL
inner join PackingOrderHeader POH on POL.PackingOrderHeaderId = POH.Id
left join (SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled]  FROM HandlingUnit
UNION
SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,ActualHandlingUnitId,null,null,null,null,null,null,null,null,null,null,null  FROM LoosePart
)
 ENT on isnull(pol.HandlingUnitId,pol.LoosePartId) = ENT.id
inner join CustomValue SealNo on SealNo.EntityId = POH.Id and SealNo.CustomFieldId in (select id from CustomField where name in ('Seal No.'))
inner join CustomValue ContNo on ContNo.EntityId = POH.Id and ContNo.CustomFieldId in (select id from CustomField where name in ('Container No.'))
inner join BusinessUnitPermission BUP on pol.Id = bup.PackingOrderLineId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Dürr Systems')
left join PackingRule PR on ent.id = PR.ParentHandlingUnitId
left join LoosePart LPpr on PR.LoosePartId = LPpr.Id
left join handlingunit HUpr on PR.HandlingUnitId = HUpr.Id

--here POL.PackingOrderHeaderId = '4da54e24-65de-4b75-b7ba-05385a045574'


/*
select 
* 
from Dimension D
inner join DimensionField DF on D.id = DF.DimensionId and DF.Name = 'Port of Destination'
where d.name = 'Order'


select DimensionFieldId,DimensionValueId,Content from DimensionFieldValue DFV where DFV.DimensionFieldId in (select id from dimensionfield where name = 'Port of Destination')
*/