

declare @ID as UNIQUEIDENTIFIER
set @ID = '39638aa5-a173-474a-b1bd-93ee7105ff91'

select
 
LP.code,
LP.DESCRIPTION, 
isnull(T.Text,S.name) as current_status,
LP.updated last_change,
U.login last_change_by,
isnull(L.Code,'') actual_location,
isnull(Z.name,'') actual_zone,
isnull(B.Code,'') actual_bin,
isnull(HU.Code,'loose') actual_hu,
cast(da.created as date) as day,
BU.name as actual_BU,
da.* from (
select max(isnull(BU,'')) as BU,LoosepartId,max(Location) location, Max(Zone) Zone,max( Bin) Bin, max(isnull(Status,'')) Status, max(isnull(hu,'')) hu, created, max(login) Login from (
select null as BU, LoosepartId,isnull(L.code,'') Location,isnull(Z.Name,'') Zone, isnull(B.code,'') bin, null as status, HU.code hu,convert(VARCHAR,WE.created,120) created, U.login from WarehouseEntry WE
left join LOCATION L on WE.locationID = L.id
left join Zone Z on WE.ZoneID = Z.id
left join HandlingUnit HU on WE.handlingunitid = HU.id
left join Bin B on WE.BinID = B.id
inner join [USER] U on WE.createdById = U.id
where LoosepartId = @ID and WE.quantity > 0

union

select BU.name,WFE.entityid as loosepartid,'','','',isnull(T.Text,S.name) as name, null,convert(VARCHAR,WFE.created,120) created,U.login from WorkflowEntry WFE
inner join status S on WFE.statusid = S.id
left join Translation T on S.id = T.entityId and T.language = 'en'
inner join [USER] U on WFE.createdById = U.id
left join BusinessUnit Bu on WFE.BusinessUnitID = BU.id


where WFE.EntityId = @ID
) data
group by data.created,data.loosepartid
) da
inner join loosepart LP on da.Loosepartid = LP.id
inner join status S on LP.statusid = S.id
left join Translation T on S.id = T.entityId and T.language = 'en'
inner join [USER] U on LP.updatedById = U.id
left join LOCATION L on LP.ActuallocationID = L.id
left join Zone Z on LP.ActualZoneID = Z.id
left join Bin B on LP.ActualBinID = B.id
left join HandlingUnit HU on LP.Tophandlingunitid = HU.id
inner join businessunitpermission BUP on LP.id = BUP.loosepartid
inner join BusinessUnit BU on BUP.BusinessUnitID = BU.id and BU.type = 2

order by da.created




/*
select * from BCSLog where EntityId = @ID
select * from LogEntity where EntityId = @ID
*/



