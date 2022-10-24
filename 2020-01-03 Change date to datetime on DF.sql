select DT.id,BU.name, DF.id, DF.Name, DT.Name, DT.FieldType from DimensionField DF 
inner join DataType DT on DF.DataTypeId = DT.Id
inner join dimension D on DF.DimensionId = D.Id
inner join BusinessUnitPermission BUP on BUP.DimensionId = D.id
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and bu.type = 2
where DT.FieldType = 'System.DateTime'

select * from DimensionFieldValue  DFV where DFV.DimensionFieldId = '5a4dbb27-b0d6-4637-95d4-632bb86b29c4' order by created


update DimensionField set datatypeid = '91654f6f-e251-41df-ab52-53ade5c0db81' where id = '5a4dbb27-b0d6-4637-95d4-632bb86b29c4'


select * from DataType