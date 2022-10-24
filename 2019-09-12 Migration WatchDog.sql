declare @Startdate as DATETIME
declare @TSTClientID as UNIQUEIDENTIFIER
declare @PRDClientID as UNIQUEIDENTIFIER
declare @TSTPackerID as UNIQUEIDENTIFIER
declare @PRDPackerID as UNIQUEIDENTIFIER
declare @UserID as UNIQUEIDENTIFIER

set @TSTClientID = (Select BU.id from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnit BU where name = 'Krones AG Migration TEST IV')
set @PRDClientID = (Select id from BusinessUnit where name = 'Krones AG')
set @TSTPackerID = (Select BU.id from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnit BU where name = 'Deufol Hamburg')
set @PRDPackerID = (Select id from BusinessUnit where name = 'Krones AG')
set @UserID = (select id from [User] where login = 'vvmigration')
set @Startdate = '2019-10-09 09:00.000'



select
Packer = (select name from businessunit where id = @PRDPackerID),
Client = (select name from businessunit where id = @PRDClientID),
'User' = (select login from [User] where id = @UserID),
@Startdate as StartDateTime, 
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
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and bup.BusinessUnitId = @PRDClientID
where DV.CreatedById <> @UserID
UNION
SELECT 'Looseparts' as Entity,LP.Created,lp.id
from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and bup.BusinessUnitId = @PRDClientID
where LP.CreatedById <> @UserID and year(LP.Updated) = 2019
UNION
SELECT 'Handlingunits' as Entity, HU.Updated, hu.id
from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId and bup.BusinessUnitId = @PRDClientID
where HU.CreatedById <> @UserID and year(HU.Updated) = 2019
UNION
SELECT 'Warehouse Entries' as Entity,WE.Created, we.id
from WarehouseEntry WE
left join BusinessUnitPermission BUPhu on WE.HandlingUnitId = BUPhu.HandlingUnitId and BUPhu.BusinessUnitId = @PRDClientID
left join BusinessUnitPermission BUPlp on WE.LoosepartId = BUPlp.LoosePartId and BUPlp.BusinessUnitId = @PRDClientID
where WE.CreatedById <> @UserID and year(WE.Updated) = 2019
union
SELECT 'Workflow Entries' as Entity,WF.Created, Wf.id
from WorkflowEntry WF
left join BusinessUnitPermission BUPhu on WF.EntityId = BUPhu.HandlingUnitId and BUPhu.BusinessUnitId = @TSTClientID
left join BusinessUnitPermission BUPlp on WF.EntityID = BUPlp.LoosePartId and BUPlp.BusinessUnitId = @TSTClientID
where WF.CreatedById <> @UserID and year(WF.Updated) = 2019
    ) DETAIL where 
    CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    detail.created), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 
         between @Startdate and getdate()
    
) DATA

group by entity 
--having cast(getdate() - CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,max(created)),DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as decimal(10,6))*1440 > 10

/*
;With Entities
AS
(
SELECT  'Dimension values' as Entity,DV.Created,DV.id,DATEDIFF(dd,0,DV.created) AS dayoffset,
DATEDIFF(ss,MIN(dv.created) OVER (PARTITION BY DATEDIFF(dd,0,DV.created)),dv.created)/60 AS MinOffset
from DimensionValue DV
inner join Dimension D on DV.DimensionId = D.Id
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and bup.BusinessUnitId = @PRDClientID
where DV.CreatedById = @UserID
UNION
SELECT 'Looseparts' as Entity,LP.Created,lp.id,DATEDIFF(dd,0,LP.created) AS dayoffset,
DATEDIFF(ss,MIN(LP.created) OVER (PARTITION BY DATEDIFF(dd,0,LP.created)),LP.created)/60 AS MinOffset
from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and bup.BusinessUnitId = @PRDClientID
where LP.CreatedById = @UserID and year(LP.Updated) = 2019
UNION
SELECT 'Handlingunits' as Entity, HU.Created,HU.id,DATEDIFF(dd,0,HU.created) AS dayoffset,
DATEDIFF(ss,MIN(HU.created) OVER (PARTITION BY DATEDIFF(dd,0,HU.created)),HU.created)/60 AS MinOffset
from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId and bup.BusinessUnitId = @PRDClientID
where HU.CreatedById = @UserID and year(HU.Updated) = 2019
UNION
SELECT 'Warehouse Entries' as Entity,WE.Created,WE.id,DATEDIFF(dd,0,WE.created) AS dayoffset,
DATEDIFF(ss,MIN(WE.created) OVER (PARTITION BY DATEDIFF(dd,0,WE.created)),WE.created)/60 AS MinOffset
from WarehouseEntry WE
left join BusinessUnitPermission BUPhu on WE.HandlingUnitId = BUPhu.HandlingUnitId and BUPhu.BusinessUnitId = @PRDClientID
left join BusinessUnitPermission BUPlp on WE.LoosepartId = BUPlp.LoosePartId and BUPlp.BusinessUnitId = @PRDClientID
where WE.CreatedById = @UserID and year(WE.Updated) = 2019
union
SELECT 'Workflow Entries' as Entity,WF.Created,WF.id,DATEDIFF(dd,0,WF.created) AS dayoffset,
DATEDIFF(ss,MIN(WF.created) OVER (PARTITION BY DATEDIFF(dd,0,WF.created)),WF.created)/60 AS MinOffset
from WorkflowEntry WF
left join BusinessUnitPermission BUPhu on WF.EntityId = BUPhu.HandlingUnitId and BUPhu.BusinessUnitId = @PRDClientID
left join BusinessUnitPermission BUPlp on WF.EntityID = BUPlp.LoosePartId and BUPlp.BusinessUnitId = @PRDClientID
where WF.CreatedById = @UserID and year(WF.Updated) = 2019

)
--select avg(totalcount) as RecordsInMinute  from (
SELECT top(10) MIN(E.created) AS StartDatetime,
 MAX(E.created) AS EndDatetime,
 COUNT(E.ID) AS TotalCount,
 Entity

FROM Entities E
GROUP BY E.dayoffset,(E.MinOffset-1)/@interval,Entity

ORDER by Entity,StartDatetime desc

*/