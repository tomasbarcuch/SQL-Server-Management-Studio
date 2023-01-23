begin TRANSACTION

UPDATE POH set POH.CountLines = DATA.Cou from PackingOrderHeader POH

inner join (
select COUNT(POL.Id) Cou, POL.PackingOrderHeaderId from PackingOrderLine POL 
group by POL.PackingOrderHeaderId) DATA on POH.id = DATA.PackingOrderHeaderId

where CountLines <> DATA.Cou

COMMIT


begin TRANSACTION

UPDATE POH set POH.CountPackedLines = DATA.Cou 

--select BU.NAme, POH.CountPackedLines, DATA.Cou, DATA.ActualHandlingUnitId 
from PackingOrderHeader POH

inner join (
select COUNT(LP.Id) cou , LP.ActualHandlingUnitId  from LoosePart LP 
group by LP.ActualHandlingUnitId
) DATA on POH.HandlingUnitId = DATA.ActualHandlingUnitId

inner join BusinessUnitPermission BUP on DATA.ActualHandlingUnitId = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Type = 2

where POH.CountPackedLines <> DATA.cou and DATA.Cou <> 0
COMMIT