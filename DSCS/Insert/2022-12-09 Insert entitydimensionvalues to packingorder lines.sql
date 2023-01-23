

BEGIN TRANSACTION


insert into EntityDimensionValueRelation 

select 
NEWID() id
,EDVR.DimensionValueId
,36 as Entity
,POL.Id as EntityId
,POL.CreatedById
,POL.UpdatedById
,POL.Created
,POL.Updated

 from 
PackingOrderLine POL
inner join EntityDimensionValueRelation EDVR on ISNULL(POL.LoosePartId,HandlingUnitId) = EDVR.EntityId
where POL.id not in (select distinct entityid from EntityDimensionValueRelation where entity = 36)

ROLLBACK