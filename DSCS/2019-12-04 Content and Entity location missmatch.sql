begin transaction
SELECT lp.code,bu.name, lp.updated,WC.Updated,
--update WC set
 WC.LocationId , LP.ActualLocationId 
 , WC.ZoneId , LP.ActualZoneId
 , WC.BinId , LP.ActualBinId

from LoosePart LP
inner join BusinessUnitPermission BUP on lp.id = BUP.LoosePartId
inner join BusinessUnit bu on BUp.BusinessUnitId = bu.Id
left  join WarehouseContent WC on LP.id = WC.LoosePartId
where 
 --LP.ActualLocationId <> isnull(WC.LocationId,'00000000-0000-0000-0000-000000000000') or
isnull(LP.ActualLocationId,'00000000-0000-0000-0000-000000000000')<> isnull(WC.LocationId,'00000000-0000-0000-0000-000000000000')
--isnull(LP.ActualLocationId,'00000000-0000-0000-0000-000000000000')<> WC.LocationId
--order by WC.created
and wc.Updated is not null
ROLLBACK