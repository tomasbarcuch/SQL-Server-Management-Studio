
DECLARE @limit as int = 2
select 

DATA.Client,
SUM(DATA.[Count]) as 'Inbounds',
'Total Inbounds' = (Select
Count(WFE.Id) Count
from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.[Type] = 2
where WorkflowAction = 1 and CAST(WFE.Created as DATE) = CAST(getdate() as DATE)),
SUM(DATA.Brutto) Brutto,
SUM(DATA.Surface) as Surface,
DATA.day
 from (
 
Select
CASE when (Count(WFE.Id)) < @limit then 'OTHERS' else BU.Name end as  Client, 
Count(WFE.Id) Count,
SUM(HU.Brutto) as Brutto,
SUM(HU.Surface) as Surface,
CAST(WFE.Created as DATE) as Day
from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.[Type] = 2
INNER join HandlingUnit HU on WFE.EntityId = HU.Id 
--LEFT join LoosePart LP on WFE.EntityId = LP.Id
where WorkflowAction = 1 and CAST(WFE.Created as DATE) = CAST(getdate() as DATE) and WFE.Entity = 11
group by BU.Name,CAST(WFE.Created as DATE)
) DATA group by DATA.Client,  DATA.[Day] order by Sum(DATA.[Count]) desc




select 

DATA.Client,
SUM(DATA.[Count]) as 'Packed Crates',
'Total Packed Crates' = (Select
Count(WFE.Id) Count
from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.[Type] = 2
where WorkflowAction = 22 and CAST(WFE.Created as DATE) = CAST(getdate() as DATE)),
SUM(DATA.Brutto) Brutto,
SUM(DATA.Surface) as Surface,
DATA.day
 from (
 
Select
CASE when (Count(WFE.Id)) < @limit then 'OTHERS' else BU.Name end as  Client, 
Count(WFE.Id) Count,
SUM(HU.Brutto) as Brutto,
SUM(HU.Surface) as Surface,
CAST(WFE.Created as DATE) as Day
from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.[Type] = 2
inner join HandlingUnit HU on WFE.EntityId = HU.Id
where WorkflowAction = 22 and CAST(WFE.Created as DATE) = CAST(getdate() as DATE)
group by BU.Name,CAST(WFE.Created as DATE)
) DATA group by DATA.Client,  DATA.[Day] order by Sum(DATA.[Count]) desc


/*
select Top(100)* from Log4Net L 
where CAST(L.LogTime as DATE) = CAST(getdate() as DATE) and L.LogLevel =  'INFO'
*/

select 
Count(SL.Id) Count,
SUM(ISNULL(LP.Weight,HU.Brutto)) as Brutto,
SUM(ISNULL(LP.Surface,HU.Surface)) as Surface,
CAST(SL.Created as DATE) as Day

from ShipmentLine SL
left join HandlingUnit HU on SL.HandlingUnitId = HU.Id
left join LoosePart LP on SL.LoosePartId = LP.Id
where Status = 1 and CAST(SL.Created as DATE) = CAST(getdate() as DATE)

group by CAST(SL.Created as DATE)


select 

DATA.Client,
SUM(DATA.[Count]) as 'Oubounds',
'Total Outbounds' = (Select
Count(WFE.Id) Count
from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.[Type] = 2
where WorkflowAction = 2 and CAST(WFE.Created as DATE) = CAST(getdate() as DATE)),
SUM(DATA.Brutto) Brutto,
SUM(DATA.Surface) as Surface,
DATA.day
 from (
 
Select
CASE when (Count(WFE.Id)) < @limit then 'OTHERS' else BU.Name end as  Client, 
Count(WFE.Id) Count,
SUM(ISNULL(LP.Weight,HU.Brutto)) as Brutto,
SUM(ISNULL(LP.Surface,HU.Surface)) as Surface,
CAST(WFE.Created as DATE) as Day
from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.[Type] = 2
LEFT join HandlingUnit HU on WFE.EntityId = HU.Id 
LEFT join LoosePart LP on WFE.EntityId = LP.Id
where WorkflowAction = 2 and CAST(WFE.Created as DATE) = CAST(getdate() as DATE)
group by BU.Name,CAST(WFE.Created as DATE)
) DATA group by DATA.Client,  DATA.[Day] order by Sum(DATA.[Count]) desc
