select HU.Code, HU.[Description], HU.SerialNo, HU.ColliNumber, 
replace(replace(HU.SerialNo,' ',''),'-','')
from HandlingUnit HU 
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.name = 'Krones AG'
inner join EntityDimensionValueRelation EDVR on HU.id = EDVR.EntityId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id and DV.Content = 'VT00078220'
inner join HandlingUnitType HUT on HU.TypeId =  HUT.id and HUT.Container = 1
--where HU.SerialNo =''

begin TRANSACTION
update HandlingUnit set SerialNo = replace(replace(HU.SerialNo,' ',''),'-','') from HandlingUnit HU 
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.name = 'Krones AG'
inner join EntityDimensionValueRelation EDVR on HU.id = EDVR.EntityId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id and DV.Content = 'VT00078220'
inner join HandlingUnitType HUT on HU.TypeId =  HUT.id and HUT.Container = 1
--where HU.SerialNo =''

ROLLBACK