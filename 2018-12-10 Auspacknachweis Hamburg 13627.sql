select
BU.name,
HU.code,
POH.Code,
RespPersD.[Responsible Person], 
SH.Code,
* 
from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
left join PackingOrderHeader POH on isnull(HU.ParentHandlingUnitId,hu.id) = POH.HandlingUnitId
left join ShipmentLine SL on HU.id = SL.HandlingUnitId
left join ShipmentHeader SH on SL.ShipmentHeaderId = SH.id
left join (
Select
EDVR.entityid,
DFV.Content as 'Responsible Person'
from DimensionFieldValue DFV
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id and DF.Name = 'Responsible Person'
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
) RespPersD on POH.Id = RespPersD.EntityId

where EXISTS(select * from BusinessUnitPermission where BusinessUnitId = (Select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen'))
and sh.[Type] = 1
/*(select BusinessUnitId from BusinessUnitRelation 
inner join BusinessUnit BU on BusinessUnitRelation.RelatedBusinessUnitId = BU.id
and EXISTS(select * from BusinessUnitPermission where BusinessUnitId = (Select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')))
*/

and bu.name = 'Induga'

--and hu.Code = 'HU012-000080'


