select
LP.ShipmentHeaderId,
LP.ActualLocationId,
LP.ActualZoneId,
LP.ActualbinId,
we.LocationId,
we.ZoneId,
we.BinId,
LP.ActualHandlingUnitId,
bu.name, 
FD.*,
LP.code,
UM.Code as UOM, 
WE.QuantityBase qty_we,
WC.QuantityBase qty_wc,
we.QuantityBase/WC.QuantityBase result
 from (
SELECT 
WE.LoosepartId,
min(WE.updated) OVER (PARTITION BY WE.LoosepartId) AS firstdate
from WarehouseEntry WE
where QuantityBase > 0) FD 
inner join LoosePart LP on FD.LoosepartId = LP.id
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and bu.type = 2
inner join WarehouseEntry WE on FD.firstdate = WE.Updated and FD.LoosepartId = WE.LoosepartId
inner join WarehouseContent WC on FD.LoosepartId = WC.LoosePartId
inner join UnitOfMeasure UM on LP.BaseUnitOfMeasureId = UM.Id
--where bu.name in ('Krones AG') 
group by FD.firstdate, FD.LoosepartId,LP.code, we.QuantityBase,WC.QuantityBase,bu.name,UM.Code,LP.ActualHandlingUnitId,
LP.ActualLocationId,
LP.ActualZoneId,
LP.ActualbinId,
we.LocationId,
we.ZoneId,
we.BinId,
LP.ShipmentHeaderId

having 
we.QuantityBase <> WC.QuantityBase 
--and (we.QuantityBase/WC.QuantityBase <> 0.5 or we.QuantityBase/WC.QuantityBase <> 2)
and year(firstdate) > 2018

order by bu.name




