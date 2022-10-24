

DECLARE @DATEFROM AS DATETIME
DECLARE @DATETO AS DATETIME
DECLARE @CALENDER TABLE(DATE DATETIME)

SET @DATEFROM = '2018-01-01'
SET @DATETO = '2018-12-31'

INSERT INTO   @CALENDER   (DATE)
VALUES (@DATEFROM)
WHILE @DATEFROM < @DATETO
BEGIN
    SELECT @DATEFROM = DATEADD(D, 1, @DATEFROM)
    INSERT INTO @CALENDER (DATE)
    VALUES (@DATEFROM)
END


select
usedcapacity.EntityID, 
usedcapacity.EntityCode, 
BU.Name as Client,
L.Name as Location,
Z.name as Zone,
--b.Code as Bin,
usedcapacity.LocationId,
usedcapacity.ClientBusinessUnitId,
year(usedcapacity.[DATE]) as 'Year',
Month(usedcapacity.[DATE]) as 'Month',
DATEPART(isoWK,usedcapacity.[DATE]) as 'Week',
DATEPART(DAY,usedcapacity.[DATE]) as 'Day',
usedcapacity.[DATE],
usedcapacity.BaseArea,
max(Capacity.Capacity) as Capacity

 from(
select 
interval.LocationId,
Interval.ZoneId,
Interval.BinId,
interval.ClientBusinessUnitId,
Interval.EntityID,
Interval.EntityCode,
Interval.EarliestDate,
Interval.LatestDate,
Calender.[DATE],
Interval.Inbounddate,
Interval.OutboundDate,
case when interval.OutboundDate is null then cast(getdate()-1 as date) else interval.LatestDate end as LastDate,
Interval.BaseArea

FROM
(select
WE.LocationId,
WE.ZoneId,
WE.BinId,
isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId) as EntityID,
(isnull(isnull(lp.Code,HU.Code),PHU.Code)) as EntityCode,
min((isnull(isnull(lp.BaseArea,HU.BaseArea),PHU.BaseArea))) as BaseArea,
isnull(isnull(lp.ClientBusinessUnitId,HU.ClientBusinessUnitId),PHU.ClientBusinessUnitId) as 'ClientBusinessUnitId',
min(RegisteringDate) EarliestDate,
max(RegisteringDate) LatestDate,
min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then RegisteringDate else null end) as Inbounddate,
max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then RegisteringDate else null end) as OutboundDate
from WarehouseEntry WE
left outer join LoosePart LP on WE.LoosepartId = LP.Id and we.HandlingUnitId is null
left outer join HandlingUnit HU on WE.HandlingUnitId = HU.id and we.ParentHandlingUnitId is null
left outer join HandlingUnit PHU on WE.ParentHandlingUnitId = PHU.id
    Where we.LocationId is not null
    --and isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId) in ('7ca11b85-9c13-49bc-999a-c79253dc02d0')
group by 
WE.LocationId,
WE.ZoneId,
WE.BinId,
isnull(isnull(lp.ClientBusinessUnitId,HU.ClientBusinessUnitId),PHU.ClientBusinessUnitId),
isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId),
(isnull(isnull(lp.Code,HU.Code),PHU.Code))
) as Interval

,@CALENDER Calender
where CALENDER.DATE between Interval.Inbounddate and (case when interval.OutboundDate is null then cast(getdate()-1 as date) else interval.LatestDate end)
--and Interval.ClientBusinessUnitId = '6e8169ad-600f-4243-890b-516bd5d4ccfb'
--and EntityID in('7ca11b85-9c13-49bc-999a-c79253dc02d0')
--and Interval.OutboundDate is null

--order by Calender.[DATE],Entityid
) as usedcapacity

left outer join (
select
B.LocationId,
B.ZoneId,
B.id,
B.ClientBusinessUnitId,
cast(B.Length as decimal)*cast(B.Width as decimal)/1000000 as Capacity
 from bin B
where  b.[Disabled] = 0

) Capacity on usedcapacity.ClientBusinessUnitId = Capacity.ClientBusinessUnitId and usedcapacity.LocationId = Capacity.LocationID and usedcapacity.BinId = Capacity.id
inner join BusinessUnit BU on usedcapacity.ClientBusinessUnitId = BU.id
inner join [Location] L on usedcapacity.LocationId = L.Id and l.[Disabled] = 0
inner join Zone Z on usedcapacity.ZoneId = Z.Id and Z.[Disabled] = 0
--inner join Bin B on usedcapacity.BinId = B.Id
group by
usedcapacity.EntityID,
usedcapacity.EntityCode, 
BU.Name,
L.Name,
Z.name,
--B.Code,
usedcapacity.LocationId,
usedcapacity.ClientBusinessUnitId,
usedcapacity.[DATE],
usedcapacity.BaseArea

order by 
location, 
--client, 
date




