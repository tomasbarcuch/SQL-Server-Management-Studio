select
isnull(R.name,'not assigned') as Role,
P.name as Permission
--isnull(CS.Text,P.name) as Oprávnění,
--isnull(EN.Text,P.name) as Permission,
--isnull(DE.Text,P.name) as Berechtigung,
--isnull(RCS.Text,R.name) as Role_cs,
--isnull(REN.Text,R.name) as Role_en,
--isnull(RDE.Text,R.name) as Role_de,
--isnull(R.name,'not assigned') as Role,
--1 as assigned
from permission P 
LEFT JOIN rolepermission RP on P.id = rp.permissionid

left join Translation CS on P.id = CS.EntityId and CS.language = 'cs' and CS.[Column] = 'Code'
left join Translation DE on P.id = DE.EntityId and DE.language = 'de' and DE.[Column] = 'Code'
left join Translation EN on P.id = EN.EntityId and EN.language = 'en' and EN.[Column] = 'Code'
left join role R on RP.roleid = R.id
left join Translation RCS on R.id = RCS.EntityId and RCS.language = 'cs' and RCS.[Column] = 'Code'
left join Translation RDE on R.id = RDE.EntityId and RDE.language = 'de' and RDE.[Column] = 'Code'
left join Translation REN on R.id = REN.EntityId and REN.language = 'en' and REN.[Column] = 'Code'

--new Permission not assigned to rolle
select  R.Name as Role, P.Name as Permission from Permission P
left join RolePermission RP on P.ID = RP.PermissionId
left join role R on 0=0

where RP.ID is null


--select * from role