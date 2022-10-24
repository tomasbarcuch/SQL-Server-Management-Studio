declare @client as UNIQUEIDENTIFIER = (select id from [BusinessUnit] where name = 'Krones AG')
declare @packer as UNIQUEIDENTIFIER = (select id from [BusinessUnit] where name = 'Deufol Untermarchenbach')
--declare @user as UNIQUEIDENTIFIER = (select id from [User] where login = 'kata.dupai')
--declare @user as UNIQUEIDENTIFIER = (select id from [User] where login = 'matthias.eisenreich')
declare @user as UNIQUEIDENTIFIER = (select id from [User] where login = 'melanie.lang')
--declare @user as UNIQUEIDENTIFIER = (select id from [User] where login = 'tomas.barcuch')
--declare @user as UNIQUEIDENTIFIER = (select id from [User] where login = 'srboljub.kostic')

select 
Packer.name Packer
,Packer.Id as BusinessUnitId
,Client.name Client
,Client.Id as ClientBusinessUnitId
    ,U.[Login]
      ,[U].[FirstName]
      ,[U].[LastName]
      ,[U].[Email]
      ,[U].[BCSLoginCode]
      ,BA.Code
      ,isnull(T.text,BA.[Description]) as DESCRIPTION
      ,R.name  
      ,'$NOBIN$' as Nobin
       from BCSAction BCS
inner join BusinessUnitPermission BUP on BCS.Id = BUP.BCSActionId and BUP.BusinessUnitId = @client
inner join BusinessUnit Client on BUP.BusinessUnitId = Client.Id
inner join BCSActionPermission BAP on BCS.id = BAP.ActionId and BAP.ClientBusinessUnitId = @client --$P{ClientBusinessUnitId} 
inner join BCSAction BA on BAP.ActionId = BA.Id
inner join (select RoleId,PermissionId from RolePermission UNION select '00000000-0000-0000-0000-000000000000', Id from Permission) RP on BAP.PermissionId = RP.PermissionId
inner join (select Id RoleId, 0 as isadmin, R.Name from Role R union select '00000000-0000-0000-0000-000000000000', 1 isadmin, 'Admin' from Role) R on RP.RoleId = R.RoleId
inner join (select userid, BusinessUnitId,ClientBusinessUnitId,RoleId from UserRole where ClientBusinessUnitId = @client and (BusinessUnitId = @packer or BusinessUnitId = @client) and userid = @user
union
select  id, BU.BusinessUnitID, BU.ClientBusinessUnitId, '00000000-0000-0000-0000-000000000000' RoleID from [User] U 
left join (select '00000000-0000-0000-0000-000000000000' RoleID,BusinessUnitId as ClientBusinessUnitId, RelatedBusinessUnitId as BusinessUnitID from BusinessUnitRelation where BusinessUnitId = @client
union select '00000000-0000-0000-0000-000000000000' RoleID,@client  ClientBusinessUnitId, @client as BusinessUnitID from BusinessUnit where Id = @client
 ) BU on '00000000-0000-0000-0000-000000000000' = BU.RoleID where isadmin = 1 and [Disabled] = 0 and id = @user and BusinessUnitID = @packer) UR on R.RoleId = UR.RoleId  --$P{UserId} 
inner join [User] U on UR.UserId =  @user
left join Translation T on BA.Id = T.EntityId and T.[Column] = 'Description' and T.[Language] = 'de'

left join BusinessUnit Packer on UR.BusinessUnitId = Packer.id

where U.id = @user

and Client.[Disabled] = 0



select

      L.Code as  Location

 from BusinessUnit BU

inner join BusinessUnitPermission BUP on BU.Id = BUP.BusinessUnitId and BUP.LocationId is not null
inner join [Location] L on BUP.LocationId = L.Id


where BU.id = @Client