select s.id, Name, Color from [Status] S
inner join BusinessUnitPermission bup on S.id = bup.StatusId where bup.BusinessUnitId in (
select BusinessUnitId from BusinessUnitRelation where RelatedBusinessUnitId = (
select id from BusinessUnit BU where name = 'Deufol Hamburg Ellerholzdamm'))

order by name
