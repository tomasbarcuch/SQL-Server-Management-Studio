
declare @ID as UNIQUEIDENTIFIER
set @ID = '43458a72-6712-4e2f-8b2c-d50d6646087b'

select
case HU.empty when 0 then '' else 'empty' end as empty,
HU.code,
HU.DESCRIPTION, 
isnull(T.Text,S.name) as current_status,
HU.updated last_change,
U.login last_change_by,
isnull(L.Code,'') actual_location,
isnull(Z.name,'') actual_zone,
isnull(B.Code,'') actual_bin,
isnull(HU.Code,'loose') actual_hu,
cast(da.created as date) as day,
BU.name as actual_BU,
da.* from (
select max(isnull(BU,'')) as BU,HandlingUnitId,max(Location) location, Max(Zone) Zone,max( Bin) Bin, max(isnull(Status,'')) Status, max(isnull(hu,'')) hu, max(isnull(lp,'')) lp, created, max(login) Login from (
select null as BU, HandlingUnitId,isnull(L.code,'') Location,isnull(Z.Name,'') Zone, isnull(B.code,'') bin, null as status, HU.code hu, LP.code as LP, convert(VARCHAR,WE.created,120) created, U.login from WarehouseEntry WE  with (NoLock)
left join LOCATION L on WE.locationID = L.id
left join Zone Z on WE.ZoneID = Z.id
left join HandlingUnit HU on WE.Parenthandlingunitid = HU.id
left join LoosePart LP on WE.LoosepartId = LP.id
left join Bin B on WE.BinID = B.id
inner join [USER] U on WE.createdById = U.id
where handlingunitid = @ID and WE.quantity > 0

union

select BU.name,WFE.entityid as handlingunitid,'','','',isnull(T.Text,S.name) as name, null, null,convert(VARCHAR,WFE.created,120) created,U.login from WorkflowEntry WFE
inner join status S on WFE.statusid = S.id
left join Translation T on S.id = T.entityId and T.language = 'en'
inner join [USER] U on WFE.createdById = U.id
left join BusinessUnit Bu on WFE.BusinessUnitID = BU.id


where WFE.EntityId = @ID
) data
group by data.created,data.HandlingUnitId
) da
inner join HandlingUnit HU on da.HandlingUnitid = HU.id
inner join status S on HU.statusid = S.id
left join Translation T on S.id = T.entityId and T.language = 'en'
inner join [USER] U on HU.updatedById = U.id
left join LOCATION L on HU.ActuallocationID = L.id
left join Zone Z on HU.ActualZoneID = Z.id
left join Bin B on HU.ActualBinID = B.id
left join HandlingUnit TOPHU on HU.Tophandlingunitid = TOPHU.id
inner join businessunitpermission BUP on HU.id = BUP.HAndlingUnitid
inner join BusinessUnit BU on BUP.BusinessUnitID = BU.id and BU.type = 2

order by da.created
