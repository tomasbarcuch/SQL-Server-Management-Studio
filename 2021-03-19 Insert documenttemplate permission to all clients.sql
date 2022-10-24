BEGIN TRANSACTION
declare @documentid as UNIQUEIDENTIFIER = (select id from DocumentTemplate where name = 'REP-0070')
--declare @packerid as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')
--declare @clientid as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'KRONES GLOBAL')

--insert into BusinessUnitPermission

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


 from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
inner join DocumentTemplate DT on BUP.DocumentTemplateId = DT.Id

where BUP.DocumentTemplateId in
(select id from documenttemplate where 
name in ( 
'REP-0197'
 )) 


and BU.Id not in (select BusinessUnitId from BusinessUnitPermission where DocumentTemplateId = @documentid)

COMMIT