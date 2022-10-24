
declare @pID as UNIQUEIDENTIFIER
set @pID = '8c17629d-3d2e-439d-af09-d7750ad20f14'

--set @ID = '422c1626-80de-4538-bfd8-bd8031adca2a'

select

case HU.empty when 0 then '' else 'empty' end as empty,
isnull(HU.Collinumber,Hu.Code) code,
HU.DESCRIPTION, 
isnull(T.Text,S.name) as current_status,
HU.updated last_change,
U.login last_change_by,
isnull(L.Code,'') actual_location,
isnull(Z.name,'') actual_zone,
isnull(B.Code,'') actual_bin,
isnull(isnull(HU.Collinumber,Hu.Code),'loose') actual_hu,
cast(da.created as datetime) as day,
BU.name as actual_BU,
da.* from (
select max(isnull(BU,'')) as BU,ParentHandlingUnitId,max(Location) location, Max(Zone) Zone,max( Bin) Bin, max(isnull(Status,'')) Status, 
--max (isnull(hu,'')) hu, 
isnull(lp,'') lp, --for every packed LP
--count(lp) lp,--for summary of packed LPs
cast(created as datetime) as created, max(login) Login, origin from (
select null as BU, WE.ParentHandlingUnitId,isnull(L.code,'') Location,isnull(Z.Name,'') Zone, isnull(B.code,'') bin, null as status, isnull(HU.Collinumber,Hu.Code)  hu, LP.code as LP,
-- convert(VARCHAR,WE.created,120) created, 
WE.created,
 U.login, 'WHE' as origin from WarehouseEntry WE  with (NoLock)
left join LOCATION L on WE.locationID = L.id
left join Zone Z on WE.ZoneID = Z.id
left join HandlingUnit HU on WE.handlingunitid = HU.id
left join LoosePart LP on HU.id = LP.ActualHandlingUnitId 
left join Bin B on WE.BinID = B.id
inner join [USER] U on WE.createdById = U.id
where we.parenthandlingunitid =  '772f4586-9d64-4417-aa02-ef24bdbeeab8' and WE.quantity > 0

union

select BU.name,WFE.entityid as parenthandlingunitid,'','','',isnull(T.Text,S.name) as name, null, null,WFE.created,U.login, 'WFE' as origin from WorkflowEntry WFE
inner join status S on WFE.statusid = S.id
left join Translation T on S.id = T.entityId and T.language = 'en'
inner join [USER] U on WFE.createdById = U.id
left join BusinessUnit Bu on WFE.BusinessUnitID = BU.id


where WFE.EntityId =  '772f4586-9d64-4417-aa02-ef24bdbeeab8' --$P{handlingunitid}
) data
group by data.created,data.ParentHandlingUnitId, origin, data.lp --for summary of packed LPs

) da 
inner join HandlingUnit HU on da.ParentHandlingUnitid = HU.id
inner join status S on HU.statusid = S.id
left join Translation T on S.id = T.entityId and T.language = 'en'
inner join [USER] U on HU.updatedById = U.id
left join LOCATION L on HU.ActuallocationID = L.id
left join Zone Z on HU.ActualZoneID = Z.id
left join Bin B on HU.ActualBinID = B.id
left join HandlingUnit TOPHU on HU.Tophandlingunitid = TOPHU.id
inner join handlingunittype HUT on HU.typeid = HUT.id and HUT.container = 1
inner join businessunitpermission BUP on HU.id = BUP.HandlingUnitid
inner join BusinessUnit BU on BUP.BusinessUnitID = BU.id and BU.type = 2

order by da.created
