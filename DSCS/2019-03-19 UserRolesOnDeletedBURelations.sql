select 
BusinessUnit.name, 
client.Name,
U.[Login]

 from userrole 

inner join BusinessUnit on UserRole.BusinessUnitId = BusinessUnit.Id
inner join BusinessUnit Client on UserRole.ClientBusinessUnitId = Client.Id
inner join [User] U on UserRole.UserId = U.Id
where userrole.id not in (
select ur.id from UserRole UR
inner join (
select RelatedBusinessUnitId, BusinessUnitId from BusinessUnitRelation) BUR on UR.BusinessUnitId = BUR.RelatedBusinessUnitId and UR.ClientBusinessUnitId = BUR.BusinessUnitId)
and nullif(BusinessUnit.name, client.Name) is not null
