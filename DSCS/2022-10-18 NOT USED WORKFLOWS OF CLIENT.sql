DECLARE @client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')

select CASE WHEN WFUSED.Entity IS NULL then 'NOT USED' ELSE 'USED' END as USED,
 CASE WF.Entity
 WHEN 10 Then 'Dimension'
 WHEN 11 Then 'Handling Unit'
 WHEN 15 Then 'Loosepart'
 WHEN 31 Then 'Shipment'
 WHEN 35 Then 'Packing Order'
 WHEN 48 Then 'Service line'
 end as Entity, 
 WF.Id, 
 OS.Name OldStatus, 
 NS.Name NewStatus from Workflow WF
inner join BusinessUnitPermission BUP on WF.id = BUP.WorkflowId and BUP.BusinessUnitId = @client
INNER JOIN [Status] OS on WF.OldStatusId = OS.Id
INNER JOIN [Status] NS on WF.NewStatusId = NS.Id

LEFT join (

select  distinct
LAG(WFE.StatusId) over (order by entityid, created)as OldStatusId
,WFE.StatusId as NewStatusID
, WFE.Entity
from WorkflowEntry WFE
where WFE.ClientBusinessUnitId = @client


) WFUSED on WF.OldStatusId = WFUSED.OldStatusId and WF.NewStatusId = WFUSED.NewStatusID and WF.Entity = WFUSED.Entity

order by WF.ENTITY