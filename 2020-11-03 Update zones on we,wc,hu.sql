
begin TRANSACTION
update HandlingUnit set ActualZoneId = B.ZoneId
/*B.id binid, 
B.zoneid, 
B.Locationid,
HU.actualbinid,
HU.ActualZoneId,
HU.ActualLocationId*/
 from HandlingUnit HU
inner join bin B on HU.ActualBinId = B.Id
where 
(HU.ActualZoneId <> B.ZoneId) or (HU.ActualZoneId is null and HU.ActualBinId is not null)
ROLLBACK

begin TRANSACTION
select * 
--update WarehouseEntry set ZoneId = B.ZoneId
/*B.id binid, 
B.zoneid, 
B.Locationid,
WE.binid,
WE.ZoneId,
WE.LocationId*/
 from WarehouseEntry WE
inner join bin B on WE.BinId = B.Id
where 
(WE.ZoneId <> B.ZoneId) or (WE.ZoneId is null and WE.BinId is not null)
ROLLBACK

begin TRANSACTION
update WarehouseContent set ZoneId = B.ZoneId
/*B.id binid, 
B.zoneid, 
B.Locationid,
WC.binid,
WC.ZoneId,
WC.LocationId*/
 from WarehouseContent WC
inner join bin B on WC.BinId = B.Id
where 
(WC.ZoneId <> B.ZoneId) or (WC.ZoneId is null and WC.BinId is not null)

ROLLBACK


begin TRANSACTION
update LoosePart set ActualZoneId = B.ZoneId
--select count(*)
/*B.id binid, 
B.zoneid, 
B.Locationid,
HU.actualbinid,
HU.ActualZoneId,
HU.ActualLocationId*/
 from LoosePart LP
inner join bin B on LP.ActualBinId = B.Id
where 
(LP.ActualZoneId <> B.ZoneId) or (LP.ActualZoneId is null and LP.ActualBinId is not null)

ROLLBACK


