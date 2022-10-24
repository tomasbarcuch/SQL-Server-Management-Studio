select 
U.created,
U.Login 'User', 
Role.name Role,
--'Krones AG' as ClientBusinessUnit,
--'Deufol Hamburg Rosshafen' BusinessUnit,
BUC.name as SourceClient,
BU.name as SourceBusinessUnit
 from UserRole UR
inner join [User] U on UR.UserId = U.Id
inner join Role on UR.RoleId = Role.id
inner join BusinessUnit BUC on UR.ClientBusinessUnitId = BUC.id
inner join BusinessUnit BU on UR.BusinessUnitId = BU.id
where clientbusinessunitid =
(select id from BusinessUnit where name = 'Krones AG')
and BusinessUnitId = 
(select id from BusinessUnit where name = 'Krones AG')
order by u.login



select UR.ID,
BU.Name, BUrel.name 
from userrole UR
left join BusinessUnit BU on UR.ClientBusinessUnitId = BU.Id
left join BusinessUnit BUrel on UR.BusinessUnitId = BUrel.Id
left join businessunitrelation BUR on UR.BusinessUnitId = BUR.RelatedBusinessUnitId and UR.ClientBusinessUnitId = BUR.BusinessUnitId

where 
BUrel.name is not null 

