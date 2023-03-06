BEGIN TRANSACTION

insert into EntityDimensionValueRelation

select 
NEWID() Id
,EDVR.DimensionValueId
,48 Entity
,SL.Id EntityId
,EDVR.CreatedById
,EDVR.UpdatedById
,EDVR.Created
,EDVR.Updated

 from ServiceLine SL
 inner join EntityDimensionValueRelation EDVR on SL.EntityId = EDVR.EntityId

WHERE NOT EXISTS(SELECT * FROM [EntityDimensionValueRelation] AS EDVR WHERE ([EDVR].[EntityId] = SL.Id))



ROLLBACK