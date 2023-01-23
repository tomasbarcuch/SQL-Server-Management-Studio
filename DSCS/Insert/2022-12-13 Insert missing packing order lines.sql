begin TRANSACTION

create TABLE #TEMP 
(
	[Id] [uniqueidentifier] NOT NULL,
	[PackingOrderHeaderId] [uniqueidentifier] NOT NULL,
	[LoosePartId] [uniqueidentifier] NULL,
	[HandlingUnitId] [uniqueidentifier] NULL,
	[CreatedById] [uniqueidentifier] NOT NULL,
	[UpdatedById] [uniqueidentifier] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
	[Status] [tinyint] NOT NULL,
)

insert into #temp


Select
NEWID() Id
,POH.Id PackingOrderHeaderId
,PR.LoosePartId
,NULL HandlingUnitId
,PR.CreatedById
,PR.UpdatedById
,PR.Created
,PR.Updated
,0 as Status
from PackingRule PR


inner join HandlingUnit HU ON PR.ParentHandlingUnitId = HU.id
left join PackingOrderLine POL on PR.LoosePartId = POL.LoosePartId
left join PackingOrderHeader POH on HU.id = POH.HandlingUnitId
left join LoosePart LP on PR.LoosePartId = LP.Id
INNER JOIN BusinessUnitPermission BUP on HU.Id = BUP.HandlingUnitId and BUP.BusinessUnitId = (SELECT Id from BusinessUnit where Name = 'Siemens Duisburg')

where POL.Id IS NULL

insert into PackingOrderLine
SELECT * from #temp

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
	[BusinessUnitId] = (Select id from BusinessUnit where Name = 'Siemens Duisburg'),
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
	#temp.Id [PackingOrderLineId],
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

 from #temp

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
	[BusinessUnitId] = (Select id from BusinessUnit where Name = 'Deufol Mülheim'),
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
	#temp.Id [PackingOrderLineId],
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

 from #temp

drop TABLE #temp

ROLLBACK


select id from BusinessUnit where name = 'Siemens Duisburg'