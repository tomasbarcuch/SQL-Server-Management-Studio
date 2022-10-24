select
BUP.BusinessUnitId
,L.Id LocationID
,BU.name,
case bu.type
when 0 then 'Packer'
when 1 then 'Customer'
when 2 then 'Client'
when 3 then 'Vendor'
else '' end as BUType
,L.Code Location
,Z.name Zone
,B.code Bin
 from location L
left join Bin B on L.id = B.LocationId
left join Zone Z on L.id = Z.LocationId
inner join BusinessUnitPermission BUP on L.id = BUP.LocationId
inner join BusinessUnit BU on bup.BusinessUnitId = BU.Id
where b.[Disabled] = 0 and Z.[Disabled] = 0 and L.[Disabled] = 0