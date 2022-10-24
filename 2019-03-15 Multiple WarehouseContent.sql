select
cast(created  as date), count(*)
from WarehouseContent inner join (
select LP.code, BU.name, WC.LoosePartID as entityid from WarehouseContent WC
inner join BusinessUnitPermission BUP on WC.LoosePartId = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.type = 2
inner join LoosePart LP on wc.LoosePartId = LP.Id
where WC.LoosePartId is not null
group by LP.code, WC.LoosePartId, bu.name
having count (*) > 1
union
select HU.code, BU.name,WC.HandlingUnitId from WarehouseContent WC
inner join BusinessUnitPermission BUP on WC.HandlingUnitId = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.type = 2
inner join HandlingUnit HU on WC.HandlingUnitId = HU.id
where WC.HandlingUnitId is not null and WC.LoosePartId is null
group by HU.code,BU.name,WC.HandlingUnitId
having count (*) > 1) cont on isnull(WarehouseContent.LoosePartId,HandlingUnitId) = cont.entityid
group by cast(created  as date)