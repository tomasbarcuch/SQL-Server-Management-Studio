select 
data.EntityCode,
data.Inbounddate,
data.OutboundDate,
data.Code,
data.Entity,
DATEDIFF(day,data.Inbounddate,data.OutboundDate) as 'DAYS',
cf.name,
cv.Content
from (
select

B.code,
isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId) as EntityID,
(isnull(isnull(lp.Code,HU.code),PHU.code)) as EntityCode,
case when lp.Code is null then 11 else 15 end as Entity,
isnull(isnull(BUPlp.BusinessUnitId,BUPphu.BusinessUnitId),BUPphu.BusinessUnitId ) as 'ClientBusinessUnitId',
min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then RegisteringDate else null end) as Inbounddate,
isnull(max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then RegisteringDate else null end), getdate()) as OutboundDate
from WarehouseEntry WE
left join businessunitpermission BUPlp on WE.loosepartid = BUPlp.LoosepartId
left join LoosePart LP on BUPlp.LoosepartId = LP.Id and we.HandlingUnitId is null
left join businessunitpermission BUPhu on WE.HandlingUnitId = BUPhu.HandlingUnitId
left join HandlingUnit HU on BUPhu.HandlingUnitId = HU.id and we.ParentHandlingUnitId is null
left join businessunitpermission BUPphu on WE.ParentHandlingUnitId = BUPphu.HandlingUnitId
left join HandlingUnit PHU on BUPphu.HandlingUnitId = PHU.id
left join bin B on we.binid = B.Id
   Where b.Code like '% SP'
    group by 
 case when lp.Code is null then 11 else 15 end,  
B.code,
isnull(isnull(BUPlp.BusinessUnitId,BUPphu.BusinessUnitId),BUPphu.BusinessUnitId ),
isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId),
(isnull(isnull(lp.Code,HU.Code),PHU.Code))) DATA

inner join CustomField CF on data.ClientBusinessUnitId = CF.ClientBusinessUnitId and cf.Name = 'Sperrlager Gründe' 
left join CustomValue CV on data.EntityID = cv.EntityId and cv.CustomFieldId = cf.Id and cf.Entity = data.Entity and cv.Content is not null
