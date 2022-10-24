select count(BUP.Id),BusinessUnitId from BusinessUnitPermission BUP 
--inner join ShipmentHeader SH on BUP.ShipmentHeaderid = SH.id
where ShipmentLineId is not null
group by BusinessUnitId, ShipmentLineId
having count(BUP.Id) > 1

select count(BUP.Id),BusinessUnitId,Max(bup.Id) from BusinessUnitPermission BUP 
--inner join ShipmentHeader SH on BUP.ShipmentHeaderid = SH.id
where HandlingUnitId is not null
group by BusinessUnitId, HandlingUnitId
having count(BUP.Id) > 1

select BU.name, count(BUP.Id),BusinessUnitId,max(bup.Id) from BusinessUnitPermission BUP 
--inner join ShipmentHeader SH on BUP.ShipmentHeaderid = SH.id
inner join BusinessUnit BU on bup.BusinessUnitId = BU.id
where LoosePartID is not null
group by BusinessUnitId, LoosePartId, bu.name
having count(BUP.Id) > 1

begin transaction
delete from BusinessUnitPermission where id in (
select max(bup.Id) from BusinessUnitPermission BUP 
where LoosePartID is not null
group by BusinessUnitId, LoosePartId
having count(BUP.Id) > 1)
commit

begin transaction
delete from BusinessUnitPermission where id in (
select Max(bup.Id) from BusinessUnitPermission BUP 
where HandlingUnitId is not null
group by BusinessUnitId, HandlingUnitId
having count(BUP.Id) > 1)
commit