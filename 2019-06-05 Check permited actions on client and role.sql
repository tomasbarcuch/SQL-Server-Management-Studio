select 
R.name,
A.Code,
A.[Description],
P.Name 
from BCSActionPermission BCSAP
inner join BCSAction A on BCSAP.ActionId = A.id
inner join Permission P on BCSAP.PermissionId = P.Id
inner join RolePermission RP on P.id = RP.PermissionId
inner join Role R on RP.RoleId = R.Id and R.Name = 'Packer Krones'
where  BCSAP.clientBusinessUnitId = (select id from BusinessUnit where name = 'Krones AG VV')
