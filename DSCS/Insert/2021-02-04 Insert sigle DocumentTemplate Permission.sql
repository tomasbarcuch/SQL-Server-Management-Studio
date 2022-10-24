BEGIN TRANSACTION
declare @documentid as UNIQUEIDENTIFIER = '4d17b15f-190c-4df4-bbe8-3b53e84be9df'
--declare @packerid as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Nürnberg')
declare @clientid as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'BHS')

insert into BusinessUnitPermission

select 
 NEWID() [Id],
	BU.Id as [BusinessUnitId],
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
@documentid [DocumentTemplateId] 
--from BusinessUnit BU where BU.id in (@packerid,@clientid)
--from BusinessUnit BU where BU.id = @packerid
from BusinessUnit BU where BU.id = @clientid
--from BusinessUnitRelation BUR 
and BU.id not in (select BusinessUnitId from BusinessUnitPermission where DocumentTemplateId = @documentid)

ROLLBACK