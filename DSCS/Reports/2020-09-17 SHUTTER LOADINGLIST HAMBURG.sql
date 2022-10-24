select 
SH.Code
,isnull(SHT.Text,SHType.[Description]) as ShipmentTyp
,SHType.Weight  as Tara
,SH.[Description] as ShipmentDescription
,SH.LoadingDate
,SH.DeliveryDate
,case sl.[Status]
when 0 then 'none'
when 1 then 'Verladen'
when 2 then 'Entladet' end as LineStatus
,isnull(HUT.Text,'Teil') as Typ
,isnull(HU.[Code],LP.[Code]) as 'Barcode'
,isnull(HU.[Description],LP.[Description]) as 'DESCRIPTION'
,HU.ColliNumber as 'ColliNumber'
,isnull(HU.[Length],LP.[Length]) as 'Lengt'
,isnull(HU.[Width],LP.[Width]) as 'Width'
,isnull(HU.[Height],LP.[Height]) as 'Height'
,isnull(HU.[Brutto],LP.[Weight]) as 'Brutto'
,isnull(HU.[Netto],LP.[Weight]) as 'Netto'
,isnull(HU.[Weight],LP.[Weight]) as 'Weight'
,Dimensions.Project
,Dimensions.[Order]
,Dimensions.Commission
,CF.Spedition
,CF.TruckNumber
,CF.Ship
,CF.USSealNo
,AL.Code as ActualLocation
,AZ.name as ActualZone
,AB.Code as ActualBin
,isnull(SSH.Text,S.name) as Status
from ShipmentLine SL

inner join BusinessUnitPermission BUP on SL.id = BUP.ShipmentLineId and BUP.BusinessUnitID = '2afb0812-aa09-4494-b2d3-777460852831'
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id and SH.[Type] = 0
left join HandlingUnitType SHType on SH.HandlingUnitTypeId = SHType.id and SHType.Container = 'True'
inner join [Status] S on SH.StatusId = S.Id
left join Translation SSH on S.id = SSH.EntityId and SSH.[Language] = 'de' and SSH.[Column] = 'Name'
left join Translation SHT on SH.HandlingUnitTypeId = SHT.EntityId and SHT.[Language] = 'de' and SHT.[Column] = 'Description'
left join HandlingUnit HU on SL.HandlingUnitId = HU.Id
left join Translation HUT on HU.TypeId= HUT.EntityId and HUT.[Language] = 'de' and HUT.[Column] = 'Description'
left join LoosePart LP on SL.LoosePartId = LP.id
left join [Location] AL on isnull(HU.ActualLocationId,LP.ActualLocationId) = AL.id
left join [Zone] AZ on isnull(HU.ActualZoneId,LP.ActualZoneId) = AZ.id
left join [Bin] AB on isnull(HU.ActualBinId,LP.ActualBinId) = AB.id

left join (
select 
D.name, 
DV.Content,
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions on isnull(SL.HandlingUnitId,SL.LoosePartId) = Dimensions.EntityId

left join (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in (select name from CustomField where ClientBusinessUnitId = '2afb0812-aa09-4494-b2d3-777460852831' group by name) and CV.Entity = 31
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Ship],[Gross],[Spedition],[Comments],[TruckNumber],[USSealNo])
        ) as CF on SH.id = CF.EntityID

where --SH.LoadingDate between '2020-09-01' and '2020-09-17'

sh.code = 'LKW09/576-130-302870'


