begin TRANSACTION
--update WFE set WFE.BusinessUnitId = DATA.BusinessUnitId
select DATA.BusinessUnitId, WFE.BusinessUnitId, WFE.* 
from WorkflowEntry WFE
inner join BusinessUnit BU on WFE.BusinessUnitId = BU.id and BU.[Disabled] = 0
inner join BusinessUnit CL on WFE.ClientBusinessUnitId = CL.id and CL.[Disabled] = 0
inner join BusinessUnitRelation BUR on WFE.ClientBusinessUnitId = BUR.BusinessUnitId

inner join (select BUP.BusinessUnitId, BUP.LoosePartId, BUP.Created,LAG(BUP.Created) over (order by BUP.loosepartid, BUP.created) CreatedStart from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.type <> 2

where LoosePartId is not null
--and loosepartid = '7d4a0f8c-af68-4747-9eaf-78471e04a89f'
) DATA on WFE.EntityId = DATA.LoosePartId 



where WFE.ClientBusinessUnitId = WFE.BusinessUnitId 
and cast(WFE.Created as DATE) between CAST(DATA.CreatedStart as DATE) and CAST(DATA.Created as DATE)
--and WFE.Created between DATA.CreatedStart and DATA.Created
and DATA.BusinessUnitId in (BUR.RelatedBusinessUnitId)


ROLLBACK

begin TRANSACTION
update WFE set WFE.BusinessUnitId = DATA.BusinessUnitId
--select DATA.BusinessUnitId, WFE.BusinessUnitId, WFE.* 
from WorkflowEntry WFE
inner join BusinessUnit BU on WFE.BusinessUnitId = BU.id and BU.[Disabled] = 0
inner join BusinessUnit CL on WFE.ClientBusinessUnitId = CL.id and CL.[Disabled] = 0
inner join BusinessUnitRelation BUR on WFE.ClientBusinessUnitId = BUR.BusinessUnitId

inner join (select BUP.BusinessUnitId, BUP.HandlingUnitId, BUP.Created,LAG(BUP.Created) over (order by BUP.HandlingUnitId, BUP.created) CreatedStart from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.type <> 2

where HandlingUnitId is not null
and HandlingUnitId = 'c0de557a-deb0-4e5e-9c80-277812973feb'
) DATA on WFE.EntityId = DATA.HandlingUnitId 



where WFE.ClientBusinessUnitId = WFE.BusinessUnitId 
and cast(WFE.Created as DATE) between CAST(DATA.CreatedStart as DATE) and CAST(DATA.Created as DATE)
--and WFE.Created between DATA.CreatedStart and DATA.Created
and DATA.BusinessUnitId in (BUR.RelatedBusinessUnitId)


ROLLBACK