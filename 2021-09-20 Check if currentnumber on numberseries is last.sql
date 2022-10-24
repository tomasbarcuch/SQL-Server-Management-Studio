BEGIN TRANSACTION

select
BU.Name,
NS.Entity,
MAX(CAST(SUBSTRING(HU.Code,LEN(NS.Prefix)+1,LEN(NS.EndNumber)) as INT))+1
from HandlingUnit HU 
inner join NumberSeries NS on HU.NumberSeriesId = NS.Id and NS.[Disabled] = 0
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2 and BU.[Disabled] = 0 -- and BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')
where NS.Prefix = SUBSTRING(HU.Code,0,LEN(NS.Prefix)+1)
group by BU.Name,NS.CurrentNumber,NS.Entity
having MAX(CAST(SUBSTRING(HU.Code,LEN(NS.Prefix)+1,LEN(NS.EndNumber)) as INT))+1 <> NS.CurrentNumber
ROLLBACK


BEGIN TRANSACTION

select
BU.Name,
NS.Entity,
MAX(CAST(SUBSTRING(LP.Code,LEN(NS.Prefix)+1,LEN(NS.EndNumber)) as INT))+1
from LoosePart LP 
inner join NumberSeries NS on LP.NumberSeriesId = NS.Id and NS.[Disabled] = 0
inner join BusinessUnitPermission BUP on LP.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2 and BU.[Disabled] = 0 -- and BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')
where NS.Prefix = SUBSTRING(LP.Code,0,LEN(NS.Prefix)+1)
group by BU.Name,NS.CurrentNumber,NS.Entity
having MAX(CAST(SUBSTRING(LP.Code,LEN(NS.Prefix)+1,LEN(NS.EndNumber)) as INT))+1 <> NS.CurrentNumber
ROLLBACK