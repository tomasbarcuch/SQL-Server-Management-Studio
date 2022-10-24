begin transaction

select * from DimensionValue DV 

inner join BusinessUnitPermission BUP on DV.id = BUP.DimensionValueId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id  and BU.[Disabled] = 1 and bu.[Type] = 2

ROLLBACK

begin transaction

select * from Dimension D 

inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id  and BU.[Disabled] = 1 and bu.[Type] = 2

ROLLBACK


begin transaction

select * from DimensionFieldValue DFV 
inner join DimensionValue DV on DFV.DimensionValueId = DV.id
inner join BusinessUnitPermission BUP on DV.id = BUP.DimensionValueId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id  and BU.[Disabled] = 1 and bu.[Type] = 2

ROLLBACK


begin transaction

select * from DimensionField DF 
Inner join DimensionFieldValue DFV on DF.id = DFV.DimensionFieldId
inner join DimensionValue DV on DFV.DimensionValueId = DV.id
inner join BusinessUnitPermission BUP on DV.id = BUP.DimensionValueId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id  and BU.[Disabled] = 1 and bu.[Type] = 2

ROLLBACK