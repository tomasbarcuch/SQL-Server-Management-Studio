select 
PR.ID from PackingRule PR
inner join HandlingUnit PHU on PR.ParentHandlingUnitId = PHU.id
where
( 
phu.ActualLocationId is NULL and PR.ParentHandlingUnitId in (
select we.HandlingUnitId from WarehouseEntry WE
inner join [Location] L on WE.LocationId = L.Id
where WE.HandlingUnitId is not null and WE.LocationId is not null
group by we.HandlingUnitId
HAVING count(distinct we.LocationId) > 0)

)

or

(PR.ParentHandlingUnitId in (
select we.HandlingUnitId from WarehouseEntry WE
inner join [Location] L on WE.LocationId = L.Id
where WE.HandlingUnitId is not null and WE.LocationId is not null
group by we.HandlingUnitId
HAVING count(distinct we.LocationId) > 1))

and PHU.ActualLocationId is not null


