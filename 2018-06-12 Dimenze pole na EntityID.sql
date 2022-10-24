select 
d.clientbusinessUnitID,
edvr.entityid as entityID,
edvr.entity as Entity,
d.name as DimensionName,
d.description as DimensionDescription , 
df.name as DFName,
dfv.content as DFVContent ,
DFVm.Content as machinentyp,
dv.content as DVContent,
dv.description VDescritpion,
t.Text as Status
from  dbo.EntityDimensionValueRelation EDVR 
inner join dbo.DimensionValue DV on EDVR.DimensionValueId =  DV.Id 
inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name in  ('Kennwort')
inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id 
inner join dbo.DimensionValue DVm on EDVR.DimensionValueId =  DVm.Id 
inner join dbo.DimensionField DFm on DVm.DimensionId = DFm.DimensionId and DFm.name in  ('Maschinen Typ')
inner join dbo.DimensionFieldValue DFVm on DFm.Id = DFVm.DimensionFieldId and DFVm.DimensionValueId = DVm.Id 
inner join dbo.Dimension D on DV.DimensionId = D.Id and D.disabled = 0
inner join dbo.Status S on DV.StatusId = S.Id
left join dbo.Translation T on S.id = T.EntityId and t.[Language] = 'DE'