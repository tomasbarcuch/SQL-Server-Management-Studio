select
thu.code TopHandlingUnit,
client.Id clientid,
Client.Name,
ent.code, 
isnull(qty.QTY,0) as Anzahl,
ent.[Description] as Beschreibung,
case ent.Entity
when 11 then 'Kiste'
when 15 then 'Teil'
 end as ART,
ent.Length,
ent.Width,
ent.Height,
ent.Weight,
bin.Code,
zone.Name,
Location.Code,
ORD.Projekt,
ord.Auftrag,
isnull(PackingType.content, 'Unverpackt') as Typ


from
( SELECT 15 as Entity,[Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled]  FROM HandlingUnit
UNION
SELECT 11,[Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,null,null,null,null,null,null,null,null,null,null,null,null  FROM LoosePart)
ENT

inner join (
select BusinessUnitID, isnull(BUP.LoosePartId,BUP.HandlingUnitId) EntityID from BusinessUnitPermission BUP
where isnull(BUP.LoosePartId,BUP.HandlingUnitId) is not null
and BusinessUnitId in(
select BusinessUnitId from BusinessUnitRelation where RelatedBusinessUnitId = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen'))) BU on ent.id = BU.EntityId
inner join BusinessUnit Client on BU.BusinessUnitId = Client.id

left join CustomValue PackingType on PackingType.EntityId = ENT.Id and PackingType.CustomFieldId in (select id from CustomField where name = 'PackingType')

left join (select edvr.EntityId,DV.Content as Projekt,DV.[Description] as Auftrag from DimensionValue DV
inner join Dimension D on dv.DimensionId = D.id and D.name = 'Order'
inner join EntityDimensionValueRelation EDVR on dv.Id = EDVR.DimensionValueId) ORD on ENT.id = ORD.EntityId

left join (select 
isnull(LoosePartId,HandlingUnitId) EntityID,
Locationid,
sum(QuantityBase) as QTY
from WarehouseContent
--where LocationId is not null
group by isnull(LoosePartId,HandlingUnitId), LocationId) QTY on ENT.id = QTY.EntityID and ENT.ActualLocationId = qty.LocationId

left join bin on ent.ActualBinId = bin.Id
left join Zone on ent.actualzoneId = Zone.Id
left join Location on ent.actualLocationId = Location.id

left join HandlingUnit THU on ent.TopHandlingUnitId = THU.Id

where Client.Name = 'Gebr. Heller Maschinenfabrik GmbH'

select ID,code from LoosePart union all select id,code from HandlingUnit


