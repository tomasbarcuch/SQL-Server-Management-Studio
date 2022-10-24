select 
edvr.EntityId,
* from 
LoosePart LP

inner join EntityDimensionValueRelation EDVR on LP.Id = EDVR. EntityId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join  DimensionFieldValue DFV on DV.id = DFV.DimensionValueId
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id
inner join Dimension D on DF.DimensionId = D.Id

where edvr.entityId = 'df1808bc-45f0-4752-aa1d-ee697d963831'