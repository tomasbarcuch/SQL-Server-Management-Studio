select
T.Text as Status,
HU.code HuCode, 
isnull(HU.SerialNo,'') as SerialNo,
HU.ColliNumber,
HUT.Code HuType,
--HUT.[Description],
case when SH.code is not null and HU.ActualLocationId is null and HU.StatusId not in (select id from [Status] where name = 'HuOverhanded') then 'on SHIPMENT to' else '' end as comment,
isnull(L.code,SHLoc.Code) as Location,
--isnull(L.Description,SHLoc.[Description]) as LocDescription,
isnull(Z.name,'') as Zone,
isnull(B.code,'') as Bin,
case when sh.StatusId not in (select id from status where name = 'SpUnloaded') then isnull(SH.Code,'') else '' end as Shipment,
isnull(TSH.text,'') as ShipmentStatus
--,SH.DeliveryDate
,Dimensions.Project as ProjectNr
,Dimensions.[Order] as OrderNr
from HandlingUnit HU WITH (NOLOCK)
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.Name = 'Krones AG'
inner join status S on HU.statusid = S.id
left join Translation T on S.id = T.entityId and T.language = 'en'
left join HandlingUnitType HUT on HU.typeid = HUT.Id
left join [Location] L on HU.ActualLocationId = L.id
left join Zone Z on HU.ActualZoneId = Z.id
left join bin B on HU.ActualBinId = B.id


left join (select * from (
SELECT SL.ShipmentHeaderId,SL.id SLID, SL.handlingUnitId,sl.updated,
max(sl.updated) OVER (PARTITION BY SL.handlingUnitId) AS updat
from ShipmentLine SL WITH (NOLOCK)
) sls
where updat = Updated) Lines on HU.ID = Lines.handlingUnitId
left join ShipmentHeader SH on Lines.ShipmentHeaderId = SH.Id
left join status SSH on SH.statusid = SSH.id and SH.StatusId not in (select id from status where name = 'SpUnloaded')
left join Translation TSH on SSH.id = TSH.entityId and TSH.language = 'en'
left join [Location] SHLoc on SH.ToLocationId = SHloc.Id

 inner join (
select D.name, DV.Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order','Commission')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions on Hu.id = Dimensions.EntityId
      
        
where
Dimensions.Project = 'VT00078220'--$P{Project} 
and HU.ParentHandlingUnitId is null
and S.name <> 'Canceled'
--and HU.Code = 'HUKR-000682'