
BEGIN TRANSACTION
declare @Client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Siempelkamp Maschinen- und Anlagenbau GmbH')
DECLARE @Entity as TINYINT = 11


insert into [CustomValue]
(
	[Id],
	[CustomFieldId],
	[Entity],
	[EntityId],
	[Content] ,
	[CreatedById] ,
	[UpdatedById] ,
	[Created],
	[Updated]
)

(

    select 

newid() [Id]
,CF.Id [CustomFieldId]
,CF.Entity
,LP.Id [EntityId]
,CF.DefaultValue [Content]
,(select id from [User] where login = 'it.support') [CreatedById]
,(select id from [User] where login = 'it.support') [UpdatedById]
,LP.created [Created]
,LP.created [Updated]

from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id
inner join LoosePart LP on BUP.LoosePartId = LP.id
inner join CustomField CF on 15 = CF.Entity and CF.ClientBusinessUnitId = BUP.BusinessUnitId and CF.Entity = 15
left join CustomValue CV on CV.EntityId = LP.id and CV.CustomFieldId = CF.Id

where CV.id is null
)

ROLLBACK