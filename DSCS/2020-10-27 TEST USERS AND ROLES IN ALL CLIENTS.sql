select 
BU.name  BusinessUnit,
CU.Name ClientBusinessUnit,
U.[Login] 'User',
Role.Name Role
from 
BusinessUnitRelation BUR
inner join BusinessUnit BU on BUR.RelatedBusinessUnitId = BU.Id and BU.[Disabled] = 0
inner join BusinessUnit CU on BUR.BusinessUnitId = CU.Id and CU.[Disabled] = 0

join(
select name from Role where name in (
    'Dispatcher',
'Teamleader',
'KeyUser',
'Accounting',
'Trainee',
'Administrator',
'Manager',
'OSL Teamleader',
'Viewer',
'Project Handling',
'User',
'Supplier',
'Warehouse operator',
'OSL Manager',
'OSL User',
'Packer',
'Painter'
)) role on 0=0
left join [User] u on role.name = U.LastName and U.[Login] in (
    'dispatcher',
'teamleader',
'keyuser',
'accounting',
'trainee',
'administrator',
'manager',
'osl.teamleader',
'viewer',
'project.handling',
'user',
'supplier',
'warehouse.operator',
'osl.manager',
'osl.user',
'packer',
'painter'
)
where BU.name <> CU.name