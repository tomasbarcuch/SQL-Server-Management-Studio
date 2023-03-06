begin TRANSACTION
--insert into RolePermission
select  
NEWID()
,R.Id RoleId
,P.Id PermissionId
,[CreatedById] = (select id from [User] where login = 'tomas.barcuch')
,[UpdatedById] = (select id from [User] where login = 'tomas.barcuch')
,GETUTCDATE() [Created]
,GETUTCDATE() [Updated]
 from (
select 
substring([Message],20,8) DocumentName,
--substring([Message],42,PATINDEX ( '%"%' , substring([Message],42,250) )-1) BusinessUnit,
--replace(substring([Message],PATINDEX('%for%',[Message])+5,250),'"','') ClientBusinessUnit,
[UserName]


from Log4Net

where message like 'Document Template%'
) DATA
--INNER join BusinessUnit BU on DATA.BusinessUnit = BU.Name
--INNER join BusinessUnit CLIENT on DATA.BusinessUnit = CLIENT.name
--INNER join DocumentTemplate DT on DATA.DocumentName = DT.Name
INNER JOIN [User] U On DATA.UserName = U.[Login]
inner join UserRole UR on U.Id = UR.UserId  
--and UR.ClientBusinessUnitId = CLIENT.id 
--and UR.BusinessUnitId = BU.Id

INNER JOIN Role R on UR.RoleId = R.Id and R.Name not in (
  'Permissions' ,'Import Krones','PackingRulesUpdate','PackingOrderDisconnect','Dimensions','Import Siemens Berlin','Import Siemens Nürnberg'
)
inner join Permission P on DATA.DocumentName = left(P.Name,8)
group by R.Id
,P.Id

ROLLBACK