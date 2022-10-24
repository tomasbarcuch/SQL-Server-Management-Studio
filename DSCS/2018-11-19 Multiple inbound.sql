/*
select

B.code,
isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId) as EntityID,
lp.Code as EntityCode,
case when lp.Code is null then 11 else 15 end as Entity,
BUPlp.BusinessUnitId as 'ClientBusinessUnitId',
(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then RegisteringDate else null end) as Inbounddate,
isnull((case WHEN WE.QuantityBase < 0 and we.LocationId is not null then RegisteringDate else null end), getdate()) as OutboundDate
from WarehouseEntry WE
left join businessunitpermission BUPlp on WE.loosepartid = BUPlp.LoosepartId
left join LoosePart LP on BUPlp.LoosepartId = LP.Id and we.HandlingUnitId is null
left join bin B on we.binid = B.Id
   Where b.Code like '% SP'

   order by lp.code
*/

select 
LP.code,
* 
from WarehouseEntry WE 
inner join LoosePart LP on we.LoosepartId = LP.Id
where
(WE.QuantityBase > 0 and we.LocationId is not null and WE.LoosepartId = '14b55279-fd2b-4422-bc36-050470bae29c')
-- OR
--(WE.QuantityBase < 0 and we.LocationId is not null and WE.LoosepartId = '14b55279-fd2b-4422-bc36-050470bae29c')




 select 
EntityId,
lp.Code,
count(WE.StatusId)
from WorkflowEntry WE 
inner join LoosePart LP on WE.EntityId = LP.id
where WE.StatusId =(
 select s.id from status S
 inner join BusinessUnitPermission BUP on S.id = BUP.StatusId
 where bup.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
 and S.name = 'lpInbound')
 group by EntityId,lp.Code

having count(WE.StatusId) > 1