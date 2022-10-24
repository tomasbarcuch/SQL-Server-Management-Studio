begin TRANSACTION

insert into WarehouseContent (
    [Id],
	[LocationId],
	[ZoneId],
	[BinId],
	[LoosePartId],
	[HandlingUnitId],
	[ParentHandlingUnitId],
	[BlockMovement],
	[CreatedById],
	[UpdatedById],
	[Created],
	[Updated],
	[QuantityBase]
    )

    

select 
newid(),
	we.LocationId,
	we.ZoneId,
	we.BinId,
	we.LoosePartId,
	we.HandlingUnitId,
	we.[ParentHandlingUnitId],
	0,
	we.[CreatedById],
	we.[UpdatedById],
	we.[Created],
	we.[Updated],
	we.[QuantityBase]  

from WarehouseEntry We

inner join (select lp.id, max(we.created) as created from LoosePart LP
left join WarehouseContent WC on LP.id = WC.LoosePartId
left join WarehouseEntry WE on LP.Id = WE.LoosePartId
where WC.Id is NULL and we.Quantity>0
group by lp.id) data on WE.LoosepartId = data.Id and we.Created = data.created and we.Quantity > 0




ROLLBACK


select * from WarehouseEntry We

inner join (select lp.id, max(we.created) as created from LoosePart LP
left join WarehouseContent WC on LP.id = WC.LoosePartId
left join WarehouseEntry WE on LP.Id = WE.LoosePartId
where WC.Id is NULL and we.Quantity>0
group by lp.id) data on WE.LoosepartId = data.Id and we.Created = data.created and we.Quantity > 0



select * 
from WarehouseEntry We

inner join (select HU.id, max(we.created) as created from HandlingUnit HU
left join WarehouseContent WC on HU.id = WC.HandlingUnitId
left join WarehouseEntry WE on HU.Id = WE.HandlingUnitId
where WC.Id is NULL and we.Quantity>0 and WE.LoosepartId is NULL
group by hu.id) data on WE.HandlingUnitId = data.id and we.Created = data.created and we.Quantity > 0


begin TRANSACTION

insert into WarehouseContent (
    [Id],
	[LocationId],
	[ZoneId],
	[BinId],
	[LoosePartId],
	[HandlingUnitId],
	[ParentHandlingUnitId],
	[BlockMovement],
	[CreatedById],
	[UpdatedById],
	[Created],
	[Updated],
	[QuantityBase]
    )

    

select 
newid(),
	we.LocationId,
	we.ZoneId,
	we.BinId,
	we.LoosePartId,
	we.HandlingUnitId,
	we.[ParentHandlingUnitId],
	0,
	we.[CreatedById],
	we.[UpdatedById],
	we.[Created],
	we.[Updated],
	we.[QuantityBase]  

from WarehouseEntry We

inner join (select HU.id, max(we.Updated) as updated from HandlingUnit HU
left join WarehouseContent WC on HU.id = WC.HandlingUnitId
left join WarehouseEntry WE on HU.Id = WE.HandlingUnitId
where WC.Id is NULL and we.Quantity>0 and WE.LoosepartId is NULL
group by hu.id) data on WE.HandlingUnitId = data.id and we.updated = data.updated and we.Quantity > 0
commit

