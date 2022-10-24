
/*
select  hu.code, bu.name from (

select BUP.HandlingUnitId, BUP.BusinessUnitId 
from BusinessUnitPermission BUP
where 
--BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG') and 
BUP.HandlingUnitId is not NULL
group by BUP.HandlingUnitId, BUP.BusinessUnitId having count(BUP.id)>1) data
inner join BusinessUnit BU on data.BusinessUnitId = BU.id
inner join HandlingUnit HU on data.HandlingUnitId = HU.Id

select  lp.code, bu.name from (

select BUP.LoosePartId, BUP.BusinessUnitId 
from BusinessUnitPermission BUP
where 
--BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG') and 
BUP.LoosePartId is not NULL
group by BUP.LoosePartId, BUP.BusinessUnitId having count(BUP.id)>1) data
inner join BusinessUnit BU on data.BusinessUnitId = BU.id
inner join LoosePart LP on data.LoosePartId = LP.Id

begin TRANSACTION
delete from BusinessUnitPermission where id in (
select max(BUP.Id)
from BusinessUnitPermission BUP
where 
BUP.HandlingUnitId is not NULL
group by BUP.HandlingUnitId, BUP.BusinessUnitId having count(BUP.id)>1)
ROLLBACK
*/

begin TRANSACTION
delete from BusinessUnitPermission where id in (
select max(bup.id)
from BusinessUnitPermission BUP
where 
BUP.LoosePartId is not NULL
group by BUP.LoosePartId, BUP.BusinessUnitId having count(BUP.id)>1)

rollback

delete from BusinessUnitPermission where id in (
select max(bup.id)
from BusinessUnitPermission BUP
where 
BUP.ShipmentLineId is not NULL
group by BUP.ShipmentLineId, BUP.BusinessUnitId having count(BUP.id)>1)


