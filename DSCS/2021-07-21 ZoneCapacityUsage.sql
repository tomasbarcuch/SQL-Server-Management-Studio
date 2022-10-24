Select
L.Name Location,
Z.name Zone, 
Sum(BaseArea) UsedArea, 
max(Z.Capacity) Capacity, 
case when max(Z.Capacity) > 0 then Sum(BaseArea)/max(Z.Capacity)*100.00 else 0.00 end as UsagePercent
from (
select Sum(BaseArea) BaseArea,ActualZoneId  from LoosePart LP 
where ActualHandlingUnitId is null

group by ActualZoneId

UNION

select Sum(BaseArea) BaseArea,ActualZoneId from HandlingUnit HU 
where ParentHandlingUnitId is null 

group by ActualZoneId
) DATA

inner join [Zone] Z on DATA.ActualZoneId = Z.Id
and ActualZoneId in ('dc874666-a5ad-48b6-8e9b-426e34bd53c5','e6062835-4156-4ba3-b782-7cdea32e30cc')
inner join [Location] L on Z.LocationId = L.id
group by L.Name,Z.name

select id,name as Zone from zone where [Disabled] = 0