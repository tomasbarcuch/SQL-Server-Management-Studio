SELECT


s_old.Name old_status,
s_new.Name new_status,
--isnull(t_old.Text,s_old.name) olds,
--isnull(t_new.text,s_new.name) news,
case w.Action
when 0 then 'none'
when 1 then 'Inbound'
when 2 then 'Outbound'
when 3 then'Transfer'
when 4 then 'Movement'
when 5 then 'Packing'
when 6 then 'Unpacking'
when 7 then 'Loading'
when 8 then 'Packing In'
when 9 then 'Unpacking From'
when 10 then 'Unloading'
when 11 then 'Loading To'
when 12 then 'UnloadingFrom'
when 13 then 'Loaded All'
when 14 then 'Unloaded All'
when 15 then 'Inventory'
when 16 then 'Printing'
when 17 then 'Change Status'
when 21 then 'Assigned'
when 22 then 'Packed All'
when 23 then 'Unpacking from'
when 24 then 'Assign Value'
when 25 then 'ShowContainerVisualModel'
when 26 then 'AssignDevice'
when 27 then 'UploadToDMS'
when 28 then 'ChangeClient'
when 29 then 'AddShipmentLine'
when 30 then 'DeleteShipmentLine'
when 31 then 'FirstShipmentLineAdded'
when 32 then 'LastShipmentLineDeleted'
else 'X' end as 'action name',
Case SF.[Action]
when 0 then 'none'
when 1 then 'Inbound'
when 2 then 'Outbound'
when 3 then'Transfer'
when 4 then 'Movement'
when 5 then 'Packing'
when 6 then 'Unpacking'
when 7 then 'Loading'
when 8 then 'Packing In'
when 9 then 'Unpacking From'
when 10 then 'Unloading'
when 11 then 'Loading To'
when 12 then 'UnloadingFrom'
when 13 then 'Loaded All'
when 14 then 'Unloaded All'
when 15 then 'Inventory'
when 16 then 'Printing'
when 17 then 'Change Status'
when 21 then 'Assigned'
when 22 then 'Packed All'
when 23 then 'Unpacking from'
when 24 then 'Assign Value'
when 25 then 'ShowContainerVisualModel'
when 26 then 'AssignDevice'
when 27 then 'UploadToDMS'
when 28 then 'ChangeClient'
when 29 then 'AddShipmentLine'
when 30 then 'DeleteShipmentLine'
when 31 then 'FirstShipmentLineAdded'
when 32 then 'LastShipmentLineDeleted'
else 'X' end as 'status filter action'
FROM [dbo].[Workflow] w
  inner join BusinessUnitPermission BUP on W.id = BUP.WorkflowId
  inner join dbo.businessunit bu on BUP.BusinessUnitId = bu.id
 left join dbo.status s_old on w.oldstatusid = s_old.id
  inner join dbo.status s_new on w.newstatusid = s_new.id
   left join Translation t_new on s_new.Id = t_new.EntityId and t_new.[Language] = 'de'
left join Translation t_old on s_old.Id = t_old.EntityId and t_old.[Language] = 'de'
left join StatusFilter SF on W.OldStatusId = SF.StatusId and W.[Action] = SF.[Action]
where bu.name = 'KRONES GLOBAL'
and w. entity = 11
order by 
s_new.ClusteredId

begin TRANSACTION
--insert into StatusFilter
select 
--NEWID(),WF.[Action],WF.OldStatusId as StatusId,WF.Entity,WF.DimensionId,CreatedById = (select id from [User] where login = 'tomas.barcuch'),UpdateById = (select id from [User] where login = 'tomas.barcuch'),Getdate() as Created,Getdate() as Updated
BU.Name, s_old.Name, WF.OldStatusId, WF.[Action], SF.[Action], WF.Entity, WF.DimensionId 
from Workflow WF 
left join StatusFilter SF on WF.OldStatusId = SF.StatusId and WF.[Action] = SF.[Action]
inner join BusinessUnitPermission BUP on WF.id = BUP.WorkflowId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Disabled] = 0 and BU.NAME = 'BASIS CLIENT'
inner join dbo.status s_old on wf.oldstatusid = s_old.id
where WF.[Action] <> isnull(SF.[Action],0)
order by BU.Name, s_old.Name
ROLLBACK