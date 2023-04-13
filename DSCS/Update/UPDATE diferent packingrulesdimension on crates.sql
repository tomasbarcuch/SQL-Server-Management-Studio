begin TRANSACTION
update HU set HU.PackingRuleDimensionId = BU.PackingRuleDimensionId
--select  BU.NAME, BU2.NAME, HU.ID, BU.PackingRuleDimensionId, HU.PackingRuleDimensionId 
from BusinessUnit BU

inner join BusinessUnitPermission BUP on BU.id = BUP.BusinessUnitId
inner JOIN HandlingUnit HU on BUP.HandlingUnitId = HU.ID and HU.PackingRuleType = 1 AND BU.Name = 'KRONES GLOBAL'
inner join BusinessUnitPermission BUP2 on HU.PackingRuleDimensionId = BUP2.DimensionId
inner join BusinessUnit BU2 on BUP2.BusinessUnitId = BU2.Id



where BU.PackingRuleType = 1 and BU.[Disabled] = 0 and BU.[Type] = 2-- and BU2.Id <> BU.Id
 and BU.PackingRuleDimensionId <> HU.PackingRuleDimensionId and HU.PackingRuleDimensionId <> '286f90b2-9d3c-486d-96f7-f87663a96a69'

ROLLBACK

