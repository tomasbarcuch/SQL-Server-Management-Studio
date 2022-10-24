/*select TopHandlingUnitId,ParentHandlingUnitId,Id,* from handlingunit

where code like 'HU037-0000%'
and TopHandlingUnitId is not null and ParentHandlingUnitId is not null
*/

declare @id1 as UNIQUEIDENTIFIER
declare @id2 as UNIQUEIDENTIFIER
declare @id3 as UNIQUEIDENTIFIER

set @id1 = '86612659-9fca-413b-9a5c-38c99672f191'
--set @id2 = '26eeb0ed-63da-4dc9-95d2-246579ff3922'
--set @id3 = 'db3894eb-d835-4e90-b341-ece5da4a9836'

select 

(select count (*) from HandlingUnit 
where 
ent.id = id and
ent.ParentHandlingUnitId in (Select TopHandlingUnitId from HandlingUnit group by TopHandlingUnitId)
and ent.TopHandlingUnitId in (Select ParentHandlingUnitId from HandlingUnit group by ParentHandlingUnitId)
and ent.ParentHandlingUnitId = ent.TopHandlingUnitId
),
ENT.Entity,
HUTP.[Description],
isnull((case HUTT.Container when 1 then 'Container'when 0 then 'Crate'end),'Part') as Typ,
isnull((case HUTP.Container when 1 then 'Container'when 0 then 'Crate'end),'Part') as Typ,
isnull((case HU.Container when 1 then 'Container'when 0 then 'Crate'end),'Part') as Typ,
THU.Code TopHU,
PHU.code ParentHU,
ent.code as Inhalt,

nullif(THU.Code,PHU.code),
nullif(PHU.Code,THU.code),
isnull(nullif(thu.code,PHU.code),ent.code) INHALT

 from 

(SELECT 'HU' as Entity,[Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled]  FROM HandlingUnit
UNION
SELECT 'LP',[Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,ActualHandlingUnitId,null,null,null,null,null,null,null,null,null,null,null  FROM LoosePart)
 ENT

left join HandlingUnit THU on ent.TopHandlingUnitId = THU.Id
left join HandlingUnit PHU on ent.parentHandlingUnitId = PHU.Id
left join HandlingUnitType HUTT on THU.TypeId = HUTT.id
left join HandlingUnitType HUTP on PHU.TypeId = HUTP.id
left join HandlingUnitType HU on ENT.TypeId = HU.id


where 
((ent.TopHandlingUnitId in (@id1,@id2,@id3) OR ent.ParentHandlingUnitId in (@id1,@id2,@id3) )
OR
(ent.TopHandlingUnitId in (select TopHandlingUnitId from HandlingUnit where id in( @id1,@id2,@id3) OR ent.ParentHandlingUnitId in (select ParentHandlingUnitId from HandlingUnit where id in( @id1,@id2,@id3)
OR
ent.Id in (@id1,@id2,@id3)
))))


order by thu.code,phu.code,ent.Code




