begin TRANSACTION
delete from BusinessUnitPermission where id in (
select bup.id from handlingunit HU
inner join BusinessUnitPermission CUP on HU.id = CUP.HandlingUnitId and CUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Deufol Neutraubling')
and HU.ActualLocationId is null --<> (select id from [Location] where code = 'NEUTRAUBLING')
)
commit


begin TRANSACTION
delete from BusinessUnitPermission where id in (
select bup.id from LoosePart LP
inner join BusinessUnitPermission CUP on LP.id = CUP.LoosePartId and CUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Deufol Neutraubling')
and LP.ActualLocationId is null --<> (select id from [Location] where code = 'NEUTRAUBLING')
)
commit

begin TRANSACTION
delete from BusinessUnitPermission where id in (
select bup.id from ShipmentLine SL
inner join BusinessUnitPermission CUP on SL.id = CUP.ShipmentLineId and CUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')
inner join BusinessUnitPermission BUP on SL.id = BUP.ShipmentLineId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Deufol Neutraubling')
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id and (SH.ToLocationId <> (select id from [Location] where code = 'NEUTRAUBLING') or SH.FromLocationId <> (select id from [Location] where code = 'NEUTRAUBLING'))
)
commit

begin TRANSACTION
delete from BusinessUnitPermission where id in (
select bup.id from ShipmentHeader SH
inner join BusinessUnitPermission CUP on SH.id = CUP.ShipmentHeaderId and CUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')
inner join BusinessUnitPermission BUP on SH.id = BUP.ShipmentHeaderId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Deufol Neutraubling')
where SH.ToLocationId <> (select id from [Location] where code = 'NEUTRAUBLING') or SH.FromLocationId <> (select id from [Location] where code = 'NEUTRAUBLING')
)
commit

