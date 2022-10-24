DECLARE @DATEFROM AS DATETIME
DECLARE @DATETO AS DATETIME
DECLARE @CALENDER TABLE(DATE DATETIME)

SET @DATEFROM = '2018-01-01'
SET @DATETO = '2018-12-31'

INSERT INTO
    @CALENDER
        (DATE)
VALUES
    (@DATEFROM)

WHILE @DATEFROM < @DATETO
BEGIN

    SELECT @DATEFROM = DATEADD(D, 1, @DATEFROM)
    INSERT 
    INTO
        @CALENDER
            (DATE)
    VALUES
        (@DATEFROM)
END

select
DATEPART(isoWK,Calender.[DATE]) as 'Week',
Calender.[DATE] as 'Day', 
Capacity.Location,
Capacity.Client,
Capacity.Capacity from
(
select 
l.Name as Location,
BU.Name as Client,
sum(cast(B.Length as decimal)*cast(B.Width as decimal)/1000000) as Capacity
 from bin B
inner join BusinessUnit BU on B.ClientBusinessUnitId = BU.id
inner join [Location] L on B.LocationId = L.Id
left join Zone Z on B.ZoneId = Z.id
where l.[Disabled] = 0 and b.[Disabled] = 0
and b.ClientBusinessUnitId = 'eea04317-3996-4dc2-a51d-606f69be7943'

group by 
BU.Name,
L.Name
) Capacity, @CALENDER calender


/*
select top 1000
bu.name,
RegisteringDate,
isnull(isnull(lp.id,HU.id),PHU.id) as EntityID,
isnull(isnull(lp.Code,HU.CODE),PHU.Code) as EntityCode,
Sum(isnull(isnull(lp.BaseArea,HU.BaseArea),PHU.BaseArea)) as BaseArea
from WarehouseEntry WE
inner join [Location] L on WE.LocationId= L.Id
inner join BusinessUnit BU on L.ClientBusinessUnitId = BU.Id
left join bin B on WE.BinId = B.Id
left outer join LoosePart LP on WE.LoosepartId = LP.Id and we.HandlingUnitId is null
left outer join HandlingUnit HU on WE.HandlingUnitId = HU.id and we.ParentHandlingUnitId is null
left outer join HandlingUnit PHU on WE.ParentHandlingUnitId = PHU.id
--where L.ClientBusinessUnitId = 'eea04317-3996-4dc2-a51d-606f69be7943'
where lp.id = '930c2c5f-2f1e-4cfe-a8d6-3ff7b54ced4d'
group by
bu.name,
RegisteringDate,
isnull(isnull(lp.id,HU.id),PHU.id),
isnull(isnull(lp.Code,HU.CODE),PHU.Code)

order by 
isnull(isnull(lp.Code,HU.CODE),PHU.Code)

*/