


  select 
  d.name lot,
  d1.name 'order',
  df1.Name,
  d2.name project,
  d3.name
  --d4.name,
  --d5.name
  from dimension d
  inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId
inner join dimension d1 on d.ParentDimensionId = d1.Id
left join DimensionField DF1 on D1.id = DF1.DimensionId
inner join dimension d2 on d1.ParentDimensionId = d2.Id
inner join dimension d3 on d2.ParentDimensionId = d3.Id
inner join dimension d4 on d2.ParentDimensionId = d4.Id 
--left join dimension d5 on d2.ParentDimensionId = d5.Id     
  --where bup.businessunitid = (select id from BusinessUnit where name = 'Siemens Frankenthal') and d.disabled = 0

  --and d1.name is not null and d2.name is not null

select 
LP.Code,
Content
 from LoosePart LP
left join (
select 
EDVR.EntityId,
DV.content from 
Dimension D
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and name = 'ORDER'
inner join DimensionValue DV on D.id = DV.DimensionId
inner join EntityDimensionValueRelation EDVR on DV.id = edvr.DimensionValueId
where BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Frankenthal')) DIM on LP.id = DIM.EntityId


