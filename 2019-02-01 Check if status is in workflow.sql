

select st.*,wfst.*, wfsto.*,s.name from
(select 
lp.statusid 
from loosepart LP
inner join BusinessUnitPermission BUP on lp.id = bup.LoosePartId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Dürr Systems')
group by lp.StatusId) st

left join

(select newstatusid from Workflow wf
inner join BusinessUnitPermission BUP on Wf.id = bup.WorkflowId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Dürr Systems')
group by wf.NewStatusId) wfst on st.statusid = wfst.newstatusid

left join

(select oldstatusid from Workflow wf
inner join BusinessUnitPermission BUP on Wf.id = bup.WorkflowId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Dürr Systems')
group by wf.oldStatusId) wfsto on st.statusid = wfsto.oldstatusid

inner join [Status] S on st.StatusId = S.Id

