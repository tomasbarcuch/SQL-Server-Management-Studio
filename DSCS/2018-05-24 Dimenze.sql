use [DFCZ_OSLET_tst]

select * from dbo.entitydimensionvaluerelation where id in (
'3cc3c628-d124-4ce9-bf3e-05eba74f433c',
'5b1f19ab-1c82-4795-a23c-5b997b874b66')

select * from dimensionvalue where id in (
'E4BB2A13-200B-41F1-A1EA-30ECC1963D99',
'4D62FD1D-3EDA-4F06-9780-E075A6F0E454')

select * from dimension where id in(
'412EF449-37A5-47AC-AC96-E4C7A803B571',
'78212081-D8D5-40EF-9E22-78702C976F1E')

select
d.clientbusinessUnitID,
edvr.entityid as entityID,
edvr.entity as Entity,
d.name as DimensionName,
d.description as DimensionDescription , 
df.name as DFName,
dfv.content as DFVContent ,
dv.content as DVContent,
dv.description VDescritpion

 from 
 dbo.EntityDimensionValueRelation EDVR
 inner join dbo.DimensionValue DV on EDVR.DimensionValueId =  DV.Id
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name in  ('Kennwort','Markierung')
 inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id
inner join dbo.Dimension D on DV.DimensionId = D.Id and D.disabled = 0