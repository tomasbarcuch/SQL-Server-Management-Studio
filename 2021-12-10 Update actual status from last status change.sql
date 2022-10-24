begin TRANSACTION
update LoosePart set StatusId = data.StatusId from LoosePart inner join 
(select 
WFE.entityid,
WFE.Statusid
from WorkflowEntry WFE inner join (
select wfe.EntityId, Max(WFE.created) created from WorkflowEntry WFE where entity = 15
--inner join BusinessUnitPermission BUP on WFE.StatusId = BUP.StatusId and bup.BusinessUnitId = @FIXED_CLIENT
group by WFE.EntityId ) DATA on WFE.entityId = DATA.EntityId and WFE.Created = DATA.Created)
data on LoosePart.id = data.EntityId where Loosepart.StatusId <> data.StatusId

ROLLBACK

