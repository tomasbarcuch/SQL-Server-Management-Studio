SELECT
U.login,
U.LastName+' '+U.FirstName as Username,
R.name Role,
R.Description As RoleDesc,
U.email,
IsAdmin,
P.name PermName,
BUclient.name as BUClient,
BU.name as BU,
case bu.type
when 0 then 'Packer'
when 1 then 'Customer'
when 2 then 'Client'
when 3 then 'Vendor'
else '' end as BUType,
L.code
 FROM dbo.[User] U
 
right join [UserRole] UR on U.id = UR.UserId
right join Role R on UR.RoleId = R.Id
right join RolePermission RP on R.id = RP.RoleId
right join Permission P on RP.PermissionId = P.Id
right join BusinessUnit BUclient on ur.ClientBusinessUnitId = BUclient.Id
right join BusinessUnit BU on ur.BusinessUnitId = BU.id
right join BusinessUnitPermission BUP on BU.id = BUP.BusinessUnitId and BUP.LocationId is not null
right join Location L on BUP.LocationId = L.id

where u.[Disabled] = 0 and u.PasswordHash is null

and BUclient.name = 'Krones AG'