SELECT 
IH.Code
,IH.Id InvetoryID
,case IH.[Status] when 0 then 'Open' when 1 then 'Closed' end as InventoryStatus
,IH.Created
,IL.CurrentQuantity
,IL.ExpectedQuantity
,UOM.Code as UOMCode
,L.Code as Location
,Z.Name as ZONE
,B.Code as BIN
,* 
FROM InventoryLine IL
INNER JOIN InventoryHeader IH on IL.InventoryHeaderId = IH.Id
INNER JOIN BusinessUnitPermission BUP on IL.id = BUP.InventoryLineId and BusinessUnitId = (select id from BusinessUnit where name = 'Sonstige Kunden - Sankt Pölten')--(select id from BusinessUnit where name = 'Krauss Maffei SK')--
INNER JOIN BusinessUnit BU on BUP.BusinessUnitId = BU.Id
INNER JOIN [Location] L on IH.LocationId = L.Id
LEFT JOIN [Zone] Z on IL.ZoneId = Z.Id
LEFT JOIN Bin B on IL.BinId = B.Id
INNER JOIN UnitOfMeasure UOM on IL.UnitOfMeasureId = UOM.Id


LEFT JOIN LoosePart LP on IL.LoosePartId = LP.Id
LEFT JOIN HandlingUnit HU on IL.HandlingUnitId = HU.Id

--where IH.Id = 'b8988ca1-4e31-4662-a89f-516304f97615'