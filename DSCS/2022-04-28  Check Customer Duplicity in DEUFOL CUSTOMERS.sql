select DFV.Content, DV.Content, DV.[Description] from DimensionValue DV
inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'Customer'
inner join BusinessUnitPermission BUP on DV.Id = BUP.DimensionValueId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS' )
inner join DimensionField DF on D.Id = DF.DimensionId and DF.Name = 'VAT Registration No_'
inner join DimensionFieldValue DFV on DF.id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id


select DFV.Content VAT, COUNT(DV.Content) Count, DV.[Description] Name from DimensionValue DV
inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'Customer'
inner join BusinessUnitPermission BUP on DV.Id = BUP.DimensionValueId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS' )
inner join DimensionField DF on D.Id = DF.DimensionId and DF.Name = 'VAT Registration No_'
inner join DimensionFieldValue DFV on DF.id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id
group by DFV.Content, DV.[Description]
having COUNT(DV.Content) > 1