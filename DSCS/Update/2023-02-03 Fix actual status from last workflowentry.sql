BEGIN TRANSACTION


declare @FIXED_CLIENT as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Air Liquide Group')




PRINT '=== Fix Actual status on Looseparts ===';
update LoosePart set StatusId = data.StatusId from LoosePart
inner join (select 
WFE.entityid,
WFE.Statusid
from WorkflowEntry WFE inner join (
select wfe.EntityId, Max(WFE.created) created from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.StatusId = BUP.StatusId and bup.BusinessUnitId = @FIXED_CLIENT
group by WFE.EntityId) DATA on WFE.entityId = DATA.EntityId and WFE.Created = DATA.Created)
data on LoosePart.id = data.EntityId
where  Loosepart.StatusId <> data.StatusId

PRINT '=== Fix Actual status on HandlingUnits ===';
update HandlingUnit set StatusId = data.StatusId from HandlingUnit
inner join (select 
WFE.entityid,
WFE.Statusid
from WorkflowEntry WFE inner join (
select wfe.EntityId, Max(WFE.created) created from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.StatusId = BUP.StatusId and bup.BusinessUnitId = @FIXED_CLIENT
group by WFE.EntityId) DATA on WFE.entityId = DATA.EntityId and WFE.Created = DATA.Created)
data on HandlingUnit.id = data.EntityId
where  HandlingUnit.StatusId <> data.StatusId

PRINT '=== Fix Actual status on PackingOrder ===';
update PackingOrderHeader set StatusId = data.StatusId from PackingOrderHeader
inner join (select 
WFE.entityid,
WFE.Statusid
from WorkflowEntry WFE inner join (
select wfe.EntityId, Max(WFE.created) created from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.StatusId = BUP.StatusId and bup.BusinessUnitId = @FIXED_CLIENT
group by WFE.EntityId) DATA on WFE.entityId = DATA.EntityId and WFE.Created = DATA.Created)
data on PackingOrderHeader.id = data.EntityId
where  PackingOrderHeader.StatusId <> data.StatusId

PRINT '=== Fix Actual status on ShipmentHeader ===';
update ShipmentHeader set StatusId = data.StatusId from ShipmentHeader
inner join (select 
WFE.entityid,
WFE.Statusid
from WorkflowEntry WFE inner join (
select wfe.EntityId, Max(WFE.created) created from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.StatusId = BUP.StatusId and bup.BusinessUnitId = @FIXED_CLIENT
group by WFE.EntityId) DATA on WFE.entityId = DATA.EntityId and WFE.Created = DATA.Created)
data on ShipmentHeader.id = data.EntityId
where  ShipmentHeader.StatusId <> data.StatusId


PRINT '=== Fix Actual status on ShipmentHeader ===';
update DimensionValue set StatusId = data.StatusId from DimensionValue
inner join (select 
WFE.entityid,
WFE.Statusid
from WorkflowEntry WFE inner join (
select wfe.EntityId, Max(WFE.created) created from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.StatusId = BUP.StatusId and bup.BusinessUnitId = @FIXED_CLIENT
group by WFE.EntityId) DATA on WFE.entityId = DATA.EntityId and WFE.Created = DATA.Created)
data on DimensionValue.id = data.EntityId
where  DimensionValue.StatusId <> data.StatusId

COMMIT

