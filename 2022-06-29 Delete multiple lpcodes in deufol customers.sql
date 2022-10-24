BEGIN TRANSACTION

--select 
--LEFT(DATA.Code +'-'+cast(DATA.ClusteredId as VARCHAR),20)
--CASE when LEN(DATA.Code +'-'+cast(DATA.ClusteredId as VARCHAR)) > 20 then 1 else 0 end

update LoosePart set Code = LEFT(DATA.Code +'-'+cast(DATA.ClusteredId as VARCHAR),20)

from (
select  LP.Code, LP.ClusteredId, LP.Id from LoosePart LP
inner join 
(select LP.code, max(LP.ClusteredId) CLUSTEREDID
from LoosePart lp
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2 and BU.Name = 'DEUFOL CUSTOMERS'
group by code, bu.Name
having 
count(code) > 1) DATA on LP.Code = DATA.Code and LP.ClusteredId = DATA.CLUSTEREDID
) DATA

inner join BusinessUnitPermission BUP on DATA.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2

where DATA.id = LoosePart.Id

ROLLBACK

BEGIN TRANSACTION

--select LEFT(DATA.Code +'-'+cast(DATA.ClusteredId as VARCHAR),20)


update HandlingUnit set Code = LEFT(DATA.Code +'-'+cast(DATA.ClusteredId as VARCHAR),20)

from (
select  HU.Code, HU.ClusteredId, HU.Id from HandlingUnit HU
inner join 
(select HU.code, max(HU.ClusteredId) CLUSTEREDID
from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2 and BU.Name = 'DEUFOL CUSTOMERS'
group by code, bu.Name
having 
count(code) > 1) DATA on HU.Code = DATA.Code and HU.ClusteredId = DATA.CLUSTEREDID
) DATA

inner join BusinessUnitPermission BUP on DATA.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2

where DATA.id = HandlingUnit.Id

ROLLBACK
