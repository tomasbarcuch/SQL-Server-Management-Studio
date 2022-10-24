SELECT 
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
Shipment.ClientBusinessUnitId,
T.Text as SHStatus,

CV_SH_TIR.Content as 'Truck Number',

SH.Code SHCode,
LP.code LPCode,
HU.Code HUCode,
SH.[Description],
CONVERT(datetime, SWITCHOFFSET(CONVERT(datetimeoffset, SH.LoadingDate), DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as LoadingDate,
Afrom.ContactPerson as [FromContactPerson],
Afrom.PhoneNo as [FromPhoneNo],
SH.ToAddressName,

Ato.ContactPerson as [ToContactPerson],
Ato.PhoneNo as [ToPhoneNo],
Lfrom.Name FromLocation,
Afrom.Street FromStreet,
Afrom.PostCode+' '+Afrom.City FromCity,
Afrom.Country FromCountry,
isnull(Lto.Name,Ato.City+' '+Ato.Country) ToLocation,
Ato.Street ToStreet,
Ato.PostCode+' '+Ato.City ToCity,
Ato.Country ToCountry,
LP.[Description] as LP,
HU.[Description] as HU,
Dimensions.Client as Client,
Dimensions.Project as ProjectSH,
--CodeD.CodeHU as HUProject,
--CodeDlp.CodeLP as LPProject,

SL.[LineNo],
Sl.Quantity,
SL.[Type],
UOM.Name,

HU.Brutto,
hu.Netto,
ISNULL(HU.Weight,0) as 'HuWeight',
HU.Length,
HU.Width,
HU.Height,
HU.Volume,
HUT.[Description] HUType,
HUT.Weight as HUWeight,
LP.Length as LPlenght,
LP.Width as LPWidth,
lp.Height as LPHeight,
isnull(lp.weight,0) as LPWeight,
lp.Volume as LPVolume,

HU.ColliNumber

 from
(SELECT
SH.FromLocationId,
SH.FromAddressId,
SH.ToLocationId,
SH.ToAddressId,
SH.id shid,
SL.id slid,
isnull(HU.id,acthu.id) acthuid,
lp.id lpid,
BUPsh.BusinessUnitId ClientBusinessUnitId,
sl.UnitOfMeasureId,
sh.StatusId shstid,
isnull(HU.StatusId,acthu.StatusId) hustid,
lp.StatusId lpstid,
SH.HandlingUnitTypeId

  FROM ShipmentLine Sl

inner JOIN ShipmentHeader Sh ON Sl.ShipmentHeaderId = Sh.Id
inner join (SELECT ShipmentHeaderId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE ShipmentHeaderId is not null) BUPsh on SH.id = BUPsh.ShipmentHeaderId
inner JOIN Status S ON Sh.StatusId = S.Id
left outer JOIN LoosePart AS Lp	ON SL.LoosePartId = Lp.Id
left outer join HandlingUnit ActHU on isnull(LP.TopHandlingUnitId,ActualHandlingUnitId) = ActHU.id
left outer JOIN Handlingunit AS HU	ON SL.HandlingUnitId = HU.Id
where SH.type = 0
) Shipment

inner join ShipmentHeader SH on Shipment.shid = SH.id
inner join ShipmentLine SL on Shipment.slid = SL.id
left outer join Address Afrom on Shipment.FromAddressId = Afrom.id
left outer join Address Ato on Shipment.ToAddressId = Ato.id
left outer join Location Lfrom on Shipment.FromLocationId = Lfrom.id
left outer join Location Lto on Shipment.ToLocationId = Lto.id
left outer join HandlingUnit HU on Shipment.acthuid = HU.Id
left outer join LoosePart LP on Shipment.lpid = LP.Id
left outer join UnitOfMeasure UOM on Shipment.UnitOfMeasureId = UOM.Id
left outer join HandlingUnitType HUT on Shipment.HandlingUnitTypeId = HUT.Id

left join  (
select D.name, T.text+': '+DV.[Description]+' ['+DV.Content+']' as Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = (select [Id] from [BusinessUnit] where [Name] = 'Sonstige Kunden - Sankt Pölten')-- $P{ClientBusinessUnitID} 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
left join DimensionField DF on D.id = DF.DimensionId
left join Translation T on D.Id = T.EntityId and T.[Language] = 'de'--$P{Language

where D.name in ('Client','Project','Order') and D.[Disabled] = 0
) SRC
PIVOT (max(src.Content) for src.Name  in ([Client],[Project],[Order])
        ) as Dimensions on SH.id = Dimensions.EntityId

left outer join customfield CF_SH_TIR on Shipment.ClientBusinessUnitId = CF_SH_TIR.clientbusinessunitid and CF_SH_TIR.name = 'TruckNumber' and cf_SH_TIR.entity = 31
left outer join customvalue CV_SH_TIR on CV_SH_TIR.customfieldid = CF_SH_TIR.Id and CV_SH_TIR.EntityId = shipment.shid and cv_SH_TIR.Entity = 31

left outer join BusinessUnit BU on  Shipment.ClientBusinessUnitId = BU.id
left outer join STATUS S on shipment.shstid = S.id
left outer join Translation T on S.ID = T.entityId and T.[Language] = 'de' --$P{Language} 
where Shipment.ClientBusinessUnitId = 'ed8affd1-765e-4312-9c6e-31600d751882'-- $P{ClientBusinessUnitID} 
and shipment.shid = '9085519f-5943-4448-801f-41fcba72b8eb' --$P{ShipmentHeaderID}
