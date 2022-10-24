select
AL.Type, 
Year(AL.Created) 'Year',
DATEPART(isoWK,Al.Created) as 'Week', 
Al.Created, 
Al.[Location],
Country.Content as Country, 
Al.bin as Target,
AL.Shipment,
 ISNULL(HU.Code,LP.CODE) Code,
 case when AL.Entity = 'LP' then 'Loseteil' else ISNULL(HUT.Text,TYP.Code) end as HandlingUnitTyp,
 HU.Collinumber,
 ISNULL(HU.Length/10.0, LP.Length/10.0) 'Length',
 ISNULL(HU.Width/10.0,LP.Width/10.0) 'Width',
 ISNULL(HU.Height/10.0,LP.Height/10.0) 'Height',
 ISNULL(HU.Netto,LP.Weight) 'Netto',
 ISNULL(HU.Brutto,LP.Weight) 'Brutto' ,
 Dimensions.Project, 
 Dimensions.[Order], 
 Dimensions.Commission,
U.FirstName+' '+U.LastName as CreatedBy 
 from (
select 'HU' as Entity, HandlingUnitId,'Movement' as Type, DATA.Created, L.Name Location, B.Code Bin, '' as 'Shipment' FROM
(
select 
MIN(WE.Created) as Created,
WE.HandlingUnitId,
WE.LocationId,
WE.BinId

from WarehouseEntry WE WITH (NOLOCK)
inner join BusinessUnitPermission BUP on BUP.HandlingUnitId = WE.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.name in ('KRONES GLOBAL')
inner join [Location] L on WE.LocationId = L.id and WE.QuantityBase > 0
inner join BusinessUnitPermission BUL on L.id = BUL.LocationId and BUL.BusinessUnitId =  '22acd076-0417-4ee5-a369-f4f0a767416d'

group by 

WE.HandlingUnitId,
WE.LocationId,
WE.BinId
) DATA
inner join [Location] L on DATA.LocationId = L.Id
left join Bin B on DATA.BinId = B.id


union

select 'HU' as Entity,SL.HandlingUnitId, Case SH.[Type] when 0 then 'Loading' else 'Unloading' end as Type,REL.Released, Lfrom.Name, SH.ToAddressName, SH.Code as 'Shipment' FROM
 ShipmentLine SL WITH (NOLOCK)
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id
inner join BusinessUnitPermission BUP on BUP.HandlingUnitId = SL.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.name in ('KRONES GLOBAL')
left join [Location] Lto on SH.ToLocationId = Lto.id
left join [Location] Lfrom on SH.FromLocationId = Lfrom.id

inner join (
Select min(WFE.Created) as Released,WFE.EntityId 
from WorkflowEntry WFE where WFE.StatusId = 'd5f9a11d-d822-4a71-9366-898dc40b1bee'
group by Wfe.EntityId) REL on SH.id = REL.EntityId

where SL.[Status] <> 0
and (
Lfrom.id in (Select LocationId from BusinessUnitPermission BUP where BUP.BusinessUnitId = '22acd076-0417-4ee5-a369-f4f0a767416d'  group by LocationId) 
OR
Lto.id in (Select LocationId from BusinessUnitPermission BUP where BUP.BusinessUnitId = '22acd076-0417-4ee5-a369-f4f0a767416d' group by LocationId) 
)

union

select 'LP' as Entity,SL.LoosePartId, Case SH.[Type] when 0 then 'Loading' else 'Unloading' end as Type,REL.Released, Lfrom.Name, SH.ToAddressName, SH.Code as 'Shipment' FROM
 ShipmentLine SL WITH (NOLOCK)
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id
inner join BusinessUnitPermission BUP on BUP.LoosePartId = SL.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.name in ('KRONES GLOBAL')
left join [Location] Lto on SH.ToLocationId = Lto.id
left join [Location] Lfrom on SH.FromLocationId = Lfrom.id

inner join (
Select min(WFE.Created) as Released, WFE.EntityId 
from WorkflowEntry WFE WITH (NOLOCK) where WFE.StatusId = 'd5f9a11d-d822-4a71-9366-898dc40b1bee'
group by Wfe.EntityId) REL on SH.id = REL.EntityId

where SL.[Status] <> 0
and (
Lfrom.id in (Select LocationId from BusinessUnitPermission BUP where BUP.BusinessUnitId = '22acd076-0417-4ee5-a369-f4f0a767416d' group by LocationId) 
OR
Lto.id in (Select LocationId from BusinessUnitPermission BUP where BUP.BusinessUnitId = '22acd076-0417-4ee5-a369-f4f0a767416d' group by LocationId) 
)


) AL 

LEFT join HandlingUnit HU on Al.HandlingUnitId = HU.id
LEFT join Loosepart LP on Al.HandlingUnitId = LP.id
LEFT join [User] U on ISNULL(LP.CreatedById,HU.CreatedById) =U.Id
left join HandlingUnitType TYP on HU.TypeId = TYP.Id
left join Translation HUT on HU.TypeId = HUT.EntityId and HUT.[Language] = 'de' and HUT.[Column] = 'Code'
--dimensions
left join  (
select D.name,DV.Content as Content, edvr.EntityId from DimensionValue DV WITH (NOLOCK)
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join DimensionField DF on D.id = DF.DimensionId

where D.name in ('Project','Order','Commission')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions on HandlingUnitId = Dimensions.EntityId


left join (select EDVR.EntityId,DFV.Content from DimensionField DF 
inner join DimensionFieldValue DFV on DF.id = DFV.DimensionFieldId
inner join DimensionValue DV on DFV.DimensionValueId = DV.Id
inner join EntityDimensionValueRelation EDVR on DV.id = EDVR.DimensionValueId 
where Name = 'GRAddressCountry' and DF.ClientBusinessUnitId = (select id from BusinessUnit where Name = 'KRONES GLOBAL')) Country on AL.HandlingUnitId = Country.EntityId


WHERE cast(Al.Created as date) between '2021-07-01' and '2021-07-09' --$P{FromDate} and  $P{ToDate}