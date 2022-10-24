Select 
count(distinct(OnWarehouse.ClientBusinessUnitId)),
--OnWarehouse.Client,
--OnWarehouse.LocationId,
OnWarehouse.[Location] LocationCode,
Sum(Onwarehouse.basearea) UsedArea,
max(isnull(OnWarehouse.LocCapacity,0))  Capacity,
case when max(OnWarehouse.LocCapacity) > 0 then  Sum(Onwarehouse.basearea)/max(OnWarehouse.LocCapacity) else 100 end Utilisation,
datepart(iso_week,calender.dates) as CW,
Calender.dates Date,
case datepart(weekday,calender.dates) 
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
isnull(isnull(lp.ClientBusinessUnitId,HU.ClientBusinessUnitId),PHU.ClientBusinessUnitId) as 'ClientBusinessUnitId',
min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then RegisteringDate else null end) as Inbounddate,
max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then RegisteringDate else null end) as OutboundDate
from WarehouseEntry WE
left outer join LoosePart LP on WE.LoosepartId = LP.Id and we.HandlingUnitId is null
left outer join HandlingUnit HU on WE.HandlingUnitId = HU.id and we.ParentHandlingUnitId is null
left outer join HandlingUnit PHU on WE.ParentHandlingUnitId = PHU.id
    Where we.LocationId is not null
    group by 
WE.LocationId,
isnull(isnull(lp.ClientBusinessUnitId,HU.ClientBusinessUnitId),PHU.ClientBusinessUnitId),
isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId),
(isnull(isnull(lp.Code,HU.Code),PHU.Code))
) data

left outer join [Location] L on DATA.LocationId = L.Id
left outer join BusinessUnit BU on Data.ClientBusinessUnitId = BU.id
left outer join (select
L.ClientBusinessUnitId,
L.LocationId,
sum(cast(L.Length as decimal)*cast(L.Width as decimal)/1000000) as LocCapacity
 from bin L
where  L.[Disabled] = 0
group by 
L.ClientBusinessUnitId,


L.LocationId) LCap on data.ClientBusinessUnitId = LCap.ClientBusinessUnitId and data.LocationId = LCap.LocationId

group by
Data.ClientBusinessUnitId,
BU.Name,
Data.LocationId,
L.Name,
Lcap.LocCapacity,
Data.Inbounddate,
isnull(data.OutboundDate,getdate()-1)) OnWarehouse


,
(SELECT		cast([Date]as date) as DATES
		FROM		(
			SELECT
				(a.Number * 256) + b.Number AS N
			FROM 
				(
					SELECT number
					FROM master..spt_values
					WHERE type = 'P' AND number <= 255
				) a (Number),
				(
					SELECT number
					FROM master..spt_values
					WHERE type = 'P' AND number <= 255
				) b (Number)
			) numbers
CROSS APPLY (SELECT DATEADD(day,N,GETDATE()-3650) AS [Date]) d) Calender


where calender.DATES between OnWarehouse.Inbounddate and OnWarehouse.Outbounddate  --and OnWarehouse.ClientBusinessUnitId =  'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2'
--and $X{BETWEEN, calender.DATES,  DATEFROM, DATETO}



group by 
--OnWarehouse.ClientBusinessUnitId,
--OnWarehouse.Client,
--OnWarehouse.LocationId,
OnWarehouse.[Location],
Calender.dates

order by Calender.DATES