DECLARE @Datum as Date = '2023-03-15'
DECLARE @StockPeriodFrom as INT = 3
declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
declare @RelatedBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')
declare @LocationId as UNIQUEIDENTIFIER = (select id from Location where Code = 'Deufol Rosshafen')
declare @CustomerID as UNIQUEIDENTIFIER = 'd2c29054-659e-469f-817e-d237ba756062'


Select
DATA.ClientBusinessUnitName
,'BusinessUnitName' = (select Name from BusinessUnit where id = @RelatedBusinessUnitId)
,DATA.CustomerName
,DATA.Location
,DATA.InboundDate
,DATA.StockDateFrom
,DATA.StockDateTo
,DATA.OutboundDate
,DATA.DaysOnStock
,DATA.Code
,DATA.Weight*DUOM.WeightUnitCoef Weight
,DATA.Volume*DUOM.VolumeUnitCoef Volume
,DATA.Surface*DUOM.AreaUnitCoef Surface
,DATA.BaseArea*DUOM.AreaUnitCoef BaseArea
,DATA.Netto*DUOM.WeightUnitCoef Netto
,DATA.Brutto*DUOM.WeightUnitCoef Brutto
,DATA.Length*DUOM.BasicUnitCoef Length
,DATA.Width*DUOM.BasicUnitCoef Width
,DATA.Height*DUOM.BasicUnitCoef Height
,DATA.ColliNumber
,DATA.Project
,DATA.[Order]
,DATA.Commission
,DATA.ReceiptGoods
,DATA.Entity 
,A.Text AreaUnitName,
W.Text WeightUnitName, 
B.Text BasicUnitName,
V.Text VolumeUnitName,
DUOM.WeightUnitDec,
DUOM.VolumeUnitDec,
DUOM.LengthUnitDec,
DUOM.AreaUnitDec,
DUOM.BasicUnitDec
,ISNULL(U.LastLanguage,'en') as Language
FROM (

SELECT
'ClientBusinessUnitName' = (select Name from BusinessUnit where id = @ClientBusinessUnitId)
--,'BusinessUnitName' = (select Name from BusinessUnit where id = P{RelatedBusinessUnitId)
,'CustomerName' = (select Description from DimensionValue where id = @CustomerId)
,'Location' = (select Name from Location where id = @LocationId)
,DATA.InboundDate
,DATA.StockDateFrom
,DATA.StockDateTo
,DATA.OutboundDate
,DATA.DaysOnStock
,DATA.Code
,DATA.Weight
,DATA.Volume
,DATA.Surface
,DATA.BaseArea
,DATA.Netto
,DATA.Brutto
,DATA.ColliNumber
,DATA.Length
,DATA.Width
,DATA.Height
,Dimensions.Project
,Dimensions.[Order]
,Dimensions.Commission
,Dimensions.ReceiptGoods
,DATA.Entity

FROM (
select distinct '2' Entity,
ENT.[Code],ENT.[Weight],ENT.[Volume],ENT.[Surface],ENT.[BaseArea],ENT.[Netto],ENT.[Brutto],ENT.[ColliNumber],ENT.Length,ENT.Width,ENT.Height
,WE.HandlingUnitId EntityId
,INBOUND.MinCreated InboundDate
,DATEADD(DAY, @StockPeriodFrom ,INBOUND.MinCreated) StockDateFrom
,CASE WHEN ISNULL(OUTBOUND.MaxCreated, @Datum) > @Datum THEN @Datum ELSE ISNULL(OUTBOUND.MaxCreated,@Datum) END  StockDateTo
,OUTBOUND.MaxCreated OutboundDate
,DATEDIFF(DAY,DATEADD(DAY,@StockPeriodFrom,INBOUND.MinCreated),CASE WHEN ISNULL(OUTBOUND.MaxCreated,@Datum) > @Datum THEN @Datum ELSE ISNULL(OUTBOUND.MaxCreated,@Datum) END)  DaysOnStock
from WarehouseEntry WE WITH (NOLOCK)
INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on WE.HandlingUnitId = BUP.HandlingUnitId and BUP.BusinessUnitId =  @ClientBusinessUnitId 

INNER JOIN (

    select distinct  WE.HandlingUnitId,   
MIN(WE.Created) over (PARTITION by HandlingUnitId) MinCreated,WE.LocationId 
 from WarehouseEntry WE
where WE.LocationId =  @LocationId  and WE.Quantity > 0

) INBOUND on WE.HandlingUnitId = INBOUND.HandlingUnitId and WE.LocationId = INBOUND.LocationId

LEFT JOIN (

    select WE.HandlingUnitId,   
MAX(WE.Created) MaxCreated,WE.LocationId 
 from WarehouseEntry WE WITH (NOLOCK)
where WE.LocationId = @LocationId  and WE.Quantity < 0
group by WE.HandlingUnitId,WE.LocationId 

) OUTBOUND ON WE.HandlingUnitId = OUTBOUND.HandlingUnitId and WE.LocationId = OUTBOUND.LocationId

INNER JOIN HandlingUnit ENT on WE.HandlingUnitId = ENT.Id 
INNER JOIN EntityDimensionValueRelation EDVR on ENT.Id = EDVR.EntityId and  EDVR.DimensionValueId = CASE WHEN @CustomerId IS NULL THEN EDVR.DimensionValueId ELSE @CustomerId END
WHERE 
WE.ParentHandlingUnitId IS NULL AND
@Datum  >= INBOUND.MinCreated AND @Datum <= ISNULL(OUTBOUND.MaxCreated,GETDATE()) 
AND EDVR.DimensionValueId = CASE WHEN  @CustomerId IS NULL THEN EDVR.DimensionValueId ELSE @CustomerId END



UNION


select distinct '1' Entity,
ENT.[Code],ENT.[Weight],ENT.[Volume],ENT.[Surface],ENT.[BaseArea],ENT.[Netto],ENT.[Weight],NULL [ColliNumber],ENT.Length,ENT.Width,ENT.Height 
,WE.LoosePartId EntityId
,INBOUND.MinCreated InboundDate
,DATEADD(DAY, @StockPeriodFrom ,INBOUND.MinCreated) StockDateFrom
,CASE WHEN ISNULL(OUTBOUND.MaxCreated, @Datum) > @Datum THEN @Datum ELSE ISNULL(OUTBOUND.MaxCreated,@Datum) END  StockDateTo
,OUTBOUND.MaxCreated OutboundDate
,DATEDIFF(DAY,DATEADD(DAY,@StockPeriodFrom,INBOUND.MinCreated),CASE WHEN ISNULL(OUTBOUND.MaxCreated,@Datum) > @Datum THEN @Datum ELSE ISNULL(OUTBOUND.MaxCreated,@Datum) END)  DaysOnStock
from WarehouseEntry WE 
INNER JOIN BusinessUnitPermission BUP on WE.LoosePartId = BUP.LoosePartId and BUP.BusinessUnitId =  @ClientBusinessUnitId 
INNER JOIN (

    select distinct  WE.LoosePartId,   
MIN(WE.Created) over (PARTITION by LoosePartId) MinCreated,WE.LocationId 
 from WarehouseEntry WE WITH (NOLOCK)
where WE.LocationId =  @LocationId and WE.Quantity > 0

) INBOUND on WE.LoosePartId = INBOUND.LoosePartId and WE.LocationId = INBOUND.LocationId

LEFT JOIN (

    select  WE.LoosePartId,   
MAX(WE.Created) MaxCreated,WE.LocationId 
 from WarehouseEntry WE WITH (NOLOCK)
where WE.LocationId =  @LocationId  and WE.Quantity < 0 AND WE.HandlingUnitId IS NULL
group by WE.LoosePartId,WE.LocationId 
) OUTBOUND ON WE.LoosePartId = OUTBOUND.LoosePartId and WE.LocationId = OUTBOUND.LocationId

INNER JOIN LoosePart ENT on WE.LoosePartId = ENT.Id 
INNER JOIN EntityDimensionValueRelation EDVR on ENT.Id = EDVR.EntityId and  EDVR.DimensionValueId = CASE WHEN @CustomerId IS NULL THEN EDVR.DimensionValueId ELSE @CustomerId END

WHERE 

WE.HandlingUnitId IS NULL AND WE.ParentHandlingUnitId IS NULL AND
@Datum  >= INBOUND.MinCreated AND @Datum <= ISNULL(OUTBOUND.MaxCreated,GETDATE()) 
AND EDVR.DimensionValueId = CASE WHEN  @CustomerId IS NULL THEN EDVR.DimensionValueId ELSE @CustomerId END

) DATA

LEFT JOIN  (
select 
D.name, 
--Case D.name when 'Project' then DV.Content+' '+isnull(DV.[Description],'.') else DV.Content end as Content, 
DV.Content+' '+isnull(DV.[Description],'') as content,
--DV.Content, 
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order','Commission','ReceiptGoods') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission],[ReceiptGoods])
        ) as Dimensions ON DATA.EntityId = Dimensions.EntityId
         ) DATA
 ,[User] U
inner join DisplayUOM DUOM on U.DisplayUOMId = DUOM.Id
inner join Translation A on DUOM.id = A.EntityId and A.Language = ISNULL(U.LastLanguage,'en')   and A.[Column] = 'AreaUnitName'
inner join Translation B on DUOM.id = B.EntityId and B.Language = ISNULL(U.LastLanguage,'en')  and B.[Column] = 'BasicUnitName'
inner join Translation L on DUOM.id = L.EntityId and L.Language = ISNULL(U.LastLanguage,'en')  and L.[Column] = 'LengthUnitName'
inner join Translation V on DUOM.id = V.EntityId and V.Language = ISNULL(U.LastLanguage,'en')   and V.[Column] = 'VolumeUnitName'
inner join Translation W on DUOM.id = W.EntityId and W.Language = ISNULL(U.LastLanguage,'en')   and W.[Column] = 'WeightUnitName'

WHERE U.Id = (Select id from [User] where login = 'tomas.barcuch')--$P{LoggedInUsername})