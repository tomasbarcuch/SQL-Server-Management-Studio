select
case BU.TYPE
when 0 then 'Packer'
when 2 then 'Client'
else '1' end as BU,
BU.name,
L.code as Location,
case permissiontype 
when 1 then 'read/write'
when 2 then 'read' else '0' end as PermissionType
 from BusinessUnitPermission  BUP
inner join location L on BUP.LocationId = L.Id
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
