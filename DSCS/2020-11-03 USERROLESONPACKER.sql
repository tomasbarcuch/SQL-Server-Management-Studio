declare @Packer as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')

select 
BU.name  BusinessUnit,
CU.Name ClientBusinessUnit,
USERS.[User],
USERS.Role
from 
BusinessUnitRelation BUR
inner join BusinessUnit BU on BUR.RelatedBusinessUnitId = BU.Id and BU.[Disabled] = 0 and BU.Id = @Packer
inner join BusinessUnit CU on BUR.BusinessUnitId = CU.Id and CU.[Disabled] = 0
left join (


select U.login 'User', R.Name Role
from [User] U
left join UserRole UR on U.id = UR.UserId and BusinessUnitId = @Packer
left join Role R on UR.RoleId = R.Id

where U.[Login] in (
'jens.ott',
'kristjan.ereiz',
'mihael.cvjetkovic',
'ricarda.kruse',
'mohammad.sahyouni',
'mohammed.gaumati',
'amin.hannouf',
'margarita.wachtel',
'roberto.imsirovic',
'robert.petreski',
'miroslav.milosevic',
'miroslav.simeunovic',
'nicole.siemers',
'volker.fisch',
'ivica.certi',
'jakov.kovacevic',
'dejan.nagy',
'richard.franik',
'nikola.matic',
'michael.melnitschenk',
'dieter.giese'
)
group by 
U.login, R.Name) USERS on 0=0