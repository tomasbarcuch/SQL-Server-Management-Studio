
select 
Status.Name,
* from WarehouseEntry
inner join (
select * from WorkflowEntry 
) WF on Convert(char(19),WarehouseEntry.Updated, 120) = Convert(char(19),WF.Updated, 120) and WF.EntityId = WarehouseEntry.HandlingUnitId
inner join [Status] on WF.StatusId = [Status].Id
where 
LocationId is not NULL
and HandlingUnitId is not NULL
and LoosepartId is not NULL



declare @id as UNIQUEIDENTIFIER
declare @status as varchar(100)
set @id = '239f3c6d-a394-4225-b3fd-735b9474e571'
set @status = 'HuItemInserted'


select 
Status.Name,
* from WarehouseEntry
inner join (
select * from WorkflowEntry 
where WorkflowEntry.EntityId = @id
and StatusId in (select id from [Status] where Name = @status)
) WF on Convert(char(19),WarehouseEntry.Updated, 120) = Convert(char(19),WF.Updated, 120) and WF.EntityId = WarehouseEntry.HandlingUnitId
inner join [Status] on WF.StatusId = [Status].Id
where 
HandlingUnitId = @id and
LocationId is not NULL
and HandlingUnitId is not NULL
and LoosepartId is not NULL