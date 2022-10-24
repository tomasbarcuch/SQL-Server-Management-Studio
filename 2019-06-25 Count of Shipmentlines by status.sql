select
ShipmentHeader.code,
ShipmentHeader.[Type], 
'none '+ cast (sum(case when status = 0 then 1 else 0 end) as varchar) + ' from ' + cast(count(shipmentline.id) as varchar) Lines, 
'loaded '+ cast (sum(case when status = 1 then 1 else 0 end) as varchar) + ' from ' + cast(count(shipmentline.id) as varchar) Lines, 
'unloaded '+ cast (sum(case when status = 2 then 1 else 0 end) as varchar) + ' from ' + cast(count(shipmentline.id) as varchar) Lines 
from ShipmentLine 
inner join ShipmentHeader on ShipmentLine.ShipmentHeaderId = ShipmentHeader.id
--where ShipmentHeaderId = '21a3c7ca-ecaf-4519-8959-db533f8f5927'
group by ShipmentLine.[Status], ShipmentHeader.Code,ShipmentHeader.[Type]
order by ShipmentHeader.code