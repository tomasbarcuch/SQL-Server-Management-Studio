
select code,wfe.EntityId, wfe.Created, whe.LocationId, whe.datestart, whe.dateend from (
select
HU.code hucode,
L.Code,
   WHE.HandlingUnitId,
   WHE.LocationId,
  min(WHE. Created) as datestart,
  max(whe.Created) as dateend
from WarehouseEntry WHE
inner join BusinessUnitPermission BUP on WHE.HandlingUnitId = BUP.HandlingUnitId and BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG')
inner join HandlingUnit HU on whe.HandlingUnitId = HU.Id
left join [Location] L on WHE.LocationId = L.id
where WHE.LocationId is not null and WHE.HandlingUnitId is not null
group by 
HU.code,
L.Code,
   WHE.HandlingUnitId,
   WHE.LocationId
   ) WHE   , WorkflowEntry WFE    where WHE.HandlingUnitId = WFE.EntityId and Wfe.Created BETWEEN whe.datestart and whe.dateend








