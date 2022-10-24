select
DB_NAME() AS 'Current Database',
BU as ClientBusinessName,
HUT.[Description] as Kistenart,
POH.Protection as Konservierung,
POH.Code as PackingOrder,
orders.[Description] as Dimension,
ent.code,
case orders.entity
when 11 then 'HandlingUnit'
when 15 then 'Loosepart'
else cast (orders.entity as varchar) end as Entity,
coded.code+' - '+Orders.[Description] as 'Order',
RespPersD.[Responsible Person],
LoadDateD.[Loading Date],
isnull(TermFixD.[Termin fix],'FALSE') 'Termin fix',
isnull(T.text,T.text) EntityStatus,
cast(WFE.dat as date) as StatusChanged,
ent.Surface,
ent.BaseArea
 from
(
select
BU.name as BU,
D.id did,
DV.Id dvid,
DV.[Description],
edvr.EntityId,
edvr.Entity
from Dimension D
inner join DimensionValue DV on D.id = DV.DimensionId
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.ID
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Status S on DV.StatusId = S.id 
where bup.BusinessUnitId in(
select BusinessUnitId from BusinessUnitRelation where RelatedBusinessUnitId = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen'))
and d.name = 'Order' and s.Name = 'Active') Orders

inner join 
(SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled]  FROM HandlingUnit
UNION
SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,ActualHandlingUnitId,null,null,null,null,null,null,null,null,null,null,null  FROM LoosePart)
 ENT on orders.EntityId = ENT.id
inner join (select WFE.entityid, wfe.StatusId, Max (WFE.Created) as dat from workflowentry WFE group by WFE.entityid, wfe.StatusId) WFE on ent.id = WFE.entityid and ent.Statusid = WFE.StatusID
left join HandlingUnitType HUT on ENT.TypeId = HUT.Id
left join PackingOrderHeader POH on ENT.PackingOrderHeaderId = POH.Id
left join status S on ENT.StatusId = S.Id
left join Translation T on S.id = T.EntityId and T.[Language] = 'de'
left join (
Select
EDVR.entityid,
DV.Content as 'Code'
from DimensionValue DV
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Dimension D on DV.DimensionId  = D.Id and d.name = 'Order'
) CodeD on orders.EntityId = CodeD.EntityId

left join (
Select
EDVR.entityid,
DFV.Content as 'Responsible Person'
from DimensionFieldValue DFV
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id and DF.Name = 'Responsible Person'
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join Dimension D on DF.DimensionId  = D.Id) RespPersD on orders.EntityId = RespPersD.EntityId

left join (
Select
EDVR.entityid,
DFV.Content as 'Loading Date'
from DimensionFieldValue DFV
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id and DF.Name = 'Loading Date'
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join Dimension D on DF.DimensionId  = D.Id) LoadDateD on orders.EntityId = LoadDateD.EntityId

left join (
Select
EDVR.entityid,
DFV.Content as 'Termin fix'
from DimensionFieldValue DFV
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id and DF.Name = 'Termin fix'
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join Dimension D on DF.DimensionId  = D.Id) TermFixD on orders.EntityId = TermFixD.EntityId
 --where coded.Code = '12/0174/18'