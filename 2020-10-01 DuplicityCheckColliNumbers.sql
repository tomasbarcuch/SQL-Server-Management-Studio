select
Data.Commission,
Data.ColliNumber,
min(DATA.created) FirstCreated,
max(DATA.created) LastCreated,
 count(Data.ColliNumber) CountColli from 
(
select HU.Created,HU.ColliNumber, HU.Code, DV.Content as Commission, DS.Name as DStatus, HUS.Name as HUStatus
from EntityDimensionValueRelation EDVR
inner join BusinessUnitPermission BUP on EDVR.EntityId = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')
inner join HandlingUnit HU on BUP.HandlingUnitId = HU.Id
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DV.DimensionId = D.Id and D.name = 'Commission'
inner join Status DS on DV.StatusId = DS.Id
inner join Status HUS on HU.StatusId = HUS.Id
where DS.name in ('ACTIVE','CREATED') and HUS.Name not in ('CANCELED')
) DATA
group by Commission,ColliNumber,DStatus
having count(Data.ColliNumber) > 1