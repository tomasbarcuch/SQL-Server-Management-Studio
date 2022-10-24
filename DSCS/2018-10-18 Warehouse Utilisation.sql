Select 
DB_NAME() AS 'Current Database',
OnWarehouse.ClientBusinessUnitId,
OnWarehouse.Client as BusinessUnitName,
OnWarehouse.LocationId,
OnWarehouse.[Location] LocationCode,
Sum(Onwarehouse.basearea) UsedArea,
max(isnull(OnWarehouse.LocCapacity,0))  Capacity,
case when max(OnWarehouse.LocCapacity) > 0 then  Sum(Onwarehouse.basearea)/max(OnWarehouse.LocCapacity) else 100 end Utilisation,
calendar.Week CW,
Calendar.date as Date,
case calendar.DayOfWeek
when 1 then 'Sonntag'
when 2 then 'Montag'
when 3 then 'Dienstag'
when 4 then 'Mittwoch'
when 5 then 'Donnerstag'
when 6 then 'Freitag'
when 7 then 'Sammstag'
end
AS 'day' 
from 
(select
Data.ClientBusinessUnitId,
BU.Name as Client,
L.Name as Location,
Data.LocationId,
Lcap.LocCapacity,
sum(data.BaseArea) as BaseArea,
Data.Inbounddate,
isnull(data.OutboundDate,getdate()-1) as Outbounddate
from (

select
WE.LocationId,
isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId) as EntityID,
sum(isnull(isnull(lp.BaseArea,HU.BaseArea),PHU.BaseArea)) as BaseArea,
isnull(isnull(BUPlp.BusinessUnitId,BUPphu.BusinessUnitId),BUPphu.BusinessUnitId ) as 'ClientBusinessUnitId',
min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then RegisteringDate else null end) as Inbounddate,
max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then RegisteringDate else null end) as OutboundDate
from WarehouseEntry WE
left join businessunitpermission BUPlp on WE.loosepartid = BUPlp.LoosepartId
left join LoosePart LP on BUPlp.LoosepartId = LP.Id and we.HandlingUnitId is null

left join businessunitpermission BUPhu on WE.HandlingUnitId = BUPhu.HandlingUnitId
left join HandlingUnit HU on BUPhu.HandlingUnitId = HU.id and we.ParentHandlingUnitId is null

left join businessunitpermission BUPphu on WE.ParentHandlingUnitId = BUPphu.HandlingUnitId
left join HandlingUnit PHU on BUPphu.HandlingUnitId = PHU.id
    Where we.LocationId is not null
    group by 
WE.LocationId,
isnull(isnull(BUPlp.BusinessUnitId,BUPphu.BusinessUnitId),BUPphu.BusinessUnitId ),
isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId),
(isnull(isnull(lp.Code,HU.Code),PHU.Code))) data

left outer join [Location] L on DATA.LocationId = L.Id
left outer join BusinessUnit BU on Data.ClientBusinessUnitId = BU.id
left outer join (select
BUP.BusinessUnitId ClientBusinessUnitId,
L.id LocationId,
L.Capacity as LocCapacity
 from LOCATION L
inner join BusinessUnitPermission BUP on L.id = BUP.LocationId
where  L.[Disabled] = 0
) LCap on data.ClientBusinessUnitId = LCap.ClientBusinessUnitId and data.LocationId = LCap.LocationId

group by
Data.ClientBusinessUnitId,
BU.Name,
Data.LocationId,
L.Name,
Lcap.LocCapacity,
Data.Inbounddate,
isnull(data.OutboundDate,getdate()-1)) OnWarehouse
,calendar




where calendar.DATE between OnWarehouse.Inbounddate and OnWarehouse.Outbounddate  and OnWarehouse.ClientBusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
--$P{ClientBusinessUnitID} 
--and $X{BETWEEN, calendar.DATES  FromDate, ToDate}
--and $X{IN,OnWarehouse.LocationId, LocationIDs} 



group by 
OnWarehouse.ClientBusinessUnitId,
OnWarehouse.Client,
OnWarehouse.LocationId,
OnWarehouse.[Location],
Calendar.date,
calendar.Week,
Calendar.date,
calendar.DayOfWeek

order by Calendar.DATE