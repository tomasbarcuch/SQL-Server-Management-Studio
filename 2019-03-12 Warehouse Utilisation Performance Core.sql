select 
--BU.name,

sum(data.inbound_quantity) inb_quantity, 
sum(data.outbound_quantity) out_quantity, 
sum(data.Out_Surface) out_surface,
sum(data.Inb_Surface) inb_surface,
L.code, 
DATA.Entity,
sum(data.Surface) as surface,
month(data.date) as month,
year(data.date) as year


 from 
(
select
 max(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then 1 else 0 end) as Inbound_quantity, 
 max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then 1 else 0 end) as Outbound_quantity, 
WE.LocationId,
case when LP.Code is null then 'HU' else 'LP' end as Entity,
--isnull(LP.Code, 'HU') Entity,
isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId) as EntityID,
isnull(isnull(BUPLP.BusinessUnitId,BUPHU.BusinessUnitId),BUPPHU.BusinessUnitId) as BusinessUnitId,  
sum(isnull(isnull(lp.BaseArea,HU.BaseArea),PHU.BaseArea)) as BaseArea, 
sum(isnull(isnull(lp.Surface,HU.Surface),PHU.Surface)) as Surface,
sum(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then (isnull(isnull(lp.Surface,HU.Surface),PHU.Surface)) else 0 end) as Inb_Surface,  
sum(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then (isnull(isnull(lp.Surface,HU.Surface),PHU.Surface)) else 0 end) as Out_Surface,  
 --min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then RegisteringDate else null end) as Inbounddate, 
 --max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then RegisteringDate else null end) as OutboundDate,
 WE.RegisteringDate as Date
 from WarehouseEntry WE 
 left outer join LoosePart LP on WE.LoosepartId = LP.Id and we.HandlingUnitId is null 
 left outer join HandlingUnit HU on WE.HandlingUnitId = HU.id and we.ParentHandlingUnitId is null 
 left outer join HandlingUnit PHU on WE.ParentHandlingUnitId = PHU.id
 left outer join BusinessUnitPermission BUPLP on LP.Id = BUPLP.LoosePartId
 left outer join BusinessUnitPermission BUPHU on HU.Id = BUPHU.HandlingUnitId
 left outer join BusinessUnitPermission BUPPHU on PHU.Id = BUPPHU.HandlingUnitId

 Where we.LocationId is not null  
 and (((WE.LoosepartId = WE.LoosePartId and WE.LoosePartId is not null) or  
 (WE.HandlingUnitId = WE.HandlingUnitId and WE.HandlingUnitId is not null) or 
 (WE.HandlingUnitId = WE.ParentHandlingUnitId and WE.ParentHandlingUnitId is not null))) 

 
 
 group by 
case when LP.Code is null then 'HU' else 'LP' end,  WE.RegisteringDate,
 WE.LocationId, 
isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId),
isnull(isnull(BUPLP.BusinessUnitId,BUPHU.BusinessUnitId),BUPPHU.BusinessUnitId) 
) DATA
inner join [Location] L on DATA.LocationId = L.Id and L.id = (select id from [Location] where code = 'Deufol Rosshafen')
inner join BusinessUnit BU on DATA.BusinessUnitId = BU.id and BU.type = 2
 

 where 
 year(data.date) in (2021) 
 
 

 group by 

 --BU.name,
L.code, 
DATA.Entity,
month(data.date),
year(data.date)