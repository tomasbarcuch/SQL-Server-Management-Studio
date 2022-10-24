BEGIN TRANSACTION
select 
--data.entityid, 
--data.sname,
WFEID,
data.WEdate,
data.Created 

from (
Select *
 from (
select
WE.LocationId,
WE.HandlingUnitId,
'34003862-35cf-413a-a045-b367322f36d1' as WEStatusId, --statusid HUNew
min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then WE.created-0.0013888888 else null end) as WEdate
from WarehouseEntry WE
left join businessunitpermission BUP on WE.HandlingUnitId = BUP.HandlingUnitId
left join HandlingUnit HU on BUP.HandlingUnitId = HU.id 
    
    Where we.LocationId is not null
    and we.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
  group by 
  WE.LocationId,
WE.HandlingUnitId  
) WEdata

inner join (
select 
WFE.id WFEID, WFE.EntityId, wfe.Created,s.name sname, s.id sid
 from WorkflowEntry WFE
 inner join [Status] S on WFE.StatusId = S.Id
 inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId and WFE.Entity = 11
     WHERE
     wfe.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
   
) WFEdata on WEdata.Handlingunitid = WFEdata.EntityId and WFEdata.sid = WEdata.WEStatusId

UNION

Select * from (
select
WE.LocationId,
WE.HandlingUnitId,
'ce829f46-ce1b-4391-a8bf-6318d9167d1f' as WEStatusId, --statusid HUInbound
min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then WE.created else null end) as WEdate
from WarehouseEntry WE
left join businessunitpermission BUP on WE.HandlingUnitId = BUP.HandlingUnitId
left join HandlingUnit HU on BUP.HandlingUnitId = HU.id 
    
    Where we.LocationId is not null
    and we.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
  group by 
  WE.LocationId,
WE.HandlingUnitId  
) WEdata

inner join (
select 
WFE.id WFEID, WFE.EntityId, wfe.Created,s.name sname, s.id sid
 from WorkflowEntry WFE
 inner join [Status] S on WFE.StatusId = S.Id
 inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId and WFE.Entity = 11
     WHERE
     wfe.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
 
) WFEdata on WEdata.Handlingunitid = WFEdata.EntityId and WFEdata.sid = WEdata.WEStatusId

union

Select * from (
select
WE.LocationId,
WE.HandlingUnitId,
'5e850776-42eb-4b87-8833-1fc9269d2628' as WEStatusId, --statusid HUDispatched
max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then WE.created else null end) as WEDate
from WarehouseEntry WE
left join businessunitpermission BUP on WE.HandlingUnitId = BUP.HandlingUnitId
left join HandlingUnit HU on BUP.HandlingUnitId = HU.id 
    
    Where we.LocationId is not null
    and we.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
  group by 
  WE.LocationId,
WE.HandlingUnitId  
) WEdata

inner join (
select 
WFE.id WFEID, WFE.EntityId, wfe.Created,s.name sname, s.id sid
 from WorkflowEntry WFE
 inner join [Status] S on WFE.StatusId = S.Id
 inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId and WFE.Entity = 11
     WHERE
     wfe.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')

) WFEdata on WEdata.Handlingunitid = WFEdata.EntityId and WFEdata.sid = WEdata.WEStatusId

union

Select * from (
select
WE.LocationId,
WE.HandlingUnitId,
'd258f7d0-54e6-4021-8fdc-8c05571d447a' as WEStatusId, --statusid HULoading
max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then WE.created+0.0003472222222 else null end) as WEDate
from WarehouseEntry WE
left join businessunitpermission BUP on WE.HandlingUnitId = BUP.HandlingUnitId
left join HandlingUnit HU on BUP.HandlingUnitId = HU.id 
    
    Where we.LocationId is not null
    and we.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
  group by 
  WE.LocationId,
WE.HandlingUnitId  
) WEdata

inner join (
select 
WFE.id WFEID, WFE.EntityId, wfe.Created,s.name sname, s.id sid
 from WorkflowEntry WFE
 inner join [Status] S on WFE.StatusId = S.Id
 inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId and WFE.Entity = 11
     WHERE
     wfe.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')

) WFEdata on WEdata.Handlingunitid = WFEdata.EntityId and WFEdata.sid = WEdata.WEStatusId

union

Select * from (
select
WE.LocationId,
WE.HandlingUnitId,
'0c7059d9-55aa-4d21-bc46-8f9a362238e6' as WEStatusId, --statusid HUPacked
max(case WHEN WE.QuantityBase > 0 and we.LocationId is not null and we.LoosepartId is not null then WE.created+0.000694444445 else null end) as WEdate
from WarehouseEntry WE
left join businessunitpermission BUP on WE.HandlingUnitId = BUP.HandlingUnitId
left join HandlingUnit HU on BUP.HandlingUnitId = HU.id 
    
    Where we.LocationId is not null
    and we.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
    and we.LoosepartId is not null
    and WE.Quantity > 0

  group by 
  WE.LocationId,
WE.HandlingUnitId  
) WEdata

inner join (
select 
WFE.id WFEID, WFE.EntityId, wfe.Created,s.name sname, s.id sid
 from WorkflowEntry WFE
 inner join [Status] S on WFE.StatusId = S.Id
 inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId and WFE.Entity = 11
     WHERE
     wfe.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
             
) WFEdata on WEdata.Handlingunitid = WFEdata.EntityId and WFEdata.sid = WEdata.WEStatusId

UNION

Select * from (
select
WE.LocationId,
WE.HandlingUnitId,
'a87690f2-93cd-487c-8898-8d8353210bfd' as WEStatusId, --statusid HUItemInserted
min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null and we.LoosepartId is not null then WE.created+0.000344444445 else null end) as WEdate
from WarehouseEntry WE
left join businessunitpermission BUP on WE.HandlingUnitId = BUP.HandlingUnitId
left join HandlingUnit HU on BUP.HandlingUnitId = HU.id 
    
    Where we.LocationId is not null
    and we.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
    and we.LoosepartId is not null
    and WE.Quantity > 0


group by 
WE.LocationId,
WE.HandlingUnitId

) WEdata

inner join (
select 
WFE.id WFEID, WFE.EntityId, wfe.Created,s.name sname, s.id sid
 from WorkflowEntry WFE
 inner join [Status] S on WFE.StatusId = S.Id
 inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId and WFE.Entity = 11
     WHERE
     wfe.CreatedById in (select id from [User] where login not in ('vvmigration','tomas.barcuch'))
    and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Berlin')
 
) WFEdata on WEdata.Handlingunitid = WFEdata.EntityId and WFEdata.sid = WEdata.WEStatusId

) data

inner join HandlingUnit HU on Data.EntityId = HU.id
where  
--HU.code = '7001056/989'
 cast(WEdate as date) <> cast (data.Created as date)  and  cast(WEdate as date) < '2018-10-01'
--where HandlingUnitId = 'e3d597fa-1489-4b53-a89b-0006f3a2c4e0'
--order by HAndlingunitId, WEdate
commit