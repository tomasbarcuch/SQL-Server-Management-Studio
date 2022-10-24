BEGIN TRANSACTION
declare @documentid as UNIQUEIDENTIFIER = (select id from DocumentTemplate where name = 'DST-0012')
declare @packerid as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')
--declare @clientid as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'KRONES GLOBAL')

insert into BusinessUnitPermission

select 
 NEWID() [Id],
	BUR.BusinessUnitId as [BusinessUnitId],
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


 from BusinessUnitRelation BUR
left join BusinessUnitPermission BUP on BUR.BusinessUnitId = BUP.BusinessUnitId and BUP.DocumentTemplateId = @documentid
left join BusinessUnit BU on BUR.BusinessUnitId = BU.Id and BU.[Disabled] = 0
where BUR.RelatedBusinessUnitId = @packerid 
--and BUR.BusinessUnitId <> @clientid
and BUP.BusinessUnitId is null and BUP.DocumentTemplateId is null
and BUR.BusinessUnitId not in (select BusinessUnitId from BusinessUnitPermission where DocumentTemplateId = @documentid)

COMMIT
/*
select DT.name,BU.name
from BusinessUnitRelation BUR
left join BusinessUnitPermission BUP on BUR.BusinessUnitId = BUP.BusinessUnitId --and BUP.DocumentTemplateId = @documentid
left join BusinessUnit BU on BUR.BusinessUnitId = BU.Id and BU.[Disabled] = 0
inner join DocumentTemplate DT on BUP.DocumentTemplateId = DT.id
where RelatedBusinessUnitId = (select id from BusinessUnit where name = 'Deufol Nürnberg')
AND DT.[Disabled] = 0

--group by DT.NAME
*/