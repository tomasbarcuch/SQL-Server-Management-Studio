select SH.*,SL.* 
from shipmentline SL
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id
where UnloadingShipmentHeaderId is not NULL
and SL.[Status] not in (1,2)


select SL.id from ShipmentLine SL
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id
where ShipmentHeaderId in (select id from ShipmentHeader where code = 'MJQ927/3692-M')
and SH.[Type] = 1 and [Status] = 1




begin TRANSACTION
--insert into ShipmentLine --(ID,ShipmentHeaderId,[LineNo],[Status],[Type],HandlingUnitId,LoosePartId,UnitOfMeasureId,Quantity,CreatedById,U)
select
NEWID() Id,
USH.Id ShipmentHeaderId,
LSL.[LineNo],
1 [Status],
LSL.[Type],
LSL.HandlingUnitId,
LSL.LoosePartId,
LSL.UnitOfMeasureId,
LSL.Quantity,
LSL.CreatedById,
LSL.UpdatedById,
LSL.Created,
LSL.Updated

 from ShipmentLine LSL
inner join ShipmentHeader LSH on LSL.ShipmentHeaderId = LSH.Id
INNER join ShipmentHeader USH on LSH.UnloadingShipmentHeaderId = USH.Id
LEFT JOIN ShipmentLine USL on USH.id = USL.ShipmentHeaderId and (USL.LoosePartId = LSL.LoosePartId or USL.HandlingUnitId = LSL.HandlingUnitId)
where 
LSH.Code = 'RBT4050/3360-M'  
and LSL.[Status] = 0 
--and USL.ID is NULL
ROLLBACK

--select * from ShipmentLine where ShipmentHeaderId in (Select id from ShipmentHeader where code = 'Rs257-3206M')

begin TRANSACTION
--insert into BusinessUnitPermission

select --TOP(1)

 NEWID() [Id],
	(SELECT ID FROM BusinessUnit where name = 'Deufol Neutraubling') as [BusinessUnitId],
	1 [PermissionType],
	NULL [HandlingUnitId],
	NULL [LoosePartId],
	NULL [ShipmentHeaderId],
	SL.[Id] [ShipmentLineId],
	NULL [InventoryHeaderId],
	NULL [InventoryLineId],
	NULL [CommentId],
	NULL [ServiceTypeId],
	NULL [ServiceLineId],
	NULL [LocationId],
	NULL [PackingOrderHeaderId],
	NULL [PackingOrderLineId],
	NULL [AddressId],
	NULL [DimensionId],
	NULL [HandlingUnitTypeId],
	NULL [UnitOfMeasureId],
	NULL [WorkflowId],
	NULL [StatusId],
	NULL [StatusFilterId],
	NULL [BCSActionId],
	NULL [NumberSeriesId],
	[CreatedById] = (select id from [User] where login = 'tomas.barcuch'),
	[UpdatedById] = (select id from [User] where login = 'tomas.barcuch'),
	GETUTCDATE() [Created],
	GETUTCDATE() [Updated],
	NULL [DimensionValueId],
	NULL [TenderHeaderId],
	NULL [TenderLineId],
NULL [DocumentTemplateId] 


 from ShipmentLine SL
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id
left join BusinessUnitPermission BUP on SL.id = BUP.ShipmentLineId
where SL.ShipmentHeaderId in (select id from ShipmentHeader where code = 'RBT4050/3360-M')
and SH.[Type] = 1 and [Status] = 1
 
 --and BUP.ShipmentLineId is null --and BUP.BusinessUnitId is null


COMMIT

