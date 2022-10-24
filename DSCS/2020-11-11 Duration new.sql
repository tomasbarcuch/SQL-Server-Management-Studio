select HU.CODE,HU.TopHandlingUnitId, HU.ParentHandlingUnitId from HandlingUnit HU

where hu.ParentHandlingUnitId = '7f7712e2-4cb1-4987-af72-8b5db8f76a81'

select HU.CODE,HU.TopHandlingUnitId, HU.ParentHandlingUnitId from HandlingUnit HU

where hu.TopHandlingUnitId = '7f7712e2-4cb1-4987-af72-8b5db8f76a81'

select code,cume_dist() over (order by clusteredid) from bin

select code,ntile(10) over (order by clusteredid) from bin


select 
LP.Code, 
WFEstart.EntityId,
WFEend.EntityId, 
WFEstart.Created, 
WFEend.Created,  
case when WFEstart.entityid <> WFEend.EntityId then getdate() else WFEend.Created end,
cast(DATEDIFF([minute],WFEstart.Created,case when WFEstart.entityid <> WFEend.EntityId then getdate() else WFEend.Created end) as decimal(20,4))/60 duration_hours
 
from
(select entityid, created, id sid,lead(id)  over (order by entityid, created) eid from WorkflowEntry) WFEstart
left join WorkflowEntry WFEend on WFEstart.eid = WFEend.id

inner join Loosepart LP on WFEstart.EntityId = LP.Id
inner join BusinessUnitPermission BUP on WFEstart.EntityId = BUP.LoosePartId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'KRONES GLOBAL')


