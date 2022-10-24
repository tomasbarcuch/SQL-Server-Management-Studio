select
Dimensions.Project,
Dimensions.[Order],
Dimensions.Commission,
HU.ColliNumber,
HU.Code,
L.Name Location,
LEAD(Z.Name) over (order by HU.Code, MIN(DATA.DateFrom)) as FromZone,
Z.Name ToZone,
MIN(DATA.DateFrom) FromDate ,
MAX(DATA.DateTo) Todate,
DATEDIFF(DAY,MIN(DATA.DateFrom),MAX(DATA.DateTo))+1 'DAYS',
CASE WHEN DATEDIFF(DAY,MIN(DATA.DateFrom),MAX(DATA.DateTo)) > 2 then 'INVOICE' else '' end as 'Invoice'


from (
select
ISNULL(WE.ParentHandlingUnitId,WE.HandlingUnitId) as HandlingUnitId,
WE.LocationId,
WE.ZoneId,
MIN(CAST(WE.Updated as DATE)) as DateFrom,
ISNULL(MAX(CAST(WE.Updated as DATE)),GETDATE()) as DateTo

 from WarehouseEntry WE with (NOLOCK)
inner join BusinessUnitPermission BUP with (NOLOCK) on WE.ParentHandlingUnitId = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')

--where WE.created > '2021-06-01' 
group by ISNULL(WE.ParentHandlingUnitId,WE.HandlingUnitId),WE.LocationId, WE.ZoneId

) DATA

inner join [Location] L on DATA.LocationId = L.id 
inner join BusinessUnitPermission BUP on L.id = BUP.LocationId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Deufol Hamburg Wallmann-Terminal')
--inner join [Location] L on DATA.LocationId = L.id and L.Code = 'Walmann Terminal'
inner join [Zone] Z on DATA.ZoneId = Z.id
inner join HandlingUnit HU on DATA.HandlingUnitId = HU.Id
INNER JOIN (
select 
D.name, 
DV.Content,
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions on HU.Id = Dimensions.EntityId



where DATA.DateTo between '2021-09-01' and '2021-09-30'

group by 
Dimensions.Project,
Dimensions.[Order],
Dimensions.Commission,
HU.ColliNumber,
HU.Code,
L.Name,
Z.Name



order by [Location],HU.Code, MIN(DATA.DateFrom)


