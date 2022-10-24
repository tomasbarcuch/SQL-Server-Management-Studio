BEGIN TRANSACTION

--select HU.Protection, 
update HU set Protection = case CV.Content 
when '[24M] Alu,schrumpfen,schweissen,abdecken' then 24
when '[12M] Alu,schrumpfen,schweissen,abdecken' then 12
when '[6M] Alu,schrumpfen,schweissen,abdecken' then 6 else 0 end

 FROM CustomValue CV
 inner join HandlingUnit HU on CV.EntityId = HU.Id and CV.CustomFieldId in (Select id from CustomField where name = 'Foil') and LEN(CV.Content)>0
 inner join BusinessUnitPermission BUP on CV.EntityId = BUP.HandlingUnitId and BUP.BusinessUnitId = (Select Id from BusinessUnit where Name = 'KRONES GLOBAL')
 where HU.Protection = 0 and CV.Content not in ('[0M] abdecken','[0M] schrumpfen,abdecken')

COMMIT

begin TRANSACTION
--select BU.Name, HU.Code, Protection,
update HandlingUnit set Protection = 
Case when Protection is null then 0 Else 
Case when Protection between 1 and 5 then 6 Else 
case when Protection between 7 and 11 then 12 else 
case when Protection between 13 and 17 then 18 else 
case when Protection between 19 and 23 then 24 else
case when Protection between 25 and 999 then 36
end end end end end end
from HandlingUnit HU 
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.[Type] = 2
where Protection not in (0,6,12,18,24,36)

COMMIT