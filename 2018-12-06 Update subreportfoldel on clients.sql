BEGIN TRANSACTION
--update BusinessUnit set Businessunit.reportsubfolder = '/Berlin'
select BU.reportsubfolder,BUR.Name,BU.name
 from BusinessUnitRelation 
inner join BusinessUnit BU on BusinessUnitRelation.BusinessUnitId = BU.id
inner join BusinessUnit BUR on BusinessUnitRelation.RelatedBusinessUnitId = BUR.id
where 
--RelatedBusinessUnitId in (Select id from BusinessUnit where name in ('Deufol Berlin')) and 
BU.[Type] = 2
and BU.[Disabled] = 0 
and bur.[Disabled] = 0
rollback
