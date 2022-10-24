declare @TSTClientID as UNIQUEIDENTIFIER
declare @PRDClientID as UNIQUEIDENTIFIER
declare @TSTPackerID as UNIQUEIDENTIFIER
declare @PRDPackerID as UNIQUEIDENTIFIER
declare @UserID as UNIQUEIDENTIFIER

set @TSTClientID = (Select BU.id from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnit BU where name = 'Krones AG VV')
set @PRDClientID = (Select id from BusinessUnit where name = 'Krones AG')
set @TSTPackerID = (Select BU.id from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnit BU where name = 'Deufol Hamburg')
set @PRDPackerID = (Select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')
set @UserID = (select id from [User] where login = 'vvmigration')



;With DimensionValues
AS
(
SELECT DV.Created,DV.id,DATEDIFF(dd,0,DV.created) AS dayoffset,
DATEDIFF(ss,MIN(dv.created) OVER (PARTITION BY DATEDIFF(dd,0,DV.created)),dv.created)/60 AS MinOffset
from DimensionValue DV
inner join Dimension D on DV.DimensionId = D.Id
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and bup.BusinessUnitId = @PRDClientID
where DV.CreatedById = @UserID
)
--select avg(totalcount) as RecordsInMinute  from (
SELECT top(5) MIN(DV.created) AS StartDatetime,
 MAX(DV.created) AS EndDatetime,
 COUNT(DV.ID) AS TotalCount
 ,'Dimension values' as Entity
FROM DimensionValues DV
GROUP BY dayoffset,(MinOffset-1)/1

--ORDER by StartDatetime desc




;With Looseparts
AS
(
SELECT LP.Created,lp.id,DATEDIFF(dd,0,LP.created) AS dayoffset,
DATEDIFF(ss,MIN(LP.created) OVER (PARTITION BY DATEDIFF(dd,0,LP.created)),LP.created)/60 AS MinOffset
from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and bup.BusinessUnitId = @PRDClientID
where LP.CreatedById = @UserID
)
--select avg(totalcount) as RecordsInMinute  from (
SELECT top(5) MIN(LP.created) AS StartDatetime,
 MAX(LP.created) AS EndDatetime,
 COUNT(LP.ID) AS TotalCount
 ,'Looseparts' as Entity
FROM LooseParts LP
GROUP BY dayoffset,(MinOffset-1)/60

ORDER by StartDatetime desc
--)  data


;With HandlingUnits
AS
(
SELECT HU.Created,HU.id,DATEDIFF(dd,0,HU.created) AS dayoffset,
DATEDIFF(ss,MIN(HU.created) OVER (PARTITION BY DATEDIFF(dd,0,HU.created)),HU.created)/60 AS MinOffset
from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId and bup.BusinessUnitId = @PRDClientID
where HU.CreatedById = @UserID
)
--select avg(totalcount) as RecordsInMinute  from (
SELECT top(5) MIN(HU.created) AS StartDatetime,
 MAX(HU.created) AS EndDatetime,
 COUNT(HU.ID) AS TotalCount
 ,'Handling Units' as Entity
FROM HandlingUnits HU
GROUP BY dayoffset,(MinOffset-1)/60

ORDER by StartDatetime desc
--)  data


;With WarehouseEntries
AS
(
SELECT WE.Created,WE.id,DATEDIFF(dd,0,WE.created) AS dayoffset,
DATEDIFF(ss,MIN(WE.created) OVER (PARTITION BY DATEDIFF(dd,0,WE.created)),WE.created)/60 AS MinOffset
from WarehouseEntry WE
left join BusinessUnitPermission BUPhu on WE.HandlingUnitId = BUPhu.HandlingUnitId and BUPhu.BusinessUnitId = @PRDClientID
left join BusinessUnitPermission BUPlp on WE.LoosepartId = BUPlp.LoosePartId and BUPlp.BusinessUnitId = @PRDClientID
where WE.CreatedById = @UserID

)
--select avg(totalcount) as RecordsInMinute  from (
SELECT top(5) MIN(WE.created) AS StartDatetime,
 MAX(WE.created) AS EndDatetime,
 COUNT(WE.ID) AS TotalCount
,'Warehouse Entries' as Entity
FROM WarehouseEntries WE
GROUP BY dayoffset,(MinOffset-1)/60

ORDER by StartDatetime desc