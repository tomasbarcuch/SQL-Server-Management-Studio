SELECT 

ISNULL(Afrom.ContactPerson,'') as [FromContactPerson],
ISNULL(Afrom.PhoneNo,'') as [FromPhoneNo],
ISNULL(SH.ToAddressContactPerson,'')+' '+ISNULL(SH.ToAddressPhoneNo,'') as [ToContactPerson],
ISNULL(sh.toaddressphoneno, ato.phoneno) as [ToPhoneNo],
isnull(Lfrom.Name,'')+' '+ISNULL(Afrom.Country,'') FromLocation,
isnull(Afrom.Street,'') FromStreet,
ISNULL(Afrom.PostCode,'')+' '+ISNULL(Afrom.City,'') FromCity,
ISNULL(Afrom.Country,'') FromCountry,
ISNULL(SH.ToAddressName,Lto.Name) ToAddressName,
isnull(LTo.Name,'')+' '+ISNULL(ATo.Country,'') ToLocation,
ISNULL(SH.ToAddressStreet,Ato.Street) ToStreet,
ISNULL(SH.ToAddressPostCode,Ato.PostCode) ToPostCode,
ISNULL(SH.ToAddressCity,Ato.City) ToCity,
ISNULL(SH.ToAddressCountry,Ato.Country) ToCountry


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

  FROM ShipmentLine Sl with (NOLOCK)

inner JOIN ShipmentHeader Sh ON Sl.ShipmentHeaderId = Sh.Id

inner join (SELECT ShipmentHeaderId,BusinessUnitId  FROM [BusinessUnitPermission] with (NOLOCK) WHERE ShipmentHeaderId is not null and BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2'
) BUPsh on SH.id = BUPsh.ShipmentHeaderId
inner JOIN Status S ON Sh.StatusId = S.Id
left outer JOIN LoosePart AS Lp	ON SL.LoosePartId = Lp.Id
left outer join HandlingUnit ActHU on isnull(LP.TopHandlingUnitId,ActualHandlingUnitId) = ActHU.id
left outer JOIN Handlingunit AS HU	ON SL.HandlingUnitId = HU.Id
where 
(SH.type = 0 and sh.id= 'c303213e-0933-4691-a14f-d81776dc2018')


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
left outer join HandlingUnitType HUT on HU.TypeId = HUT.Id
left outer join HandlingUnitType SHUT on SH.HandlingUnitTypeId = SHUT.Id
left join Translation Tshtype on SH.HandlingUnitTypeId = TShtype.EntityId and Tshtype.[Column] = 'Code' and Tshtype.[Language] =  'de'
inner join BusinessUnit BU on  Shipment.ClientBusinessUnitId = BU.id
inner join STATUS S on shipment.shstid = S.id
left outer join Translation T on S.ID = T.entityId and T.[Language] =  'de'
left join Translation Tuom on LP.BaseUnitOfMeasureId = Tuom.EntityId and Tuom.[Column] = 'Code' and Tuom.[Language] =  'de'
left join Translation Thutype on HU.TypeId = Thutype.EntityId and Thutype.[Column] = 'Code' and Thutype.[Language] =  'de'
left join Bin BHU on HU.ActualBinId = BHU.id
left join Bin BLP on LP.ActualBinId = BLP.id

LEFT JOIN (
select 
D.name, 
ISNULL(DV.Description,'')+' '+DV.Content as Content, 
edvr.EntityId from DimensionValue DV with (NOLOCK)
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Customer','Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
        ) as SHDimensions on SH.Id = SHDimensions.EntityId

   LEFT JOIN (
SELECT [D].[name], [DV].[Description] as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
LEFT JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Language] = 'de'   and [T].[Column] = 'name'

WHERE [D].[name] in ('CUSTOMER')
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Customer])
        )  as [CUSTOMER] on SH.Id = [CUSTOMER].[EntityId]   
     
LEFT JOIN (
select 
D.name, 
DV.Content, 
edvr.EntityId from DimensionValue DV with (NOLOCK)
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Customer','Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
        ) as LPDimensions on LP.Id = LPDimensions.EntityId
 
 LEFT JOIN (
select 
D.name,
DV.Content, 
edvr.EntityId from DimensionValue DV with (NOLOCK)
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Customer','Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
        ) as HUDimensions on HU.Id = HUDimensions.EntityId

 left join  (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField with (NOLOCK)
INNER JOIN CustomValue CV with (NOLOCK) ON (CustomField.Id = CV.CustomFieldId)
where name in ('Colli','IPPC') and CV.Entity in (15)
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Colli],[IPPC])
) CFLP on LP.id = CFLP.EntityID
 left join  (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField with (NOLOCK)
INNER JOIN CustomValue CV with (NOLOCK) ON (CustomField.Id = CV.CustomFieldId)
where name in ('Colli','IPPC') and CV.Entity in (31)
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Colli],[IPPC])
) CF on SH.id = CF.EntityID


,[User] U
inner join DisplayUOM DUOM on U.DisplayUOMId = DUOM.Id
inner join Translation A on DUOM.id = A.EntityId and A.Language = 'de'   and A.[Column] = 'AreaUnitName'
inner join Translation B on DUOM.id = B.EntityId and B.Language = 'de'   and B.[Column] = 'BasicUnitName'
inner join Translation L on DUOM.id = L.EntityId and L.Language = 'de'   and L.[Column] = 'LengthUnitName'
inner join Translation V on DUOM.id = V.EntityId and V.Language = 'de'   and V.[Column] = 'VolumeUnitName'
inner join Translation W on DUOM.id = W.EntityId and W.Language = 'de'   and W.[Column] = 'WeightUnitName'

WHERE U.Id =  'c31463c0-186e-4449-87a6-a487fb05bbfe'

