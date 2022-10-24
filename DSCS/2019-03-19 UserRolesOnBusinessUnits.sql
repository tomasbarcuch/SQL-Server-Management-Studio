select
BU.name as BusimessUnit,
Client.name as client, 
U.LOGIN,
R.Name as Role
from UserRole UR
inner join [User] U on UR.UserId = U.Id
inner join BusinessUnit BU on UR.BusinessUnitId = BU.Id
inner join BusinessUnit Client on UR.ClientBusinessUnitId = Client.Id
inner join Role R on UR.RoleId = R.Id

--where BU.Name = 'Deufol Hamburg Rosshafen'
where Client.Name = 'Dürr Ecoclean '