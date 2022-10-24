
select 
U.[Login]
--, P.Name
, R.Name
 from RolePermission RP
inner join UserRole UR on RP.RoleId = UR.RoleId
inner join [User] U on UR.UserId = U.Id and U.[Disabled] = 0
inner join Permission P on RP.PermissionId = P.Id
Inner join Role R on UR.RoleId = R.Id and R.Name <> 'Administrator'
where RP.PermissionId in (
select id from Permission where name in 
(
    'DimensionValue_Import_Krones',
    'LoosePart_Import_Krones'
    --'InboundSuppliers_BCSAction_1'
))

group by 
U.[Login]

, R.Name