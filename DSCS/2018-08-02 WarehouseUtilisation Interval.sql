DECLARE @DATEFROM AS DATETIME
DECLARE @DATETO AS DATETIME
DECLARE @Client as UNIQUEIDENTIFIER
DECLARE @Location as UNIQUEIDENTIFIER

SET @DATEFROM = '2018-01-01'
SET @DATETO = getdate()-1
SET @Client = '6e8169ad-600f-4243-890b-516bd5d4ccfb'

/*Vytvoření a naplnění tabulky skladových pohybů a intervalů*/
DECLARE @INTERVAL TABLE(
    LocationID UNIQUEIDENTIFIER, 
    ZoneID UNIQUEIDENTIFIER,
    BinID UNIQUEIDENTIFIER,
    EntityID UNIQUEIDENTIFIER,
    Entity TINYINT,
    EntityCode VARCHAR (20),
    BaseArea float,
    ClientBusinessLientID UNIQUEIDENTIFIER,
    PackerBusinessLientID UNIQUEIDENTIFIER,
    VendorBusinessLientID UNIQUEIDENTIFIER,
    LatestDate DATE,
    InboundDate DATE,
    OutboundDate DATE
    )

    insert into @Interval (LocationID,ZoneID, BinID,EntityID, Entity, EntityCode,BaseArea,ClientBusinessLientID,PackerBusinessLientID,VEndorBusinessLientID,InboundDate,OutboundDate) 

select
WE.LocationId,
WE.ZoneId,
WE.BinId,
isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId) as EntityID,
case when lp.id is not null then 15 else 11 end as Entity,
(isnull(isnull(lp.Code,HU.Code),PHU.Code)) as EntityCode,
min((isnull(isnull(lp.BaseArea,HU.BaseArea),PHU.BaseArea))) as BaseArea,
isnull(isnull(lp.ClientBusinessUnitId,HU.ClientBusinessUnitId),PHU.ClientBusinessUnitId) as 'ClientBusinessUnitId',
isnull(isnull(lp.PackerBusinessUnitId,HU.PackerBusinessUnitId),PHU.PackerBusinessUnitId) as 'PackerBusinessUnitId',
isnull(isnull(lp.VendorBusinessUnitId,HU.VendorBusinessUnitId),PHU.VendorBusinessUnitId) as 'VendorBusinessUnitId',
min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then RegisteringDate else null end) as Inbounddate,
max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then RegisteringDate else null end) as OutboundDate
from WarehouseEntry WE
left outer join LoosePart LP on WE.LoosepartId = LP.Id and we.HandlingUnitId is null
left outer join HandlingUnit HU on WE.HandlingUnitId = HU.id and we.ParentHandlingUnitId is null
left outer join HandlingUnit PHU on WE.ParentHandlingUnitId = PHU.id
    Where we.LocationId is not null
    group by 
WE.LocationId,
WE.ZoneId,
WE.BinId,
isnull(isnull(lp.ClientBusinessUnitId,HU.ClientBusinessUnitId),PHU.ClientBusinessUnitId),
isnull(isnull(lp.PackerBusinessUnitId,HU.PackerBusinessUnitId),PHU.PackerBusinessUnitId),
isnull(isnull(lp.VendorBusinessUnitId,HU.VendorBusinessUnitId),PHU.VendorBusinessUnitId),
isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId),
(isnull(isnull(lp.Code,HU.Code),PHU.Code))
,case when lp.id is not null then 15 else 11 end



/*Vytvoření a naplnění tabulky s daty kalendáře */

DECLARE @CALENDER TABLE(DATE DATETIME)

INSERT INTO   @CALENDER   (DATE)
VALUES (@DATEFROM)
WHILE @DATEFROM < @DATETO
BEGIN
    SELECT @DATEFROM = DATEADD(D, 1, @DATEFROM)
    INSERT INTO @CALENDER (DATE)
    VALUES (@DATEFROM)
END


/*Vytvoření a naplnění tabulky kapacit lokací a skladovacích přihrádek*/

declare @CAPACITY TABLE(
ClientBusinessUnitID UNIQUEIDENTIFIER,
LocationId UNIQUEIDENTIFIER,
ZoneID UNIQUEIDENTIFIER,
BinId UNIQUEIDENTIFIER,
LocCapacity float,
ZonCapacity float,
BinCapacity float     
)
insert into @CAPACITY
select
B.ClientBusinessUnitId,
B.LocationId,
B.ZoneId,
B.id BinId,
Lcap.LocCapacity,
Zcap.ZonCapacity,
sum(cast(B.Length as decimal)*cast(B.Width as decimal)/1000000) as BinCapacity

 from bin B

left outer join (select
Z.ClientBusinessUnitId,
Z.ZoneId,
sum(cast(Z.Length as decimal)*cast(Z.Width as decimal)/1000000) as ZonCapacity
from bin Z
where  Z.[Disabled] = 0
group by 
Z.ClientBusinessUnitId,
Z.ZoneId) ZCap on B.ClientBusinessUnitId = ZCap.ClientBusinessUnitId and B.ZoneId = Zcap.ZoneId

left outer join (select
L.ClientBusinessUnitId,
L.LocationId,
sum(cast(L.Length as decimal)*cast(L.Width as decimal)/1000000) as LocCapacity
 from bin L
where  L.[Disabled] = 0
group by 
L.ClientBusinessUnitId,
L.LocationId) LCap on B.ClientBusinessUnitId = LCap.ClientBusinessUnitId and B.LocationId = LCap.LocationId

where  b.[Disabled] = 0
group by 
B.ClientBusinessUnitId,
B.LocationId,
B.ZoneId,
B.ID,
LCap.LocCapacity,
zcap.ZonCapacity


/*Vytvoření a naplnění tabulky výsledných dat*/

DECLARE @UTILISATION TABLE (
    ClientBusinessUnitID UNIQUEIDENTIFIER,
    LocationID UNIQUEIDENTIFIER,
    ZoneID UNIQUEIDENTIFIER,
    BinID UNIQUEIDENTIFIER,
    EntityID UNIQUEIDENTIFIER,
    Entity TINYINT,
    WarehouseDate DATE,
    BaseArea FLOAT,
    BinCapacity FLOAT,
    ZoneCapacity FLOAT,
    LocationCapacity FLOAT
)

insert into @Utilisation ( ClientBusinessUnitID, LocationID, ZoneID, BinID, EntityID, Entity, WarehouseDate, BaseArea, BinCapacity, ZoneCapacity, LocationCapacity)

select 
OnWarehouse.ClientBusinessLientID,
OnWarehouse.LocationID,
OnWarehouse.ZoneID,
OnWarehouse.BinID,
OnWarehouse.EntityID,
OnWarehouse.Entity,
Calender.[DATE],
OnWarehouse.BaseArea,
OnWarehouse.BinCapacity,
OnWarehouse.ZonCapacity,
OnWarehouse.LocCapacity


 from (
select

Interval.BaseArea,
Interval.BinID,
Interval.ClientBusinessLientID,
Interval.Entity,
Interval.EntityCode,
Interval.EntityID,
Interval.InboundDate,
Interval.LatestDate,
Interval.LocationID,
Isnull(Interval.OutboundDate,@DATETO) as OutboundDate,
Interval.ZoneID,
isnull(Capacity.BinCapacity,0) BinCapacity,
isnull(Capacity.ZonCapacity,0) ZonCapacity,
isnull(Capacity.LocCapacity,0) LocCapacity

 from @INTERVAL Interval
left outer join @CAPACITY Capacity 
on Interval.ClientBusinessLientID = Capacity.ClientBusinessUnitID 
and Interval.LocationID = Capacity.LocationId
and Interval.ZoneID = Capacity.ZoneID
and Interval.BinID = Capacity.BinId
) OnWarehouse

,@Calender Calender where CALENDER.DATE between OnWarehouse.Inbounddate and OnWarehouse.OutboundDate and OnWarehouse.ClientBusinessLientID = @Client

Select 
    *,
    datepart(dd,WarehouseDate) as day,
    DATEPART(dw,WarehouseDate) as weekday,
    datepart(iso_week, WarehouseDate) as Week
from @UTILISATION UTILISATION