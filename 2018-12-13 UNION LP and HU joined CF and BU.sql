select
Client.Name,
ent.code, 
WEFix.content,
colli.content,
FeldNr.content,
KennwortD.Kennwort,
KennwortD.Dimension

from
( SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled]  FROM HandlingUnit
UNION
SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,null,null,null,null,null,null,null,null,null,null,null,null  FROM LoosePart)
ENT

inner join (
select BusinessUnitID, isnull(BUP.LoosePartId,BUP.HandlingUnitId) EntityID from BusinessUnitPermission BUP
where isnull(BUP.LoosePartId,BUP.HandlingUnitId) is not null
and BusinessUnitId in(
select BusinessUnitId from BusinessUnitRelation where RelatedBusinessUnitId = (select id from BusinessUnit where name = 'Deufol Berlin'))) BU on ent.id = BU.EntityId
inner join BusinessUnit Client on BU.BusinessUnitId = Client.id



left join CustomValue WEFix on WEFix.EntityId = ENT.Id and WEFix.CustomFieldId in (select id from CustomField where name = 'Datum WE (fix)')
left join CustomValue Colli on Colli.EntityId = ENT.Id and Colli.CustomFieldId in (select id from CustomField where name in ('Colli'))
left join CustomValue FeldNr on FeldNr.EntityId = ENT.Id and FeldNr.CustomFieldId in (select id from CustomField where name in ('Feld Nr.'))

left join (Select
EDVR.entityid,
DFV.Content as 'Kennwort',
DV.content as 'Dimension',
D.Name
from DimensionFieldValue DFV
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id and DF.Name = 'Kennwort'
inner join DimensionValue DV on DFV.DimensionValueId = DV.id
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join Dimension D on DF.DimensionId  = D.Id
) KennwortD on ENT.id = KennwortD.EntityId


