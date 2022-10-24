BEGIN TRANSACTION
delete from BusinessUnitRelation where id in (
select BUR.id from BusinessUnitRelation BUR

inner join BusinessUnit Client on BUR.BusinessUnitId = Client.id and Client.[Type] = 2 and Client.[Disabled] = 1
--inner join BusinessUnit Packer on BUR.RelatedBusinessUnitId = Packer.id and Packer.[Type] = 0 and Packer.[Disabled] = 1
)

Rollback
