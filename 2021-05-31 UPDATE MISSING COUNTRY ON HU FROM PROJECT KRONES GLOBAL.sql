
begin transaction 
update CV set CV.content = DFV.Content

from 
CustomValue CV 
inner join CustomField CF on CV.CustomFieldId = CF.id 
inner join DimensionField DF on CF.DimensionFieldId = DF.Id and DF.Name = 'GRAddressCountry' and DF.ClientBusinessUnitId = (select id from BusinessUnit where Name = 'KRONES GLOBAL')
inner join DimensionFieldValue DFV on DF.id = DFV.DimensionFieldId
inner join DimensionValue DV on DFV.DimensionValueId = DV.Id
inner join EntityDimensionValueRelation EDVR on DV.id = EDVR.DimensionValueId and EDVR.EntityId = CV.EntityId
where
((CV.Content = '')
or  
(CV.Content <> DFV.Content)
)

rollback

/*
begin TRANSACTION
update handlingunit set PackingRuleDimensionId = '78748a38-e4f4-48a0-9d62-ff09aafc9b6e'  from HandlingUnit
inner join BusinessUnitPermission on HandlingUnit.id = BusinessUnitPermission.HandlingUnitId and BusinessUnitPermission.BusinessUnitId = (select id from BusinessUnit where Name = 'KRONES GLOBAL')
where PackingRuleType = 1 and PackingRuleDimensionId is null
ROLLBACK
*/


begin transaction
update HandlingUnit set PackingRuleDimensionId = '78748a38-e4f4-48a0-9d62-ff09aafc9b6e'
--select HandlingUnit.Id,PackingRuleType, PackingRuleDimensionId
from HandlingUnit
inner join BusinessUnitPermission on HandlingUnit.id = BusinessUnitPermission.HandlingUnitId and BusinessUnitPermission.BusinessUnitId = (select id from BusinessUnit where Name = 'KRONES GLOBAL')
where PackingRuleType = 1 and PackingRuleDimensionId not in ('78748a38-e4f4-48a0-9d62-ff09aafc9b6e','438dbe41-62fa-4434-a97c-29adc867d0cf')
ROLLBACK