begin TRANSACTION

--update ShipmentHeader set UnloadingShipmentHeaderId = UL.UnloadingShipmentHeaderId

select SH.Id, UL.UnloadingShipmentHeaderId 
from ShipmentLine SL 
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.id
inner join BusinessUnitPermission BUP on SL.id = BUP.ShipmentLineId
inner join (
select SH.Code, SH.Id UnloadingShipmentHeaderId, BUP.BusinessUnitId from ShipmentLine SL 
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.id
inner join BusinessUnitPermission BUP on SL.id = BUP.ShipmentLineId
where SH.[Type] = 1
 ) UL on SH.Code = UL.Code and BUP.BusinessUnitId = UL.BusinessUnitId
 inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.[Type] = 2 


where SH.type = 0 and SH.UnloadingShipmentHeaderId is NULL
and SL.[Status] =1
--group by SH.Id, UL.UnloadingShipmentHeaderId

ROLLBACK



/*
select * from 
ShipmentHeader SH
inner join ShipmentLine Sl on SH.id = SL.ShipmentHeaderId
 where code = 'COHH09+COHH10+COHH13'

 select * from ShipmentLine where ShipmentHeaderId = '5e7255cb-880e-475c-ba38-1af45c7e887a'
 */