select U.login, BU.name from (
select U.id
from userrole UR 
inner join [User] U on UR.UserId = U.Id and U.IsAdmin = 'False'
inner join BusinessUnit BU on UR.BusinessUnitId = BU.id and bu.[Type] = 0 and BU.[Disabled] = 0 and BU.Name not like '%DEMO%'
where 
U.DISABLED = 0 and 
email not in ('novalid@deufol.com')
and u.login not like '%test%'
group by U.id
having  count(distinct BU.name) > 1) USERS
inner join [User] U on Users.id = u.id
inner join UserRole UR on USERS.Id = UR.UserId
inner join BusinessUnit BU on UR.BusinessUnitId = BU.id and bu.[Type] = 0 and BU.[Disabled] = 0 and BU.Name not like '%DEMO%'
group by U.login, BU.name

