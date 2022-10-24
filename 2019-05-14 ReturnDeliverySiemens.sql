
select * from (
select 
WorkflowEntry.EntityId,
max(Berlin.Created) 'Rücklieferung Start', 
min(WorkflowEntry.created) 'Rücklieferung Ende'
from WorkflowEntry 
inner join (
select
ST.Id sidsiemens, 
sidberlin = (
    select status.id from Status 
    inner join BusinessUnitPermission BUP on Status.id = BUP.StatusId
    where name = left(ST.name,len(ST.name)-7) and bup.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2'),
WF.EntityId, WF.Created from workflowentry WF 
inner join [Status] ST on StatusId = ST.Id
where wf.StatusId in (select S.id from Status S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId
where s.name in
('LpInboundSiemens',
'LpToBePaintedSIEMENS',
'LpPaintedSiemens'
) and bup.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2') 
--and WF.entityid = (select id from LoosePart where code = '0000037076/000210')
and WF.entityid = (select id from LoosePart where code = '0000036092/000206')
) Berlin on WorkflowEntry.EntityId = Berlin.EntityId and WorkflowEntry.StatusId = sidberlin and Berlin.Created < WorkflowEntry.Created

group by workflowentry.EntityID, WorkflowEntry.id) p unpivot (Rücklieferdatum for [Status explanation] in ([Rücklieferung Start],[Rücklieferung Ende])) unpvt