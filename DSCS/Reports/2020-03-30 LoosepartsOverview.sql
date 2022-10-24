select
DB_NAME() AS 'Current Database',
client.Id ClientId,
thu.code TopHandlingUnit,
Client.Name as ClientName,
ent.code  'ID-Nummer', 
isnull(qty.QTY,0) as Anzahl,
ent.[Description] as Beschreibung,
case ent.Entity
when 11 then 'Kiste'
when 15 then 'Teil'
 end as Art,
ent.Length,
ent.Width,
ent.Height,
ent.Weight,
S.name as 'Status',
isnull(bin.Code,'') Bin,
isnull(zone.Name,'') Zone,
isnull(Location.Code,'') Lokation,
Dimensions.Project as Projekt,
Dimensions.[Order] as Auftrag,
Dimensions.[Commission] as Kommission,
ent.SerialNo,
ent.LotNo,
inbNr.Content as 'Inbound Nr.',
InbDate.Content as 'Inbound Date',
UUPNr.Content as 'UUP Nr.',
isnull(PackingType.content, 'Unverpackt') as 'Packing Type',
isnull(LPI.Identifier,HUI.Identifier) as BarcodeIdentifier,
UOM.Code as UnitOfMeasure,
WC.QuantityBase


from
( SELECT 11 as Entity,[Id],[Code],NULL BaseUnitOfMeasureId,[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled]  FROM HandlingUnit
UNION
SELECT 15,[Id],[Code],[BaseUnitOfMeasureId],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,null,null,null,null,null,null,null,null,null,null,null,null  FROM LoosePart)
ENT

left join LoosePartIdentifier LPI on ENT.id = LPI.LoosePartId
left join HandlingUnitIdentifier HUI on ENT.id = HUI.HandlingUnitId
left join UnitOfMeasure UOM on ENT.BaseUnitOfMeasureId = UOM.id
left join WarehouseContent WC on ENT.id = WC.LoosePartId

inner join (
select BusinessUnitID, isnull(BUP.LoosePartId,BUP.HandlingUnitId) EntityID from BusinessUnitPermission BUP
where isnull(BUP.LoosePartId,BUP.HandlingUnitId) is not null
and BusinessUnitId in(
select BusinessUnitId from BusinessUnitRelation where RelatedBusinessUnitId = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen'))) BU on ent.id = BU.EntityId
--select BusinessUnitId from BusinessUnitRelation where RelatedBusinessUnitId = $P{PackerBusinessUnitID})) BU on ent.id = BU.EntityId
inner join BusinessUnit Client on BU.BusinessUnitId =  Client.id

left join CustomValue PackingType on PackingType.EntityId = ENT.Id and PackingType.CustomFieldId in (select id from CustomField where name = 'PackingType')
left join CustomValue InbNr on InbNr.EntityId = ENT.Id and InbNr.CustomFieldId in (select id from CustomField where name in ('LpInbound No'))
left join CustomValue InbDate on InbDate.EntityId = ENT.Id and InbDate.CustomFieldId in (select id from CustomField where name in ('LpInbound Date'))
left join CustomValue UUPNr on UUPNr.EntityId = ENT.Id and UUPNr.CustomFieldId in (select id from CustomField where name in ('UUP') and Entity = 15)
inner join status S on ent.StatusId = S.Id



left join  (
select D.name, DV.[Description]+' '+'['+DV.Content+']' as Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
left join DimensionField DF on D.id = DF.DimensionId


where D.name in ('Project','Order','Commission')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions on ENT.id = Dimensions.EntityId


left join (select 
isnull(LoosePartId,HandlingUnitId) EntityID,
Locationid,
sum(QuantityBase) as QTY
from WarehouseContent

group by isnull(LoosePartId,HandlingUnitId), LocationId) QTY on ENT.id = QTY.EntityID and ENT.ActualLocationId = qty.LocationId

left join bin on ent.ActualBinId = bin.Id
left join Zone on ent.actualzoneId = Zone.Id
left join Location on ent.actualLocationId = Location.id

left join HandlingUnit THU on ent.TopHandlingUnitId = THU.Id


where Client.id = (select id from BusinessUnit where name = 'Siempelkamp Maschinen- und Anlagenbau GmbH') --$P{ClientBusinessUnitID} 

and ent.id in ('9760e7b0-5b90-4ccd-a96d-02304e30dcd4','eb34848f-b14c-4e8e-a81b-0303788e21f0')
--and $X{IN,ent.id,LPHUIds}