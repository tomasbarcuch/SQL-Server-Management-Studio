select
LP.ID lpId,
LP.StatusId,
max(WFE.Created) StatusChanged
 
from 
dbo.loosepart LP

inner join dbo.workflowentry WFE on LP.id = WFE.entityid and LP.Statusid = WFE.StatusID

group by 
LP.ID,
LP.StatusId

select * from
(select entityid, created as Packed from WorkflowEntry WFE inner join (
select S.id STATUSID
from BusinessUnitPermission BUP
inner join [Status] S on BUP.StatusId = S.id and S.name = 'HuPacked'
where BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin' )) STAT on WFE.StatusId = STAT.STATUSID) PACKED
