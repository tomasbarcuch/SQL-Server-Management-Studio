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


COMMIT

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
GROUP BY HandlingUnitId) as wc ON we.HandlingUnitId = wc.HandlingUnitId and we.Updated = wc.Updated
);

DELETE FROM WarehouseContent WHERE Id IN (
select wc.Id FROM WarehouseContent wc INNER JOIN
(
select HandlingUnitId, MAX(Updated) Updated from WarehouseContent WHERE HandlingUnitId IN (
select HandlingUnitId from WarehouseContent wc
where WC.HandlingUnitId is not null and WC.LoosePartId is null
group by WC.HandlingUnitId
having count (*) > 1
) 
GROUP BY HandlingUnitId 
) as wc1 ON wc.HandlingUnitId = wc1.HandlingUnitId AND wc.Updated = wc1.Updated
)

COMMIT
