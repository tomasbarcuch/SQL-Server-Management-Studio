select * from (
select
(case when (
left(right((convert(datetime, WE.Created) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
WE.Created + right((convert(datetime, WE.Created) at TIME zone 'Central European Standard Time'),5)
else 
WE.Created - right((convert(datetime, WE.Created) at TIME zone 'Central European Standard Time'),5)
end) as inbend,
case when we.Quantity < 0 then 'end' else
case when we.quantity > 0 then 'start' end end as typ,
isnull(WE.LoosepartId,WE.HandlingUnitId) as EntityId
from WarehouseEntry WE
inner join bin B on WE.BinId = B.Id
where

b.Code = 'Wareneingang' 
and we.quantity < 0


) inb

where inb.EntityId = (select id from loosepart where code = '0000037077/000201')
