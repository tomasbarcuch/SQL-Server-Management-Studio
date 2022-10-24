select
Dimensions.Project,
Dimensions.[Order],
Dimensions.Commission,
HU.ColliNumber,
HU.Code,
L.Name Location,
Z.Name Zone,
B.Code Bin,
DATA.Inbounddate FromDate ,
DATA.OutboundDate Todate
,DATEDIFF(DAY,DATA.Inbounddate,DATA.OutboundDate)+1 'DAYS'
,CASE WHEN (DATEDIFF(DAY,DATA.Inbounddate,DATA.OutboundDate)+1) > 2 and DATA.OutboundDate is not null then 'INVOICE' else '' end as 'Invoice'


from (
select

ISNULL(WE.ParentHandlingUnitId,WE.HandlingUnitId) as HandlingUnitId,
WE.LocationId,
WE.BinId,

 min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then RegisteringDate else null end) as Inbounddate, 
 max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then RegisteringDate else null end) as OutboundDate

 from WarehouseEntry WE with (NOLOCK)
inner join BusinessUnitPermission BUP with (NOLOCK) on WE.ParentHandlingUnitId = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')

group by 
ISNULL(WE.ParentHandlingUnitId,WE.HandlingUnitId),
 WE.BinId,
 WE.LocationId

 --having ISNULL(WE.ParentHandlingUnitId,WE.HandlingUnitId) = '80365220-35cc-49fc-b032-004036b02b7c' 

) DATA

INNER JOIN HandlingUnit HU on DATA.HandlingUnitId = HU.Id
 join [Location] L on DATA.LocationId = L.id 
inner join BusinessUnitPermission BUP on L.id = BUP.LocationId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Deufol Hamburg Wallmann-Terminal')-- $P{KRONES_PACKER}


left join [Bin] B on DATA.BinId = B.id
left join [Zone] Z on B.ZoneId = Z.id

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



where (DATA.Inbounddate between '2022-01-01' and '2022-01-17')  --  $P{FromDate} and  $P{ToDate} 
OR
(DATA.Outbounddate between '2022-01-01' and '2022-01-17')

/*
where 
(DATA.InboundDate between $P{FromDate} and  $P{ToDate}) 
OR
(DATA.OutboundDate between $P{FromDate} and  $P{ToDate}) 
*/

order by [Location],HU.Code, DATA.Inbounddate