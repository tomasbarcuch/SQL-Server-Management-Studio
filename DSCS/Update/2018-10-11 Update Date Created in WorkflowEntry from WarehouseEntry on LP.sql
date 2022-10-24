BEGIN TRANSACTION
--update WorkflowEntry set WorkflowEntry.Created = data.WEdate



select 
--data.entityid, 
--data.sname,
LP.Code,
WFEID,
data.WEdate,
data.Created 
from (


Select *
 from (
select
WE.LocationId,
WE.LoosepartId,
'e0b706ea-b4c1-42aa-a58a-9902dd99a706' as WEStatusId, --statusid LPNew
min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then WE.created-0.000694444445 else null end) as WEdate
from WarehouseEntry WE
left join businessunitpermission BUP on WE.loosepartid = BUP.LoosepartId
left join LoosePart LP on BUP.LoosepartId = LP.Id 
    
    Where we.LocationId is not null
    and we.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
  group by 
  WE.LocationId,
WE.LoosepartId  
) WEdata

inner join (
select 
WFE.id WFEID, WFE.EntityId, wfe.Created,s.name sname, s.id sid
 from WorkflowEntry WFE
 inner join [Status] S on WFE.StatusId = S.Id
 inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.LoosePartId and WFE.Entity = 15
     WHERE
     wfe.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
    
) WFEdata on WEdata.loosepartid = WFEdata.EntityId and WFEdata.sid = WEdata.WEStatusId

UNION

Select * from (
select
WE.LocationId,
WE.LoosepartId,
'a253d98b-6a1b-49ad-a59c-6b3f0d5d3ccd' as WEStatusId, --statusid LPInbound
min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then WE.created+0.000694444445 else null end) as WEdate
from WarehouseEntry WE
left join businessunitpermission BUP on WE.loosepartid = BUP.LoosepartId
left join LoosePart LP on BUP.LoosepartId = LP.Id 
    
    Where we.LocationId is not null
    and we.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
  group by 
  WE.LocationId,
WE.LoosepartId  
) WEdata

inner join (
select 
WFE.id WFEID, WFE.EntityId, wfe.Created,s.name sname, s.id sid
 from WorkflowEntry WFE
 inner join [Status] S on WFE.StatusId = S.Id
 inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.LoosePartId and WFE.Entity = 15
     WHERE
     wfe.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
    
) WFEdata on WEdata.loosepartid = WFEdata.EntityId and WFEdata.sid = WEdata.WEStatusId

union

Select * from (
select
WE.LocationId,
WE.LoosepartId,
'cc407bbd-1d48-4b91-b8cb-602fc02e2500' as WEStatusId, --statusid LPShipped
max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then WE.created else null end) as WEDate
from WarehouseEntry WE
left join businessunitpermission BUP on WE.loosepartid = BUP.LoosepartId
left join LoosePart LP on BUP.LoosepartId = LP.Id 
    
    Where we.LocationId is not null
    and we.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
  group by 
  WE.LocationId,
WE.LoosepartId  
) WEdata

inner join (
select 
WFE.id WFEID, WFE.EntityId, wfe.Created,s.name sname, s.id sid
 from WorkflowEntry WFE
 inner join [Status] S on WFE.StatusId = S.Id
 inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.LoosePartId and WFE.Entity = 15
     WHERE
     wfe.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
   
) WFEdata on WEdata.loosepartid = WFEdata.EntityId and WFEdata.sid = WEdata.WEStatusId



union

Select * from (
select
WE.LocationId,
WE.LoosepartId,
'b63c865d-0660-4f91-9138-9291deec678c' as WEStatusId, --statusid LPPacked
case WHEN WE.QuantityBase > 0 and we.LocationId is not null and we.HandlingUnitId is not null then WE.created else null end as WEdate
from WarehouseEntry WE
left join businessunitpermission BUP on WE.loosepartid = BUP.LoosepartId
left join LoosePart LP on BUP.LoosepartId = LP.Id 
    
    Where we.LocationId is not null
    and we.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
    and we.HandlingUnitId is not null
    and WE.Quantity > 0
 
) WEdata

inner join (
select 
WFE.id WFEID, WFE.EntityId, wfe.Created,s.name sname, s.id sid
 from WorkflowEntry WFE
 inner join [Status] S on WFE.StatusId = S.Id
 inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.LoosePartId and WFE.Entity = 15
     WHERE
     wfe.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
   
) WFEdata on WEdata.loosepartid = WFEdata.EntityId and WFEdata.sid = WEdata.WEStatusId

UNION

Select * from (
select
WE.LocationId,
WE.LoosepartId,
'11276fee-74a6-4d9f-b826-ada0a51ba3ab' as WEStatusId, --statusid LPPainted
case WHEN WE.QuantityBase > 0 and we.LocationId is not null and we.HandlingUnitId is not null then WE.created-0.000694444445 else null end as WEdate
from WarehouseEntry WE
left join businessunitpermission BUP on WE.loosepartid = BUP.LoosepartId
left join LoosePart LP on BUP.LoosepartId = LP.Id 
    
    Where we.LocationId is not null
    and we.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
    and we.HandlingUnitId is not null
    and WE.Quantity > 0
 
) WEdata

inner join (
select 
WFE.id WFEID, WFE.EntityId, wfe.Created,s.name sname, s.id sid
 from WorkflowEntry WFE
 inner join [Status] S on WFE.StatusId = S.Id
 inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.LoosePartId and WFE.Entity = 15
     WHERE
     wfe.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
   
) WFEdata on WEdata.loosepartid = WFEdata.EntityId and WFEdata.sid = WEdata.WEStatusId

) data

inner join LoosePart LP on Data.EntityId = LP.Id
--where lp.code = '0000020902/000310'
 where cast(WEdate as date) <> cast (data.Created as date)  and  cast(WEdate as date) < '2018-10-01'
--where  data.LoosepartId =  '9b9affe2-8ef6-464a-ab06-001dc73655c3'
order by LoosepartId, WEdate


COMMIT