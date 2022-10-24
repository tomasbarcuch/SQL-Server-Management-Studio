declare @datefrom as DATE
declare @dateto as DATE
declare @date as DATE

set @date = getdate()
set @dateto = getdate()
set @datefrom = getdate()

use DFCZ_OSLET

Select
BUname,
logged,
count(distinct(loglist.UserName)) 'Successfully logged users',
count(loglist.id) 'Successfully loggins'
from (
SELECT cast ([LogTime] as date) as LogDate
      
      ,Bu.name as BUname
      ,L.[UserName]
      ,L.[Message]
  	  ,left(message,4) as logged
	  ,L.id

  FROM [dbo].[Log4Net] L
  inner join [User] U on L.UserName = U.[Login]
  inner join BusinessUnit  BU on U.LastBusinessUnitId = BU.Id
  
  where 
  cast (logtime as date) between @DATEFROM and @dateto
  and right(message,9) = 'logged in') loglist
  --where loglist.logged = 'USER'
  group by BUname,loglist.LogDate,loglist.logged
  order by BUname, logged

--=====================================================================================================================

select

bu.name as 'Busines unit',
min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then cast(RegisteringDate as date) else null end) as Inbounddate,
count(distinct(lp.Code)) 'count',
sum(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then lp.BaseArea else null end) as Inbound,
sum(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then lp.Weight else null end) as 'Weight'


from WarehouseEntry WE
inner join BusinessUnitPermission BUP on WE.LoosepartId = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.type = 0
inner join LoosePart LP on WE.LoosepartId = LP.Id 

where @date = case WHEN WE.QuantityBase > 0 and we.LocationId is not null then cast(RegisteringDate as date) else null end
group by 
bu.name

select 
data.bu as 'Busines unit',
data.packeddate,
count(distinct(data.Code)) 'Packed HUs',
sum(data.packed) as 'Packed HUs BaseArea',
sum(data.LPs) as 'Packed LPs'
from

(select
HU.code,
bu.name BU,
count(distinct we.LoosepartId) as LPs,
min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null and we.LoosepartId is not null then cast(We.Created as date) else null end) as Packeddate,
case WHEN WE.QuantityBase > 0 and we.LocationId is not null and we.LoosepartId is not null then HU.BaseArea else null end as Packed


from WarehouseEntry WE
inner join BusinessUnitPermission BUP on WE.HandlingUnitId = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.type = 0
inner join HandlingUnit HU on WE.HandlingUnitId = HU.Id 

group by 
hu.code, 
bu.name, HU.BaseArea,case WHEN WE.QuantityBase > 0 and we.LocationId is not null and we.LoosepartId is not null then HU.BaseArea else null end,cast(We.Created as date)

having case WHEN WE.QuantityBase > 0 and we.LocationId is not null and we.LoosepartId is not null then HU.BaseArea else null end is not null) data

where packeddate between @DATEFROM and @dateto

group by 
data.bu,
data.packeddate


--===================================================================================================================


select 
data.bu as 'Busines unit',
data.Dispatcheddate,
count(distinct(data.Code)) 'count',
sum(data.Dispatched) as 'Dispatched',
Sum(data.Weight) as 'Weight'
from

(select
HU.code,
bu.name 'BU',
max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then cast(We.Created as date) else null end) as 'Dispatcheddate',
case WHEN WE.QuantityBase < 0 and we.LocationId is not null then HU.BaseArea else null end as 'Dispatched',
case WHEN WE.QuantityBase < 0 and we.LocationId is not null then HU.Brutto else null end as 'Weight'

from WarehouseEntry WE
inner join BusinessUnitPermission BUP on WE.HandlingUnitId = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.type = 0
inner join HandlingUnit HU on WE.HandlingUnitId = HU.Id 

group by 
hu.code, 
bu.name, 
HU.BaseArea,case WHEN WE.QuantityBase < 0 and we.LocationId is not null then HU.BaseArea else null end,
case WHEN WE.QuantityBase < 0 and we.LocationId is not null then HU.Brutto else null end,
cast(We.Created as date)

having case WHEN WE.QuantityBase < 0 and we.LocationId is not null then HU.BaseArea else null end is not null) data

where Dispatcheddate between @DATEFROM and @dateto

group by 
data.bu,
data.Dispatcheddate

--==========================================================================================================================================

select 
BusinessUnit,
cast(LoadingDateTime as date),
Sum(SHs) as 'SHs',
sum(weight) as 'Weight',
sum(HUs) as 'HUs',
sum(LPs) as 'LPs',
Sum(BAse) as 'Qm',
sum(Surface) as 'Surface'
 from (
   select BU.Name as BusinessUnit,
   Count(distinct SH.id) as SHs,
sum(isnull(HU.Brutto,LP.weight)) as weight,
count (distinct sl.HandlingUnitId) HUs,
sum (HU.BaseArea) as Base,
sum (HU.Surface) as Surface,
count (distinct sl.LoosePartId)LPs,
case when (
left(right((convert(datetime, SH.LoadingDate) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
SH.LoadingDate + right((convert(datetime, SH.LoadingDate) at TIME zone 'Central European Standard Time'),5)
else 
SH.LoadingDate - right((convert(datetime, SH.LoadingDate) at TIME zone 'Central European Standard Time'),5)
end as LoadingDateTime

 from ShipmentLine SL
 inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id and SH.Type='0'
 inner join BusinessUnitPermission BUP on SL.id = BUP.ShipmentLineId
 inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.Type = 0
 left join HandlingUnit HU on SL.HandlingUnitId = HU.Id
 left join LoosePart LP on SL.LoosePartId = LP.id

where hu.ActualLocationId is null and lp.ActualBinId is null

group by BU.Name,case when (
left(right((convert(datetime, SH.LoadingDate) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
SH.LoadingDate + right((convert(datetime, SH.LoadingDate) at TIME zone 'Central European Standard Time'),5)
else 
SH.LoadingDate - right((convert(datetime, SH.LoadingDate) at TIME zone 'Central European Standard Time'),5)
end) DATA

where cast(LoadingDateTime as date) between @DATEFROM and @dateto
group by cast(LoadingDateTime as date), BusinessUnit

/*==========================================================================================================*/
Select  
 BUpa.Name BusinessUnitName,
 --BU.name ClientUnitName,
 --OnWarehouse.LocationId, 
 --OnWarehouse.[Location] LocationName, 
 Sum(Onwarehouse.basearea) UsedArea, 
max(LocCapacity) as Capacity,
 cast(case when max(OnWarehouse.LocCapacity) > 0 then  Sum(Onwarehouse.basearea)/max(OnWarehouse.LocCapacity)*100 else 100 end as decimal(20,1)) Utilisation, 
 calendar.date Date from  
 (select 
 Data.LocationId,
 L.Name as Location, 
 Lcap.LocCapacity, 
 sum(data.BaseArea) as BaseArea,
 sum(data.Surface) as Surface,
 Data.Inbounddate, 
 isnull(data.OutboundDate,getdate()-1) as Outbounddate 
 from ( 
 select 
 WE.LocationId,
  isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId) as EntityID, 
 sum(isnull(isnull(lp.BaseArea,HU.BaseArea),PHU.BaseArea)) as BaseArea, 
  sum(isnull(isnull(lp.Surface,HU.Surface),PHU.Surface)) as Surface, 
 min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then RegisteringDate else null end) as Inbounddate, 
 max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then RegisteringDate else null end) as OutboundDate 
 from WarehouseEntry WE 
 left outer join LoosePart LP on WE.LoosepartId = LP.Id and we.HandlingUnitId is null 
 left outer join HandlingUnit HU on WE.HandlingUnitId = HU.id and we.ParentHandlingUnitId is null 
 left outer join HandlingUnit PHU on WE.ParentHandlingUnitId = PHU.id 
 Where we.LocationId is not null and
 --and EXISTS(select * from BusinessUnitPermission where BusinessUnitId = (Select id from BusinessUnit where name = 'Deufol Berlin') and 
 --and EXISTS(select * from BusinessUnitPermission where BusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2' and
 (((LoosepartId = WE.LoosePartId and WE.LoosePartId is not null) or  
 (HandlingUnitId = WE.HandlingUnitId and WE.HandlingUnitId is not null) or 
 (HandlingUnitId = WE.ParentHandlingUnitId and WE.ParentHandlingUnitId is not null))) 
 group by  
 WE.LocationId, 
 isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId), 
 (isnull(isnull(lp.Code,HU.Code),PHU.Code)) 
 ) data 
 left outer join [Location] L on DATA.LocationId = L.Id 
 left outer join (select 
 L.id LocationId,
  Capacity as LocCapacity 
  from Location L 
 where  L.[Disabled] = 0 
) LCap on data.LocationId = LCap.LocationId 
 group by 
 Data.LocationId, 
 L.Name, 
 Lcap.LocCapacity, 
 Data.Inbounddate, 
 isnull(data.OutboundDate,getdate()-1)) OnWarehouse 
inner join  BusinessUnitPermission BUP on OnWarehouse.LocationId = BUP.LocationId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2

left join BusinessUnitRelation BUR on BU.id = BUR.BusinessUnitId
left join BusinessUnit BUpa on BUR.RelatedBusinessUnitId = BUpa.id

 , 
 Calendar
 where 
 calendar.DATE between OnWarehouse.Inbounddate and OnWarehouse.Outbounddate 
 and Calendar.date = cast(@date as date)
and BUpa.Name not like ('%DEMO%')
and BUpa.Name not like ('%TST%')
and BUpa.Name not like ('%Muster%')
 group by
 BUpa.Name, 
 --BU.name,
 --LocCapacity,
 --OnWarehouse.LocationId, 
 --OnWarehouse.[Location], 
 calendar.date 

order by  BUpa.Name



