Select 
cast(GETDATE() as date) as today,
DATA.*
from (
select
'HU' as Entity,
HU.Code,
HU.ColliNumber,
Commission.CommissionNr+'|' as Commission,
Commission.FIRST_DELIVERY_DATE,
Commission.LAST_DELIVERY_DATE,
L.Name as 'Location'

from HandlingUnit HU 
inner join BusinessUnitPermission CLP on HU.id = CLP.HandlingUnitId
inner join BusinessUnit Client on CLP.BusinessUnitId = Client.id and Client.[Type] = 2 and Client.Name = 'KRONES GLOBAL'
inner join BusinessUnitPermission PAP on HU.id = PAP.HandlingUnitId
inner join BusinessUnit Packer on PAP.BusinessUnitId = Packer.id and Packer.[Type] = 0 and Packer.Name = 'Deufol Neutraubling'

inner join [Location] L on HU.ActualLocationId = L.Id
inner JOIN (
select
DV.Content CommissionNr,
DV.[Description] Commission, 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Commission'
where 
DF.name in ('Plant','Comments','OrderPosition','Network','FIRST_DELIVERY_DATE','LAST_DELIVERY_DATE'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network],[FIRST_DELIVERY_DATE],[LAST_DELIVERY_DATE])) as Commission on HU.id = Commission.EntityId
union

select
'LP', 
LP.Code,
'' as ColliNumber,
Commission.CommissionNr+'|',
Commission.FIRST_DELIVERY_DATE,
Commission.LAST_DELIVERY_DATE,
L.Name as 'Location'

from LoosePart LP 
inner join BusinessUnitPermission CLP on LP.id = CLP.LoosePartId
inner join BusinessUnit Client on CLP.BusinessUnitId = Client.id and Client.[Type] = 2 and Client.Name = 'KRONES GLOBAL'
inner join BusinessUnitPermission PAP on LP.id = PAP.LoosePartId
inner join BusinessUnit Packer on PAP.BusinessUnitId = Packer.id and Packer.[Type] = 0 and Packer.Name = 'Deufol Neutraubling'

inner join [Location] L on LP.ActualLocationId = L.Id
inner JOIN (
select
DV.Content CommissionNr,
DV.[Description] Commission, 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Commission'
where 
DF.name in ('Plant','Comments','OrderPosition','Network','FIRST_DELIVERY_DATE','LAST_DELIVERY_DATE'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network],[FIRST_DELIVERY_DATE],[LAST_DELIVERY_DATE])) as Commission on LP.id = Commission.EntityId
where LP.ActualHandlingUnitId is NULL
) DATA