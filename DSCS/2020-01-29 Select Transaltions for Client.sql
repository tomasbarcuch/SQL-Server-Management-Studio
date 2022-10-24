
select * from Translation where EntityId in (
select S.id
from status S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'DEMO Project Client') )
order by EntityId, language




