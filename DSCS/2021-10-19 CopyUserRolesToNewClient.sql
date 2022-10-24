declare @packer as UNIQUEIDENTIFIER = (Select id from BusinessUnit where Name = 'Deufol Hub Antwerp')
declare @client as UNIQUEIDENTIFIER = (Select id from BusinessUnit where Name = 'Versalis')
declare @newClient as UNIQUEIDENTIFIER = (Select id from BusinessUnit where Name = 'Deufol Hamburg Rosshafen')

SELECT
U.LOGIN as 'User',
R.name Role,
ClientBusinessUnit = (select name from BusinessUnit where id =  @newClient),
BU.name as BusinessUnit,
BUclient.name as SourceClientBusinessUnit
 FROM dbo.[User] U
 
right join [UserRole] UR on U.id = UR.UserId
right join Role R on UR.RoleId = R.Id
--right join RolePermission RP on R.id = RP.RoleId
--right join Permission P on RP.PermissionId = P.Id
right join BusinessUnit BUclient on ur.ClientBusinessUnitId = BUclient.Id
right join BusinessUnit BU on ur.BusinessUnitId = BU.id

where BU.Id = @packer and BUclient.Id = @client and U.[Disabled] = 0 and U.IsAdmin = 0 and U.AuthType = 0




SELECT
'devrim.fidan' as 'User',
Role = (select name from Role where name = 'Project Handling'),
Client.Name ClientBusinessUnit,
BU.name as BusinessUnit

from BusinessUnitRelation BUR

inner join BusinessUnit BU on BUR.RelatedBusinessUnitId = BU.Id and BU.id = @newClient
inner join BusinessUnit Client on BUR.BusinessUnitId = Client.Id and Client.[Disabled] = 0

 