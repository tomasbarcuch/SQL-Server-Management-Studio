select 
BU.name as Client,
Entity.code EntityCode,
sum(data.inbound_quantity) inb_quantity, 
sum(data.outbound_quantity) out_quantity, 
sum(data.Out_Surface) out_surface,
sum(data.Inb_Surface) inb_surface,
L.code Location, 
DATA.Entity,
sum(data.Surface) as surface,
month(data.date) as month,
year(data.date) as year


 from 
(

select
case WHEN WE.QuantityBase > 0 and we.LocationId is not null then 1 else 0 end as Inbound_quantity, 
 case WHEN WE.QuantityBase < 0 and we.LocationId is not null then 1 else 0 end as Outbound_quantity, 
WE.LocationId,
'LP' as Entity,
LP.code,
WE.LoosepartId as EntityID,
BUP.BusinessUnitId,
lp.BaseArea as BaseArea,
lp.Surface as Surface ,
case WHEN WE.QuantityBase > 0 and we.LocationId is not null then lp.Surface else 0 end as Inb_Surface,  
case WHEN WE.QuantityBase < 0 and we.LocationId is not null then (lp.Surface) else 0 end as Out_Surface,

 WE.RegisteringDate as Date
 from WarehouseEntry WE with (NOLOCK)
inner join LoosePart LP on WE.LoosepartId = LP.Id and we.HandlingUnitId is null and we.ParentHandlingUnitId is null 
inner join BusinessUnitPermission BUP on LP.Id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.type = 2
 Where we.LocationId is not null  
 and WE.LoosepartId = WE.LoosePartId and WE.LoosePartId is not null

union

select
case WHEN WE.QuantityBase > 0 and we.LocationId is not null then 1 else 0 end as Inbound_quantity, 
 case WHEN WE.QuantityBase < 0 and we.LocationId is not null then 1 else 0 end as Outbound_quantity, 
WE.LocationId,
'HU' as Entity,
HU.code,
WE.HandlingUnitId as EntityID,
BUP.BusinessUnitId,
HU.BaseArea as BaseArea, 
HU.Surface as Surface,
case WHEN WE.QuantityBase > 0 and we.LocationId is not null then (HU.Surface) else 0 end as Inb_Surface,
case WHEN WE.QuantityBase < 0 and we.LocationId is not null then (HU.Surface) else 0 end as Out_Surface,  

 WE.RegisteringDate as Date
 from WarehouseEntry WE with (NOLOCK)
 inner join HandlingUnit HU on WE.HandlingUnitId = HU.id and we.ParentHandlingUnitId is null and we.LoosepartId is null
 Inner join BusinessUnitPermission BUP on HU.Id = BUP.HandlingUnitId
 inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.type = 2
 

 Where we.LocationId is not null  
 and WE.HandlingUnitId = WE.HandlingUnitId and WE.HandlingUnitId is not null
 
) DATA
inner join [Location] L on DATA.LocationId = L.Id and L.id = (select id from [Location] where code = 'Deufol Rosshafen')
inner join BusinessUnit BU on DATA.BusinessUnitId = BU.id and BU.type = 2
left join (select ID,CODE from LoosePart union select ID,Code from HandlingUnit) Entity on DATA.EntityID = Entity.id
 

 where 
 year(data.date) in (2018,2019) 
 
 --and Entity.Code in ('HU030-000687','HU030-000729','2801917000006000')

 group by 
Entity.code,
 BU.name,
L.code, 
DATA.Entity,
month(data.date),
year(data.date)
 
 
 