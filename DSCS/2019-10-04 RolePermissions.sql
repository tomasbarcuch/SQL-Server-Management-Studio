select
U.[Login] [User]
,Client.Name [ClientBusinessUnit]
,Packer.Name [BusinessUnit]
,R.Name [Role]
 
from UserRole UR
inner Join [User] U on UR.UserId = U.Id
Inner join BusinessUnit Client on UR.ClientBusinessUnitId = Client.Id
Inner join BusinessUnit Packer on UR.BusinessUnitId = Packer.Id
inner join Role R on UR.RoleId = R.Id
where ClientBusinessUnitId = (Select id from BusinessUnit where Name = 'BASIS  Client')
