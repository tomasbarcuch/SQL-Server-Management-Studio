select 
DB_NAME() AS 'Current Database',
B.Code,
b.ClientBusinessUnitId,
B.[Disabled],
B.ZoneId,
Z.Name as Zone,
B.LocationId,
L.Name as Location,
B.[Description],
BU.Name as Client

from [Bin] B

inner join BusinessUnit BU on B.ClientBusinessUnitId = BU.Id
inner join [Location] L on B.LocationId = L.Id
LEFT outer join zone Z on B.ZoneId = Z.Id

--where B.ClientBusinessUnitId =  $P{ClientBUid} and  $X{IN,B.id,BinID}
where b.ClientBusinessUnitId = 'bb81845e-67ba-4497-b849-7228ea32c38c'
and B.[Disabled] = 0 and L.[Disabled] = 0


