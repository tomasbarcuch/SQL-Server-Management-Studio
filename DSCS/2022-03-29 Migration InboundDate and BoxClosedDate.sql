BEgin TRANSACTION

update HU set BoxClosedDate = BoxClosedDate.Created
--select BoxClosedDate.Created, HU.Id, BUP.BusinessUnitId, BoxClosedDate.Name

from HandlingUnit HU
INNER JOIN BusinessUnitPermission BUP on HU.Id = BUP.HandlingUnitId 

INNER JOIN  (
select
min(WFE.created)  over (PARTITION by WFE.EntityId,BUP.BusinessUnitId) as FirstCreated, 
Wfe.Created,
WFE.EntityId,
BU.Name

from WorkflowEntry WFE  WITH (NOLOCK)
INNER JOIN BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId
INNER JOIN BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Type = 2 and BU.[Disabled] = 0

where WFE.StatusId in (select id from status where name in (
    'Closed',
    'BOX_CLOSED',
    'HuBox closed',
    'HuBoxClosed',
    'HuClosed',
    'HuContainerZu',
    'HuContainer closed',
    'HuPacked',
    'Packed'
    )
) and WFE.Entity = 11 
) BoxClosedDate on HU.id = BoxClosedDate.EntityId and BoxClosedDate.FirstCreated = BoxClosedDate.Created 

where HU.BoxClosedDate is NULL



COMMIT



BEGIN TRANSACTION

update HU set InboundDate = BoxInboundDate.Created
--select BoxInboundDate.Created, HU.Id, BUP.BusinessUnitId, BoxInboundDate.Name

from HandlingUnit HU
INNER JOIN BusinessUnitPermission BUP on HU.Id = BUP.HandlingUnitId 


INNER JOIN  (
select
min(WFE.created)  over (PARTITION by WFE.EntityId,BUP.BusinessUnitId) as FirstCreated, 
Wfe.Created,
WFE.EntityId,
BU.Name

from WorkflowEntry WFE  WITH (NOLOCK)
INNER JOIN BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId
INNER JOIN BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Type = 2 and BU.[Disabled] = 0

where WFE.WorkflowAction = 1  and WFE.Entity = 11 
) BoxInboundDate on HU.id = BoxInboundDate.EntityId and BoxInboundDate.FirstCreated = BoxInboundDate.Created 

where HU.InboundDate is NULL



COMMIT


BEGIN TRANSACTION

update LP set InboundDate = PartInboundDate.Created
--select PartInboundDate.Created, LP.Id, BUP.BusinessUnitId, PartInboundDate.Name

from LoosePart LP
INNER JOIN BusinessUnitPermission BUP on LP.Id = BUP.LoosePartId 

INNER JOIN  (
select
min(WFE.created)  over (PARTITION by WFE.EntityId,BUP.BusinessUnitId) as FirstCreated, 
Wfe.Created,
WFE.EntityId,
BU.Name

from WorkflowEntry WFE  WITH (NOLOCK)
INNER JOIN BusinessUnitPermission BUP on WFE.EntityId = BUP.LoosePartId
INNER JOIN BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Type = 2 and BU.[Disabled] = 0

where WFE.WorkflowAction = 1  and WFE.Entity = 15 
) PartInboundDate on LP.id = PartInboundDate.EntityId and PartInboundDate.FirstCreated = PartInboundDate.Created 

where LP.InboundDate is NULL
COMMIT

