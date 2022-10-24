/*
select
HU.id,
WETOP.LocationId, 
WETOP.ZoneId, 
WETOP.BinId, 
TOPS.ActualLocationId,
TOPS.ActualZoneId,
TOPS.ActualBinId
from 
HandlingUnit HU
inner join (select ID, ActualLocationId, ActualZoneId, ActualBinId from HandlingUnit 
where id = '1e26ad4a-5fd6-42dc-95cc-c45699ccc688'
) TOPS on HU.TopHandlingUnitId = TOPS.Id
inner join WarehouseEntry WETOP on TOPS.id = WETOP.HandlingUnitId and WETOP.LocationId = TOPS.ActualLocationId and wetop.LoosepartId is null
where WETOP.BinId <> isnull(TOPS.ActualBinId,'00000000-0000-0000-0000-000000000000')

begin transaction 
select actualzoneid, ActualBinId  from HandlingUnit
where id in ('3bde5dec-0cfc-4639-a8c4-e3d477ce2355','13888894-f743-466c-a0e8-73f017a05ce8')
ROLLBACK
*/


/*

select
WETOP.LocationId,
wetop.ZoneId,
WETOP.BinId,
WE.LocationId,
WE.ZoneId,
WE.BinId,
TOPS.ActualLocationId,
TOPS.ActualZoneId,
TOPS.ActualBinId, 
HU.ID, 
HU.ActualLocationId, 
HU.ActualZoneId, 
HU.ActualBinId,
WC.LocationId,
WC.ZoneId,
WC.BinId 
from HandlingUnit HU
inner join (select ID, ActualLocationId, ActualZoneId, ActualBinId from HandlingUnit 
where id = '1e26ad4a-5fd6-42dc-95cc-c45699ccc688'
) TOPS on HU.TopHandlingUnitId = TOPS.Id
inner join WarehouseContent WC on HU.id = WC.HandlingUnitId
inner join WarehouseEntry WE on HU.id = WE.HandlingUnitId and WE.LocationId = HU.ActualLocationId and WE.LoosePartId is null
inner join WarehouseEntry WETOP on TOPS.id = WETOP.HandlingUnitId and WETOP.LocationId = TOPS.ActualLocationId and wetop.LoosepartId is null

--Where  WETOP.BinId <> WE.BinId and WETOP.LocationId = WE.LocationId

*/

/*

BEGIN TRANSACTION
update HandlingUnit set ActualZoneId = 'f7a136f7-8a6c-4c74-bdf5-6f9623e3d220'
where actualbinid = '6d5e2d8a-1790-44e0-8aea-58f4c51912ac'
and ActualZoneId is null
--and ActualZoneId = 'f7a136f7-8a6c-4c74-bdf5-6f9623e3d220'
ROLLBACK

BEGIN TRANSACTION
update WarehouseContent set ZoneId = 'f7a136f7-8a6c-4c74-bdf5-6f9623e3d220'
where binid = '6d5e2d8a-1790-44e0-8aea-58f4c51912ac'
and ZoneId is null
--AND ZoneId = 'f7a136f7-8a6c-4c74-bdf5-6f9623e3d220'
ROLLBACK

BEGIN TRANSACTION
update WarehouseEntry set ZoneId = 'f7a136f7-8a6c-4c74-bdf5-6f9623e3d220'
where binid = '6d5e2d8a-1790-44e0-8aea-58f4c51912ac'
and ZoneId is null
--and ZoneId = 'f7a136f7-8a6c-4c74-bdf5-6f9623e3d220'
rollback

BEGIN TRANSACTION
update loosepart set ActualZoneId = 'f7a136f7-8a6c-4c74-bdf5-6f9623e3d220'
where actualbinid = '6d5e2d8a-1790-44e0-8aea-58f4c51912ac'
and ActualZoneId is null
--and ActualZoneId = 'f7a136f7-8a6c-4c74-bdf5-6f9623e3d220'
rollback
*/

--select * from [Location] where id = '375692d7-6eab-4059-ba07-e1572e97062a'

select
B.LocationId, 
B.ZoneId,
B.Id,
HU.ActualLocationId, 
HU.ActualZoneId,
HU.ActualBinId
 from handlingunit HU
 inner join BIN B on HU.ActualBinId = B.Id
 where 
 (isnull(HU.ActualZoneId ,'00000000-0000-0000-0000-000000000000') <> isnull(B.ZoneId,'00000000-0000-0000-0000-000000000000'))
 --or  HU.ActualLocationId <> B.LocationId)


 select
LP.ActualLocationId, 
LP.ActualZoneId,
LP.ActualBinId
 from Loosepart LP
 inner join BIN B on LP.ActualBinId = B.Id
 where 
 (isnull(lp.ActualZoneId ,'00000000-0000-0000-0000-000000000000') <> isnull(B.ZoneId,'00000000-0000-0000-0000-000000000000'))


  select 
  b.LocationId,
  b.ZoneId,

WC.LocationId, 
WC.ZoneId,
WC.BinId
 from WarehouseContent WC
 inner join BIN B on WC.BinId = B.Id
 where 
 (isnull(wc.ZoneId ,'00000000-0000-0000-0000-000000000000') <> isnull(B.ZoneId,'00000000-0000-0000-0000-000000000000'))
 AND B.ID = wc.BinId

---====================================================================================================
/*
begin TRANSACTION
update HU set 
--HU.ActualLocationId = B.LocationId
HU.ActualZoneId = B.ZoneId
--,HU. ActualBinId = B.id
 from handlingunit HU
 inner join BIN B on HU.ActualBinId = B.Id
 where 
 (isnull(HU.ActualZoneId ,'00000000-0000-0000-0000-000000000000') <> isnull(B.ZoneId,'00000000-0000-0000-0000-000000000000'))
  --or  HU.ActualLocationId <> B.LocationId
Rollback

begin TRANSACTION
update LP set 
--LP.ActualLocationId = B.LocatioinID
LP.ActualZoneId = B.ZoneId
--,LP.ActualBinId = B.id
 from Loosepart LP
 inner join BIN B on LP.ActualBinId = B.Id
 where 
 (isnull(LP.ActualZoneId ,'00000000-0000-0000-0000-000000000000') <> isnull(B.ZoneId,'00000000-0000-0000-0000-000000000000'))
 --or  LP.ActualLocationId <> B.LocationId
Rollback


begin TRANSACTION
update WC set
--WC.LocationId = B.LocatioID
WC.ZoneId = B.ZoneId
--,WC.BinId = B.id
 from WarehouseContent WC
 inner join BIN B on WC.BinId = B.Id
 where 
 (isnull(WC.ZoneId,'00000000-0000-0000-0000-000000000000') <> isnull(B.ZoneId,'00000000-0000-0000-0000-000000000000'))
 --or  WC.LocationId <> B.LocationId
Rollback



begin TRANSACTION
update WE set
--WE.LocationId = B.LocationId, 
WE.ZoneId = B.ZoneId
--,WE.BinId = B.id
 from  WarehouseEntry WE
 inner join BIN B on WE.BinId = B.Id
 where 
 (isnull(WE.ZoneId,'00000000-0000-0000-0000-000000000000') <> isnull(B.ZoneId,'00000000-0000-0000-0000-000000000000'))
 --or  WE.LocationId <> B.LocationId)

Rollback
*/