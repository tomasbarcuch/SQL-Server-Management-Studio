begin TRANSACTION

update WFE set WFE.BusinessUnitId = DATA.BusinessUnitId
--select WFE.ClientBusinessUnitId, WFE.Created,WFE.EntityId, DATA.*
from WorkflowEntry WFE,

(
select 
WFE.ClientBusinessUnitId
,WFE.BusinessUnitId
,min(WFE.created)  CreatedFirst
,MAX(WFE.created)  CreatedLast
,WFE.EntityId
from WorkflowEntry WFE

where 
WFE.ClientBusinessUnitId is not null and WFE.BusinessUnitId is not null 
and WFE.ClientBusinessUnitId <> WFE.BusinessUnitId
--and EntityId = '1e4e3681-d05d-4045-976a-37081cd9b934'
group by WFE.EntityId, WFE.BusinessUnitiD, WFE.ClientBusinessUnitId

) DATA

where 
WFE.ClientBusinessUnitId is not null and WFE.BusinessUnitId is not null 
and WFE.ClientBusinessUnitId = WFE.BusinessUnitId
and 
((WFE.Created between DATA.CreatedFirst and DATA.CreatedLast) ) and DATA.EntityId = WFE.EntityId


update WFE set WFE.BusinessUnitId = DATA.BusinessUnitId
--select WFE.ClientBusinessUnitId, WFE.Created,WFE.EntityId, DATA.*
from WorkflowEntry WFE,
(
select EntityId, BusinessUnitId from WorkflowEntry where ClusteredId in (
select
--WFE.EntityId, 
MAX(WFE.ClusteredId)  Last
from WorkflowEntry WFE
where 
WFE.ClientBusinessUnitId is not null and WFE.BusinessUnitId is not null 
and WFE.ClientBusinessUnitId <> WFE.BusinessUnitId
--and EntityId = '4d3353b9-4d70-401b-93f2-ea6aa43886e3'
group by  WFE.EntityId
)
) DATA 
where 
WFE.ClientBusinessUnitId is not null and WFE.BusinessUnitId is not null 
and WFE.ClientBusinessUnitId = WFE.BusinessUnitId
and DATA.EntityId = WFE.EntityId
COMMIT