declare @Packer as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')
declare @Client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'KRONES GLOBAL')

declare @Packer2 as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Berlin')
declare @Client2 as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Siemens Berlin')

declare @Packer3 as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Nürnberg')
declare @Client3 as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Siemens Nürnberg')

select 
CU.Name as ClientBusinessUnit,
BU.name  BusinessUnit,
U.Login as [User],
R.Name 'Role'

from 
UserRole UR

inner join BusinessUnit BU on BU.Id = UR.BusinessUnitId -- and BU.Id = @Packer
inner join BusinessUnit CU on CU.Id = UR.ClientBusinessUnitId and CU.id = @Client
inner join [User] U on UR.UserId = U.Id
inner join Role R on UR.RoleId = R.Id

UNION

select 
CU.Name as ClientBusinessUnit,
BU.name  BusinessUnit,
U.Login as [User],
R.Name 'Role'

from 
UserRole UR

inner join BusinessUnit BU on BU.Id = UR.BusinessUnitId -- and BU.Id = @Packer2
inner join BusinessUnit CU on CU.Id = UR.ClientBusinessUnitId and CU.id = @Client2
inner join [User] U on UR.UserId = U.Id
inner join Role R on UR.RoleId = R.Id

UNION

select 
CU.Name as ClientBusinessUnit,
BU.name  BusinessUnit,
U.Login as [User],
R.Name 'Role'

from 
UserRole UR

inner join BusinessUnit BU on BU.Id = UR.BusinessUnitId -- and BU.Id = @Packer3
inner join BusinessUnit CU on CU.Id = UR.ClientBusinessUnitId and CU.id = @Client3
inner join [User] U on UR.UserId = U.Id
inner join Role R on UR.RoleId = R.Id

