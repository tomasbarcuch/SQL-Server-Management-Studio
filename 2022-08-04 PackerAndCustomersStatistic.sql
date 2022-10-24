select DV.[Description] Customer, BU.Name Packer, COUNT(DATA.EntityId) Entities from 
(select ISNULL(BUP.HandlingUnitId,BUP.LoosePartId) Entityid from BusinessUnitPermission BUP
where BUP.BusinessUnitId = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
and (BUP.HandlingUnitId is not null or BUP.LoosePartId is not null)

) DATA
inner join EntityDimensionValueRelation EDVR on DATA.Entityid = EDVR.EntityId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.id 
inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'Customer'
inner join BusinessUnitPermission BUP on DATA.Entityid = ISNULL(BUP.HandlingUnitId,BUP.LoosePartId)
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] <> 2


group by dv.[Description],  BU.Name

order by Packer, Entities DESC

