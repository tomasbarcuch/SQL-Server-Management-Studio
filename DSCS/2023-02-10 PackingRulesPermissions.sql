begin TRANSACTION

insert into UserRole
(Id,UserId,BusinessUnitId,ClientBusinessUnitId,RoleId,CreatedById,UpdatedById,Created,Updated)


Select
NEWID() Id
,UR.UserId
,UR.BusinessUnitId
,UR.ClientBusinessUnitId
,'6d05bc84-ea34-45d2-9b9f-5e73cfd29cd9' RoleId
,(Select id from [User] where login = 'tomas.barcuch') CreatedById
,(Select id from [User] where login = 'tomas.barcuch') UpdatedById
,GETDATE() Created
,GETDATE() Updated



 --U.[Login],Packer.name BusinessUnit, Client.Name ClientBusinessUnit,R.name Role, 'PackingRulesUpdate' as Role 
 
 from UserRole UR 
inner join [User] U on UR.UserId = U.Id and U.[Disabled] = 0 and U.IsAdmin = 0 and U.AuthType = 0
inner join BusinessUnit Client on UR.ClientBusinessUnitId = Client.Id and Client.[Disabled] = 0 
inner join BusinessUnit Packer on UR.BusinessUnitId = Packer.Id and Packer.[Disabled]= 0

Inner join Role R on UR.RoleId = R.Id and R.Name not in ('KeyUser','Consultant','Administrator','MasterKeyUser')

where UR.RoleId in (
select distinct RP.RoleId from RolePermission RP where RP.PermissionId in (
select P.Id from Permission P where name in ('PackingRules_Import','PackingRules_Delete','PackingRules_Add')))

group by UR.UserId
,UR.BusinessUnitId
,UR.ClientBusinessUnitId

COMMIT