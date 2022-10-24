begin TRANSACTION

 insert into [dbo].[BusinessUnitPermission](
	[Id],
	[BusinessUnitId],
	[PermissionType],
	[HandlingUnitId],
	[LoosePartId],
	[ShipmentHeaderId],
	[ShipmentLineId],
	[InventoryHeaderId],
	[InventoryLineId],
	[CommentId],
	[ServiceTypeId],
	[ServiceLineId],
	[LocationId],
	[PackingOrderHeaderId],
	[PackingOrderLineId],
	[AddressId],
	[DimensionId],
	[HandlingUnitTypeId],
	[UnitOfMeasureId],
	[WorkflowId],
	[StatusId],
	[StatusFilterId],
	[BCSActionId],
	[NumberSeriesId],
	[CreatedById],
	[UpdatedById],
	[Created],
	[Updated],
	[DimensionValueId],
	[TenderHeaderId],
	[TenderLineId],
	[DocumentTemplateId]
    )

select

	NEWID() [Id],
	DATA.[BusinessUnitId],
	1 [PermissionType],
	NULL [HandlingUnitId],
	NULL [LoosePartId],
	NULL [ShipmentHeaderId],
	NULL [ShipmentLineId],
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
	DATA.DocumentTemplateId

from
(select 
DTT.Id as DocumentTemplateId,
BUR.BusinessUnitId
from DocumentTemplateTemp DTT
inner join DocumentTemplate DT on DTT.Id = DT.Id
left join DocumentTemplateSubreport SDT on DT.Id = SDT.DocumentTemplateId
inner join BusinessUnitRelation BUR on DTT.BusinessUnitId = BUR.RelatedBusinessUnitId
where DT.disabled = 0
/*UNION
select
DTT.Id as DocumentTemplateId,
DTT.BusinessUnitId
from DocumentTemplateTemp DTT 
inner join DocumentTemplate DT on DTT.Id = DT.Id
left join DocumentTemplateSubreport SDT on DT.Id = SDT.DocumentTemplateId
where DT.disabled = 0*/) DATA 
where BusinessUnitId is not null

ROLLBACK
