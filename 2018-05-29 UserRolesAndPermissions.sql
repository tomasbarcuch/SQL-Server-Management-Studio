select
P.name as Permission,
isnull(R.name,'not assigned') as Role,
case when p.name like '%read%' then 'read' else 
case when p.name like '%update%' then 'update' else
case when p.name like '%edit%' then 'update' else
case when p.name like '%_add%' then 'add' else
case when p.name like '%create%' then 'create' else
case when p.name like '%delete%' then 'delete' else
case when p.name like '%import%' then 'import' else
case when p.name like '%print%' then 'print' else
case when p.name like '%pack%' then 'packing' else
(substring(p.name,charindex('_',p.name)+1,20)) end end end end end end end end end as PermissionGroup,
1 as assigned

from permission P

LEFT JOIN rolepermission RP on P.id = rp.permissionid
left join role R on RP.roleid = R.id


declare @packer as UNIQUEIDENTIFIER = (Select id from BusinessUnit where Name = 'Deufol Hub Antwerp')
declare @client as UNIQUEIDENTIFIER = (Select id from BusinessUnit where Name = 'Versalis')
declare @newClient as UNIQUEIDENTIFIER = (Select id from BusinessUnit where Name = 'Diverse Clients Antwerp')

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

where BU.Id = @packer and BUclient.Id = @client and U.[Disabled] = 0
