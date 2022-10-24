-- looseparts =================================================================
BEGIN TRANSACTION
DELETE FROM WarehouseEntry WHERE Id IN (

SELECT we.Id FROM WarehouseEntry we INNER JOIN 
(select LoosePartId, MAX(Updated) AS Updated from WarehouseContent WHERE LoosePartId IN (
select LoosePartId from WarehouseContent wc
GROUP BY LoosePartId
HAVING COUNT(*) > 1 
) 
GROUP BY LoosePartId) as wc ON we.LoosepartId = wc.LoosePartId and we.Updated = wc.Updated
);
COMMIT
begin TRANSACTION

DELETE FROM WarehouseContent WHERE Id IN (
select wc.Id FROM WarehouseContent wc INNER JOIN
(
select LoosePartId, MAX(Updated) Updated from WarehouseContent WHERE LoosePartId IN (
select LoosePartId from WarehouseContent wc
GROUP BY LoosePartId
HAVING COUNT(*) > 1 
) 
GROUP BY LoosePartId 
) as wc1 ON wc.LoosePartId = wc1.LoosePartId AND wc.Updated = wc1.Updated
)


commit

-- handlingunits =================================================================


BEGIN TRANSACTION
DELETE FROM WarehouseEntry WHERE Id IN 
(
SELECT we.Id FROM WarehouseEntry we INNER JOIN 
(select HandlingUnitId, MAX(Updated) AS Updated from WarehouseContent WHERE HandlingUnitId IN (
select HandlingUnitId from WarehouseContent wc
where WC.HandlingUnitId is not null and WC.LoosePartId is null
group by WC.HandlingUnitId
having count (*) > 1
)
GROUP BY HandlingUnitId, loosepartid
having loosepartid is null) as wc ON we.HandlingUnitId = wc.HandlingUnitId and we.Updated = wc.Updated
)
commit
begin transaction
delete FROM WarehouseContent WHERE Id IN (
select wc.Id FROM WarehouseContent wc INNER JOIN
(
select HandlingUnitId, loosepartid, MAX(Updated) Updated from WarehouseContent WHERE HandlingUnitId 
IN (
select HandlingUnitId from WarehouseContent wc
where WC.HandlingUnitId is not null and WC.LoosePartId is null
group by WC.HandlingUnitId
having count (*) > 1
) 
GROUP BY HandlingUnitId, loosepartid
having loosepartid is null
) as wc1 ON wc.HandlingUnitId = wc1.HandlingUnitId AND wc.Updated = wc1.Updated
)
commit



--smazaní duplicitně vytvořené HU - patrně chyba frameworku při zakládání importované položky
	begin TRANSACTION 
declare @handlingunitid as UNIQUEIDENTIFIER
set @handlingunitid =  --'0d5c6954-2ca7-46e1-a74b-29c7dbab2165'
(select top (1) hu.id
from HandlingUnit HU
left join packingorderheader POH on Hu.id = POH.HandlingUnitId
where hu.code in (
select code from handlingunit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.[Type] = 2
group by code, bup.BusinessUnitId
having count(*)>1) and poh.HandlingUnitId is null
)

DELETE
FROM BusinessUnitPermission WHERE HandlingUnitId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM HandlingUnitIdentifier WHERE HandlingUnitId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM BusinessUnitPermission WHERE InventoryLineId IN ( SELECT Id FROM InventoryLine WHERE HandlingUnitId = @handlingunitid)
--SELECT COUNT(*) 
DELETE
FROM InventoryLine WHERE HandlingUnitId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM BusinessUnitPermission WHERE PackingOrderLineId IN ( SELECT Id FROM PackingOrderLine WHERE HandlingUnitId = @handlingunitid)
--SELECT COUNT(*) 
DELETE
FROM PackingOrderLine WHERE HandlingUnitId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM PackingRule WHERE HandlingUnitId = @handlingunitid OR ParentHandlingUnitId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM BusinessUnitPermission WHERE ShipmentLineId IN ( SELECT Id FROM ShipmentLine WHERE HandlingUnitId = @handlingunitid)
--SELECT COUNT(*) 
DELETE
FROM ShipmentLine WHERE HandlingUnitId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM WarehouseContent WHERE HandlingUnitId = @handlingunitid OR ParentHandlingUnitId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM WarehouseEntry WHERE HandlingUnitId = @handlingunitid OR ParentHandlingUnitId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM BCSLog WHERE Entity = 11 AND EntityId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM BusinessUnitPermission WHERE CommentId IN ( SELECT Id FROM Comment WHERE Entity = 11 AND EntityId = @handlingunitid)
--SELECT COUNT(*)
DELETE
FROM CustomValue WHERE Entity = 46 AND EntityId IN ( SELECT Id FROM Comment WHERE Entity = 11 AND EntityId = @handlingunitid)
--SELECT COUNT(*) 
DELETE
FROM Comment WHERE Entity = 11 AND EntityId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM CustomValue WHERE Entity = 11 AND EntityId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM EntityDevicePlacement WHERE Entity = 11 AND EntityId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM EntityDimensionValueRelation WHERE Entity = 11 AND EntityId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM EntityDisableStatus WHERE Entity = 11 AND EntityId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM LogEntity WHERE Entity = 11 AND EntityId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM BusinessUnitPermission WHERE ServiceLineId IN ( SELECT Id FROM ServiceLine WHERE Entity = 11 AND EntityId = @handlingunitid)
--SELECT COUNT(*)
DELETE
FROM CustomValue WHERE Entity = 48 AND EntityId IN ( SELECT Id FROM ServiceLine WHERE Entity = 11 AND EntityId = @handlingunitid)
--SELECT COUNT(*)
DELETE
FROM WorkflowEntry WHERE Entity = 48 AND EntityId IN ( SELECT Id FROM ServiceLine WHERE Entity = 11 AND EntityId = @handlingunitid)
--SELECT COUNT(*) 
DELETE
FROM ServiceLine WHERE Entity = 11 AND EntityId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM WorkflowEntry WHERE Entity = 11 AND EntityId = @handlingunitid
--SELECT COUNT(*) 
DELETE
FROM HandlingUnit WHERE Id = @handlingunitid

commit


select count(hu.id) 
from HandlingUnit HU
left join packingorderheader POH on Hu.id = POH.HandlingUnitId
where hu.code in (
select code from handlingunit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.[Type] = 2
group by code, bup.BusinessUnitId
having count(*)>1) and poh.HandlingUnitId is null

--vyhledání duplicitních loosepartů v rámci klienta
select updated, created, id, code from LoosePart where code in (select code
from LoosePart lp
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2
group by code, bu.Name
having 
count(code) > 1)
order by code, updated


--smazaní duplicitně vytvořené LP - patrně chyba frameworku při zakládání importované položky
begin TRANSACTION 
declare @loosepartid as UNIQUEIDENTIFIER
set @loosepartid = --'5eca7b53-0b87-4129-b121-20d10486f8d8'
(select top(1) id from LoosePart where code in (select code
from LoosePart lp
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2
group by code, bu.Name
having 
count(code) > 1)
order by code, updated )

delete from BusinessUnitPermission where LoosePartId = @loosepartid
delete from WarehouseEntry where LoosepartId = @loosepartid
delete from WarehouseContent where LoosePartId = @loosepartid
delete from LoosePartUnitOfMeasure where LoosePartId = @loosepartid
delete from LoosePartIdentifier where LoosePartId = @loosepartid
delete from LoosePart where id = @loosepartid
COMMIT