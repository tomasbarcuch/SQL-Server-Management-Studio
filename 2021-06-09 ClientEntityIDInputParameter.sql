Select EntityId,Entity from (select
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
[DimensionValueId],
[TenderHeaderId],
[TenderLineId],
[DocumentTemplateId]
 
from BusinessUnitPermission with (NOLOCK)
where BusinessUnitId = (select id from BusinessUnit with (NOLOCK) where name = 'KRONES GLOBAL')
) EntityId  UNPIVOT (EntityId for [Entity] in (
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
[DimensionValueId],
[TenderHeaderId],
[TenderLineId],
[DocumentTemplateId]
)) unpvt

/*
INTERSECT

Select EntityId,Entity from (select *
from BusinessUnitPermission with (NOLOCK)
where BusinessUnitId = (select id from BusinessUnit with (NOLOCK) where name = 'Deufol Neutraubling')
) EntityId  UNPIVOT (EntityId for [Entity] in ([HandlingUnitId],
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
[DimensionValueId],
[TenderHeaderId],
[TenderLineId],
[DocumentTemplateId]
)) unpvt
*/

