--SELECT 
BEGIN TRANSACTION 
UPDATE LoosePart SET WarrantyDate =
--cast(cast(WarrantyDate as date)as varchar)+' 00:00:00.00'
CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset, WarrantyDate), DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 
 FROM LoosePart WHERE WarrantyDate IS NOT NULL

AND  DATEPART(HOUR,WarrantyDate) <> 0

ROLLBACK