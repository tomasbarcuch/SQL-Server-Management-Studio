select BUP.BusinessUnitId as clientbusinessUnitID,
* from Bin 
left outer join BusinessUnitPermission BUP on bin.id = BUP.BinId

where bin.[Disabled] = 0

select 
DB_NAME() AS 'Current Database',
B.Code,
BUP.BusinessUnitId as ClientBusinessUnitId,
B.[Disabled],
B.ZoneId,
Z.Name as Zone,
B.LocationId,
L.Name as Location,
B.[Description],
BU.Name as Client

from [Bin] B
left outer join BusinessUnitPermission BUP on B.id = BUP.BinId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
inner join [Location] L on B.LocationId = L.Id
LEFT outer join zone Z on B.ZoneId = Z.Id

where 
--B.ClientBusinessUnitId =  $P{ClientBUid} 
--and  $X{IN,B.id,BinID} and
B.[Disabled] = 0 and L.[Disabled] = 0
