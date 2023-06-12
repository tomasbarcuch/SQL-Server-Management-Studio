BEGIN TRANSACTION
--UPDATE B SET B.Empty = 1
SELECT COUNT(*)  --B.Id, WC.Id 
 FROM Bin B 
LEFT JOIN WarehouseContent WC ON B.Id = WC.BinId
WHERE B.Empty = 0 
AND WC.Id IS NULL

ROLLBACK


SELECT COUNT(*) FROM LoosePart LP WHERE LP.ActualBinId in (
SELECT B.Id
 FROM Bin B 
LEFT JOIN WarehouseContent WC ON B.Id = WC.BinId
WHERE B.Empty = 0 
AND WC.Id IS NULL
)

SELECT COUNT(*) FROM HandlingUnit HU WHERE HU.ActualBinId in (
SELECT B.Id
 FROM Bin B 
LEFT JOIN WarehouseContent WC ON B.Id = WC.BinId
WHERE B.Empty = 0 
AND WC.Id IS NULL
)
