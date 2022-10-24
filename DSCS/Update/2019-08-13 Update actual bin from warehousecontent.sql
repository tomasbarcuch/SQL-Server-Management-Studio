
begin transaction
update LoosePart 
set
ActualLocationId = WHC.LocationId
,ActualZoneId = WHC.ZoneId 
,ActualBinId = WHC.BinId

from warehousecontent WHC 
inner join LoosePart LP on WHC.LoosePartId = LP.Id

where ISNULL(LP.ActualBinId,'00000000-0000-0000-0000-000000000000') <> ISNULL(WHC.BinId,'00000000-0000-0000-0000-000000000000')
COMMIT


begin transaction
update HandlingUnit
set
ActualLocationId = WHC.LocationId
,ActualZoneId = WHC.ZoneId 
,ActualBinId = WHC.BinId

from warehousecontent WHC 
inner join HandlingUnit HU on WHC.HandlingUnitId = HU.Id

where ISNULL(HU.ActualLocationId,'00000000-0000-0000-0000-000000000000') <> ISNULL(WHC.LocationId,'00000000-0000-0000-0000-000000000000')

commit