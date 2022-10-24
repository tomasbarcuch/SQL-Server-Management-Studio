--cascaded parameters 1.parameter

SELECT ID ClientBusinessUnitId, NAME ClientBusinessUnit FROM BusinessUnit WHERE BusinessUnit.[Type] = 2 AND BusinessUnit.[Disabled] = 0 and Name = 'KRONES GLOBAL'
ORDER by Name


-- 2.parameter
select 
BU.id RelatedBusinessUnitId,
BU.name RelatedBusinessUnit
from BusinessUnitRelation BUR
inner join BusinessUnit BU on BUR.RelatedBusinessUnitId = BU.id
where BUR.BusinessUnitId = $P{ClientBusinessUnitId}
order by BU.Name


--dimenze KRONES GLOBAL
select DV.ID KronesProjectId,DV.Content as Project from DimensionValue DV
inner join Dimension D on DV.DimensionId = D.id and D.Name = 'Project' 
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'KRONES GLOBAL')


select DV.ID KronesOrderId,DV.Content as [ORDER] from DimensionValue DV
inner join Dimension D on DV.DimensionId = D.id and D.Name = 'Order' 
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'KRONES GLOBAL')
where DV.ParentDimensionValueId = $P{Project}

select DV.ID KronesCommissionId,DV.Content as Commission from DimensionValue DV
inner join Dimension D on DV.DimensionId = D.id and D.Name = 'Commission' 
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'KRONES GLOBAL')
where DV.ParentDimensionValueId = $P{Order}

