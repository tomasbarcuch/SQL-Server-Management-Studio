select 
LF.Name,
SH.[Type],
sh.FromLocationId,
sh.DeliveryDate,
ord.OrderNr,
Commission.CommissionNr,
SH.code as Shipment,
ENT.ColliNumber,
ENT.Code,
ENT.id,
ENTCF.TypeOfHU,
HUT.[Description] ContainerTyp,
ENT.Length, 
ENT.Width,
ENT.Height,
ENT.Brutto,
Ent.Netto,
ENT.weight,
ENT.Surface,
ENT.BaseArea,
ENT.Volume,
case ENTCF.TypeOfHU
when 'Kiste' then 'Aussen-qm'
when 'Podest' then 'Boden-qm'
when 'unverpackt' then 'Boden-qm'
when 'OSB-Kiste' then 'Aussen-qm'
when 'Karton' then 'Aussen-qm'
when 'auf Bohlen' then 'Boden-qm'
when 'Palette' then 'Boden-qm'
when 'Gitterbox' then 'Boden-qm'
else ENTCF.TypeOfHU+' nicht definiert' end as 'Invocing',
case ENTCF.TypeOfHU
when 'Kiste' then 2.35
when 'OSB-Kiste' then 2.35
when 'Karton' then 2.35
else 8.20 end as 'PriceUnit',
case ENTCF.TypeOfHU
when 'Kiste' then 2.35*Surface
when 'OSB-Kiste' then 2.35*Surface
when 'Karton' then 2.35*Surface
else 8.20*BaseArea end as 'Price'


from ShipmentLine SL
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.id
inner join 
( SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled]  FROM HandlingUnit
UNION
SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,null,null,null,null,null,null,null,null,null,null,null,null  FROM LoosePart)
ENT on isnull(sl.HandlingUnitId,sl.LoosePartId) = ENT.ID

left join HandlingUnitType HUT on SH.HandlingUnitTypeId = HUT.id
inner join BusinessUnitPermission BUP on SL.Id = BUP.ShipmentLineId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG VV')
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
inner join [Location] LF on SH.FromLocationId = LF.Id

left join  (
select
DV.Content 'OrderNr',
DV.[Description] 'Order', 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Order'
where 
DF.name in ('Comments','DateOfPlannedDeliveryToCustomer'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Comments],[DateOfPlannedDeliveryToCustomer])) as Ord on isnull(sl.HandlingUnitId, sl.LoosePartId) = ord.EntityId

left join (
select
DV.Content CommissionNr,
DV.[Description] Commission, 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Commission'
where 
DF.name in ('Plant','Comments','OrderPosition','Network'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network])) as Commission on isnull(sl.HandlingUnitId, sl.LoosePartId) = Commission.EntityId



left join (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('TypeOfHU') --and CV.Entity = 11
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([TypeOfHU])
        ) as ENTCF on ENT.id = ENTCF.EntityID

        --where sh.DeliveryDate between '2019-07-01' and '2019-07-31'
        where  sh.[Type] = 0 -- loading
        --and sh.code = '-2117-1450S-258358'
      