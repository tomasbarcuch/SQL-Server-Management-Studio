



select WFE.Created as Verpackung, BU.Name Verpackungsort from (
select * from (
select 
max(WFE.created)  over (PARTITION by WFE.EntityId) as Created, 
WFE.EntityId,
WFE.BusinessUnitId
--WFS.Name as Status 
from WorkflowEntry WFE 
--INNER JOIN [Status] WFS ON WFE.StatusId = WFS.Id and WFS.Name in ('HuBox closed','BOX_CLOSED') and WFE.Entity = 11
where wfe.WorkflowAction = 8 and WFE.BusinessUnitId in (select id from BusinessUnit where Name = 'Deufol Hamburg Rosshafen')

) data

group by EntityId, data.created, BusinessUnitId) WFE
left join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
