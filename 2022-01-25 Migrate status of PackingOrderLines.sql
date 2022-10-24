BEGIN TRANSACTION
update POL set POL.[Status] = 1 FROM PackingOrderLine POL
inner join PackingOrderHeader POH on POL.PackingOrderHeaderId = POH.id and POH.HandlingUnitId is not null
WHERE EXISTS(SELECT * FROM [WarehouseEntry] AS WE WHERE ([WE].[LoosepartId] = POL.LoosePartId) AND ([WE].[HandlingUnitId] = POH.HandlingUnitId ))
and POL.[Status] = 0

UPDATE POL set POL.[Status] = 1 FROM PackingOrderLine POL
inner join PackingOrderHeader POH on POL.PackingOrderHeaderId = POH.id and POH.HandlingUnitId is not null
WHERE EXISTS(SELECT * FROM [WarehouseEntry] AS WE WHERE ([WE].[HandlingUnitId] = POL.HandlingUnitId) AND ([WE].[ParentHandlingUnitId] = POH.HandlingUnitId ))
and POL.[Status] = 0

UPDATE POH set POH.CountLines = DATA.CountLines from PackingOrderHeader  POH
INNER JOIN (
select POH.ID,count(POL.id) CountLines from PackingOrderLine POL
inner join PackingOrderHeader POH on POL.PackingOrderHeaderId = POH.Id group by POH.Id) DATA on POH.id = DATA.Id
where POH.CountLines = 0

UPDATE POH set POH.CountPackedLines = DATA.CountPackedLines from PackingOrderHeader  POH
INNER JOIN (
select POH.ID,count(POL.id) CountPackedLines from PackingOrderLine POL
inner join PackingOrderHeader POH on POL.PackingOrderHeaderId = POH.Id where POL.[Status] = 1 group by POH.Id) DATA on POH.id = DATA.Id

COMMIT



/*
0 = None
1 = Packed
2 = Unpacked
*/