begin TRANSACTION

delete from BusinessUnitPermission where id in (
select min(Id)--,count(ID), BusinessUnitId, DocumentTemplateId 
from BusinessUnitPermission
where DocumentTemplateId is not NULL
group by BusinessUnitId, DocumentTemplateId
having count(ID) > 1
)
delete from BusinessUnitPermission where id = (
select min(Id)--, count(ID), BusinessUnitId, LoosepartId 
from BusinessUnitPermission
where LoosepartId is not NULL
group by BusinessUnitId, LoosepartId
having count(ID) > 1
)

/*
select min(Id), count(ID), BusinessUnitId, HandlingUnitId
from BusinessUnitPermission
where HandlingUnitId is not NULL
group by BusinessUnitId, HandlingUnitId
having count(ID) > 1


select min(Id), count(ID), BusinessUnitId, PackingOrderHeaderId
from BusinessUnitPermission
where PackingOrderHeaderId is not NULL
group by BusinessUnitId, PackingOrderHeaderId
having count(ID) > 1
*/

delete from BusinessUnitPermission where id = (
select min(Id)--, count(ID), BusinessUnitId, ShipmentHeaderId
from BusinessUnitPermission
where ShipmentHeaderId is not NULL
group by BusinessUnitId, ShipmentHeaderId
having count(ID) > 1
)

delete from BusinessUnitPermission where id in (
select min(Id)--, count(ID), BusinessUnitId, ShipmentLineId
from BusinessUnitPermission
where ShipmentLineId is not NULL
group by BusinessUnitId, ShipmentLineId
having count(ID) > 1
)



delete  from BusinessUnitPermission where id in (
select min(Id)--, count(ID), BusinessUnitId, LocationId
from BusinessUnitPermission
where LocationId is not NULL
group by BusinessUnitId, LocationId
having count(ID) > 1
)

ROLLBACK