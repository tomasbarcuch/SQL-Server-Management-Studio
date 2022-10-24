
declare @BUID as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEMO Project Client')


select Entity.Name,
Translation.[Language],
Translation.Text,
Translation.Entity

from Translation inner join (

select 
BUP.DimensionId As EntityID, D.Name
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.id = @BUID and BUP.DimensionId is not null
inner join Dimension D on BUP.DimensionId = D.id
union
select 
BUP.UnitOfMeasureId, UOM.Name--, UOM.code
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.id = @BUID and BUP.UnitOfMeasureId is not null
inner join UnitOfMeasure UOM on BUP.UnitOfMeasureId = UOM.id
union
select 
BUP.StatusId, S.Name
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.id = @BUID and BUP.StatusId is not null
inner join [Status] S on BUP.StatusId = S.id
union
select 
BUP.BCSActionId,BCSAction.[Description]
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.id = @BUID and BUP.BCSActionId is not null
inner join BCSAction on bup.BCSActionId = BCSAction.id
union
select 
BUP.ServiceTypeId, ST.[Description]--,ST.Code
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.id = @BUID and BUP.ServiceTypeId is not null
inner join ServiceType ST on BUP.ServiceTypeId = ST.Id
union
select DF.ID DimensionFieldId, DF.Name
from DimensionField DF
INNER join Dimension D on DF.DimensionId = D.Id
inner join BusinessUnitPermission BUP on D.Id = BUP.DimensionId and BUP.BusinessUnitId = @BUID
union
select CF.ID, CF.Name
CustomFieldId from CustomField CF
where CF.ClientBusinessUnitId = @BUID
union
select ID DataTypeID, Name from DataType
union
Select UR.RoleId, R.Name from UserRole UR 
inner join Role R on UR.RoleId = R.Id
where UR.ClientBusinessUnitId = @BUID group by RoleId,R.Name
union
select id, Name from DocumentTemplate where businessUnitId in (select RelatedBusinessUnitId from BusinessUnitRelation where BusinessUnitId = @BUID) group by DocumentTemplate.id, Name
 ) Entity on Translation.EntityId = Entity.EntityID and Translation.[Column] = 'name'
union
select Entity.Code,
Translation.[Language],
Translation.Text,
Translation.Entity

from Translation Translation inner join (

select
BUP.UnitOfMeasureId EntityId, UOM.code
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.id = @BUID and BUP.UnitOfMeasureId is not null
inner join UnitOfMeasure UOM on BUP.UnitOfMeasureId = UOM.id
union
select 
BUP.ServiceTypeId,ST.Code
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.id = @BUID and BUP.ServiceTypeId is not null
inner join ServiceType ST on BUP.ServiceTypeId = ST.Id

) Entity on Translation.EntityId = Entity.EntityID and Translation.[Column] = 'Code'









