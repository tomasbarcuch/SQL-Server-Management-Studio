BEgin TRANSACTION

update LP set InboundDate = InboundDate.Created

from LoosePart LP
INNER JOIN BusinessUnitPermission BUP on LP.Id = BUP.LoosePartId and BUP.BusinessUnitId = (select id from BusinessUnit WHERE name = 'DEUFOL CUSTOMERS')

LEFT JOIN  (
select
min(WFE.created)  over (PARTITION by WFE.EntityId) as FirstCreated, 
Wfe.Created,
WFE.EntityId

from WorkflowEntry WFE  WITH (NOLOCK)

where WFE.StatusId in (select id from status where name = 'ON_STOCK'
) and WFE.Entity = 15 
) InboundDate on LP.id = InboundDate.EntityId and InboundDate.FirstCreated = InboundDate.Created 




update HU set InboundDate = InboundDate.Created


from HandlingUnit HU
INNER JOIN BusinessUnitPermission BUP on HU.Id = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit WHERE name = 'DEUFOL CUSTOMERS')


LEFT JOIN  (
select
min(WFE.created)  over (PARTITION by WFE.EntityId) as FirstCreated, 
Wfe.Created,
WFE.EntityId

from WorkflowEntry WFE  WITH (NOLOCK)

where WFE.StatusId in (select id from status where name = 'ON_STOCK'
) and WFE.Entity = 11 
) InboundDate on HU.id = InboundDate.EntityId and InboundDate.FirstCreated = InboundDate.Created 




update HU set BoxClosedDate = BoxClosedDate.Created


from HandlingUnit HU
INNER JOIN BusinessUnitPermission BUP on HU.Id = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit WHERE name = 'DEUFOL CUSTOMERS')


LEFT JOIN  (
select
min(WFE.created)  over (PARTITION by WFE.EntityId) as FirstCreated, 
Wfe.Created,
WFE.EntityId

from WorkflowEntry WFE  WITH (NOLOCK)

where WFE.StatusId in (select id from status where name = 'CLOSED'
) and WFE.Entity = 11 
) BoxClosedDate on HU.id = BoxClosedDate.EntityId and BoxClosedDate .FirstCreated = BoxClosedDate.Created 

ROLLBACK