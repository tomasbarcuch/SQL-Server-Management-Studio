Declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
Declare @BusinessUnitID as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')
Declare @LocationId as UNIQUEIDENTIFIER = (Select id from [Location] where code = 'Deufol Rosshafen')
Declare @DimensionValueId as UNIQUEIDENTIFIER = (select DV.Id from DimensionValue DV INNER JOIN BusinessUnitPermission BUP on DV.id = BUP.DimensionValueId and BUP.BusinessUnitId = @BusinessUnitID  where Content = 'C005533')
Declare @NoDates as TINYINT = 0
Declare @FromDate as DATE = '2023-03-01'
Declare @ToDate as DATE = '2023-03-31'
Declare @Language as VARCHAR (2) = 'en'
Declare @Datum as DATE = '2018-02-01'
Declare @StockPeriodFrom as INT = 3 --DAYS

--select * from WarehouseContent

--WC where WC.LocationId = @LocationId


SELECT * FROM (
select distinct 
WE.HandlingUnitId EntityId
,INBOUND.MinCreated InboundDate
,DATEADD(DAY,@StockPeriodFrom,INBOUND.MinCreated) StockDateFrom
,CASE WHEN ISNULL(OUTBOUND.MaxCreated,@Datum) > @Datum THEN @Datum ELSE ISNULL(OUTBOUND.MaxCreated,@Datum) END  StockDateTo
,OUTBOUND.MaxCreated OutboundDate
,DATEDIFF(DAY,DATEADD(DAY,@StockPeriodFrom,INBOUND.MinCreated),CASE WHEN ISNULL(OUTBOUND.MaxCreated,@Datum) > @Datum THEN @Datum ELSE ISNULL(OUTBOUND.MaxCreated,@Datum) END)  DaysOnStock
from WarehouseEntry WE 
INNER JOIN BusinessUnitPermission BUP on WE.HandlingUnitId = BUP.HandlingUnitId and BUP.BusinessUnitId = @ClientBusinessUnitId
INNER JOIN (

    select distinct  WE.HandlingUnitId,   
MIN(WE.Created) over (PARTITION by HandlingUnitId) MinCreated,WE.LocationId 
 from WarehouseEntry WE
where WE.LocationId = @LocationId and WE.Quantity > 0

) INBOUND on WE.HandlingUnitId = INBOUND.HandlingUnitId and WE.LocationId = INBOUND.LocationId

LEFT JOIN (

    select WE.HandlingUnitId,   
MAX(WE.Created) MaxCreated,WE.LocationId 
 from WarehouseEntry WE
where WE.LocationId = @LocationId and WE.Quantity < 0
group by WE.HandlingUnitId,WE.LocationId 

) OUTBOUND ON WE.HandlingUnitId = OUTBOUND.HandlingUnitId and WE.LocationId = OUTBOUND.LocationId



WHERE 
--WE.LocationId = @LocationId AND
WE.ParentHandlingUnitId IS NULL AND
@Datum > INBOUND.MinCreated AND @Datum < ISNULL(OUTBOUND.MaxCreated,GETDATE()) 



UNION


select distinct 
WE.LoosePartId EntityId
,INBOUND.MinCreated InboundDate
,DATEADD(DAY,@StockPeriodFrom,INBOUND.MinCreated) StockDateFrom
,CASE WHEN ISNULL(OUTBOUND.MaxCreated,@Datum) > @Datum THEN @Datum ELSE ISNULL(OUTBOUND.MaxCreated,@Datum) END  StockDateTo
,OUTBOUND.MaxCreated OutboundDate
,DATEDIFF(DAY,DATEADD(DAY,@StockPeriodFrom,INBOUND.MinCreated),CASE WHEN ISNULL(OUTBOUND.MaxCreated,@Datum) > @Datum THEN @Datum ELSE ISNULL(OUTBOUND.MaxCreated,@Datum) END)  DaysOnStock
from WarehouseEntry WE 
INNER JOIN BusinessUnitPermission BUP on WE.LoosePartId = BUP.LoosePartId and BUP.BusinessUnitId = @ClientBusinessUnitId
INNER JOIN (

    select distinct  WE.LoosePartId,   
MIN(WE.Created) over (PARTITION by LoosePartId) MinCreated,WE.LocationId 
 from WarehouseEntry WE
where WE.LocationId = @LocationId and WE.Quantity > 0

) INBOUND on WE.LoosePartId = INBOUND.LoosePartId and WE.LocationId = INBOUND.LocationId

LEFT JOIN (

    select  WE.LoosePartId,   
MAX(WE.Created) MaxCreated,WE.LocationId 
 from WarehouseEntry WE
where WE.LocationId = @LocationId and WE.Quantity < 0 AND WE.HandlingUnitId IS NULL
group by WE.LoosePartId,WE.LocationId 
) OUTBOUND ON WE.LoosePartId = OUTBOUND.LoosePartId and WE.LocationId = OUTBOUND.LocationId



WHERE 
--WE.LocationId = @LocationId AND
WE.HandlingUnitId IS NULL AND WE.ParentHandlingUnitId IS NULL AND
@Datum > INBOUND.MinCreated AND @Datum < ISNULL(OUTBOUND.MaxCreated,GETDATE()) 

) DATA

  LEFT JOIN 
  ( SELECT [Id],[Code],[Weight],[Volume],[Surface],[BaseArea],[Netto],[Brutto]  FROM HandlingUnit
UNION
SELECT     [Id],[Code],[Weight],[Volume],[Surface],[BaseArea],[Netto],[Weight] as Brutto  FROM LoosePart
  )
ENT on DATA.EntityId = ENT.Id
--INNER JOIN EntityDimensionValueRelation EDVR on DATA.EntityId = EDVR.EntityId AND EDVR.DimensionValueId = @DimensionValueId 




select 
L.Id LocationId,
L.Name [Location]
from [Location] L
inner join BusinessUnitPermission BUP on L.id = BUP.LocationId and BUP.BusinessUnitId =  (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')
WHERE L.Disabled = 0 order by L.Name


$P{RelatedBusinessUnitId}