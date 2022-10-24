
 INSERT INTO BusinessUnitPermission(
	`Id`,
	`BusinessUnitId`,
	`PermissionType`,
	`HandlingUnitId`,
	`LoosePartId`,
	`ShipmentHeaderId`,
	`ShipmentLineId`,
	`InventoryHeaderId`,
	`InventoryLineId`,
	`CommentId`,
	`ServiceTypeId`,
	`ServiceLineId`,
	`LocationId`,
	`PackingOrderHeaderId`,
	`PackingOrderLineId`,
	`AddressId`,
	`DimensionId`,
	`HandlingUnitTypeId`,
	`UnitOfMeasureId`,
	`WorkflowId`,
	`StatusId`,
	`StatusFilterId`,
	`BCSActionId`,
	`NumberSeriesId`,
	`CreatedById`,
	`UpdatedById`,
	`Created`,
	`Updated`,
	`DimensionValueId`,
	`TenderHeaderId`,
	`TenderLineId`,
	`DocumentTemplateId`
    )


select
uuid(),
DATA.BusinessUnitId,
	1 PermissionType,
	null HandlingUnitId,
	null LoosePartId,
	null ShipmentHeaderId,
	null ShipmentLineId,
	null InventoryHeaderId,
	null InventoryLineId,
	null CommentId,
	null ServiceTypeId,
	null ServiceLineId,
	null LocationId,
	null PackingOrderHeaderId,
	null PackingOrderLineId,
	null AddressId,
	null DimensionId,
	null HandlingUnitTypeId,
	null UnitOfMeasureId,
	null WorkflowId,
	null StatusId,
	null StatusFilterId,
	null BCSActionId,
	null NumberSeriesId,
 (select id from User where login = 'tomas.barcuch'),
 (select id from User where login = 'tomas.barcuch'),
	UTC_TIMESTAMP(3) Created,
	UTC_TIMESTAMP(3) Updated,
	null DimensionValueId,
	null TenderHeaderId,
	null TenderLineId,
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
UNION
select
DTT.Id as DocumentTemplateId,
DTT.BusinessUnitId
from DocumentTemplateTemp DTT 
inner join DocumentTemplate DT on DTT.Id = DT.Id
left join DocumentTemplateSubreport SDT on DT.Id = SDT.DocumentTemplateId
where DT.disabled = 0) DATA 
where BusinessUnitId is not null