select 
sh.LoadingDate,
sh.DeliveryDate,
(convert(datetime, SH.LoadingDate) at TIME zone 'Central European Standard Time') as 'CEST',
case when (
left(right((convert(datetime, SH.LoadingDate) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
SH.LoadingDate + right((convert(datetime, SH.LoadingDate) at TIME zone 'Central European Standard Time'),5)
else 
SH.LoadingDate - right((convert(datetime, SH.LoadingDate) at TIME zone 'Central European Standard Time'),5)
end as LoadingDateTime,
case when (
left(right((convert(datetime, SH.DeliveryDate) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
SH.DeliveryDate + right((convert(datetime, SH.DeliveryDate) at TIME zone 'Central European Standard Time'),5)
else 
SH.DeliveryDate - right((convert(datetime, SH.DeliveryDate) at TIME zone 'Central European Standard Time'),5)
end as DeliveryDateTime

 from ShipmentLine SL
 inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id
 inner join BusinessUnitPermission BUP on SL.id = BUP.ShipmentLineId
 left join HandlingUnit HU on SL.HandlingUnitId = HU.Id
 left join LoosePart LP on SL.LoosePartId = LP.id
 
 where BUP.BusinessUnitId = (select ID from BusinessUnit where name = 'Deufol Berlin')

