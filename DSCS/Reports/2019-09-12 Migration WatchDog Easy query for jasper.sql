
select

Packer = 'Deufol Hamburg',
Client ='Krones AG',
'User' = 'vvmigration',
'2019-09-12 11:30.000' as StartDateTime, 
getdate() as CurrentDateTime, 
entity as Entity, 
Count(id) as Records,
CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,min(created)),DATENAME(TzOffset, SYSDATETIMEOFFSET()))) AS FirstRecord,
CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,max(created)),DATENAME(TzOffset, SYSDATETIMEOFFSET()))) AS LastRecord,
cast(getdate() - CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,max(created)),DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as decimal(10,6))*1440 as MinutesToLastRecord 
from
(
    select * from (
SELECT  'Dimension values' as Entity,DV.Created,dv.id
from DimensionValue DV
inner join Dimension D on DV.DimensionId = D.Id
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG')
where DV.CreatedById = (select id from [User] where login = 'vvmigration')
UNION
SELECT 'Looseparts' as Entity,LP.Created,lp.id
from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and bup.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG')
where LP.CreatedById = (select id from [User] where login = 'vvmigration') and year(LP.Updated) = 2019
UNION
SELECT 'LPIdentifier' as Entity,IDF.Created,IDF.id
from LoosepartIdentifier IDF
inner join BusinessUnitPermission BUP on IDF.LoosepartId = BUP.LoosePartId and bup.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG')
where IDF.CreatedById = (select id from [User] where login = 'vvmigration') and year(IDF.Updated) = 2019
UNION
SELECT 'Handlingunits' as Entity, HU.Updated, hu.id
from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId and bup.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG')
where HU.CreatedById = (select id from [User] where login = 'vvmigration') and year(HU.Updated) = 2019
UNION
SELECT 'Warehouse Entries' as Entity,WE.Created, we.id
from WarehouseEntry WE
left join BusinessUnitPermission BUPhu on WE.HandlingUnitId = BUPhu.HandlingUnitId and BUPhu.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG')
left join BusinessUnitPermission BUPlp on WE.LoosepartId = BUPlp.LoosePartId and BUPlp.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG')
where WE.CreatedById = (select id from [User] where login = 'vvmigration') and year(WE.Updated) = 2019
union
SELECT 'Workflow Entries' as Entity,WF.Created, Wf.id 
from WorkflowEntry WF
left join BusinessUnitPermission BUPhu on WF.EntityId = BUPhu.HandlingUnitId and BUPhu.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG')
left join BusinessUnitPermission BUPlp on WF.EntityID = BUPlp.LoosePartId and BUPlp.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG')
where WF.CreatedById = (select id from [User] where login = 'vvmigration') and year(WF.Updated) = 2019
    ) DETAIL where 
    CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    detail.created), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 

         between '2018-01-14 8:00.000' and getdate()
    
) DATA

group by entity 
--having cast(getdate() - CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,max(created)),DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as decimal(10,6))*1440 > 5