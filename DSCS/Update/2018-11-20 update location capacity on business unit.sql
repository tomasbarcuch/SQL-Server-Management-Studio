
begin TRANSACTION
--select * from [Location]
update location set capacity = 700000 from [Location]
inner join BusinessUnitPermission on [Location].id = BusinessUnitPermission.LocationId
where BusinessUnitPermission.BusinessUnitId in (
select 
BusinessUnit.id
 from BusinessUnitRelation 
inner join BusinessUnit on BusinessUnitRelation.BusinessUnitId = BusinessUnit.id
where RelatedBusinessUnitId = (Select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')) and code = 'Hub Bremerhaven'

rollback