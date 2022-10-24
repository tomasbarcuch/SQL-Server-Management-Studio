SELECT 
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
Shipment.ClientBusinessUnitId,
T.Text as SHStatus,
CodeSH.CodeSH+' '+KennwortSH.KennwortSH as ProjectSH,
CV_SH_TIR.Content as 'Truck Number',
CV_SH_SPE.Content as 'Spedition',
SH.Code SHCode,
LP.code LPCode,
HU.Code HUCode,
SH.[Description],
CONVERT(datetime, SWITCHOFFSET(CONVERT(datetimeoffset, SH.LoadingDate), DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as LoadingDate,
Afrom.ContactPerson as [FromContactPerson],
Afrom.PhoneNo as [FromPhoneNo],
SH.ToAddressName,
CV_A_Notes.Content as [ToAddressNotes],
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
CFLP.[Position] as LPPos,
CodeD.CodeHU as HUProject,
CodeDlp.CodeLP as LPProject,
CFHU.[Position] as HUPos,
CFHU.[Inhalt Deutsch] as HUInh,
SL.[LineNo],
Sl.Quantity,
SL.[Type],
UOM.Name,
KennwortDhu.Kennwort,
CFLP.Kennwort as KennwortLP,
CFHU.Macros,
CFHU.Verpackungsart,
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
isnull(cast(replace(CFLP.[Brutto kg],',','.')  as decimal(12,2)),0.0) as LPBrutto,
lp.Volume as LPVolume,
CFLP.Colli as lpColliNumber,
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

  FROM ShipmentLine Sl with (NOLOCK)

inner JOIN ShipmentHeader Sh ON Sl.ShipmentHeaderId = Sh.Id
inner join (SELECT ShipmentHeaderId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE ShipmentHeaderId is not null and BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2') BUPsh on SH.id = BUPsh.ShipmentHeaderId
inner JOIN Status S ON Sh.StatusId = S.Id
left outer JOIN LoosePart AS Lp	ON SL.LoosePartId = Lp.Id
left outer join HandlingUnit ActHU on isnull(LP.TopHandlingUnitId,ActualHandlingUnitId) = ActHU.id
left outer JOIN Handlingunit AS HU	ON SL.HandlingUnitId = HU.Id
where SH.type = 0 
and sh.id = 'c66aad47-e42d-42a0-948a-14cf44bbb062'
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
--left outer join (select CF.ClientBusinessUnitId,CV.EntityId lpid,CV.Content as Kennwort from customvalue CV inner join CustomField CF on CV.CustomFieldId = cf.Id where CF.name = 'Kennwort'and CF.Entity = 15) KennwortLP on Shipment.lpid = KennwortLP.LPId
--left outer join (select CF.ClientBusinessUnitId,CV.EntityId huid,CV.Content as Macros from customvalue CV inner join CustomField CF on CV.CustomFieldId = cf.Id where CF.name = 'Macros'and CF.Entity = 11) Macros on Shipment.acthuid = Macros.huId
left outer join (Select BUP.BusinessUnitId ClientBusinessUnitId, EDVR.entityid, DFV.Content as Kennwort from DimensionFieldValue DFV inner join DimensionField DF on DFV.DimensionFieldId = DF.Id and DF.Name = 'Kennwort' inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId inner join Dimension D on DF.DimensionId  = D.Id inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.DimensionId is not null) KennwortDhu on Shipment.acthuid = KennwortDhu.EntityId
--left outer join (select CF.ClientBusinessUnitId,CV.EntityId huid,CV.Content as Verpackungsart from customvalue CV inner join CustomField CF on CV.CustomFieldId = cf.Id where CF.name = 'Verpackungsart'and CF.Entity = 11 ) Verpackungsart on Shipment.acthuid = Verpackungsart.huId
left outer join (Select BUP.BusinessUnitId ClientBusinessUnitId, EDVR.entityid, DFV.Content as KennwortSH from DimensionFieldValue DFV inner join DimensionField DF on DFV.DimensionFieldId = DF.Id and DF.Name = 'Kennwort' inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId inner join Dimension D on DF.DimensionId  = D.Id inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.DimensionId is not null) KennwortSH on Shipment.shid = KennwortSH.EntityId 
left outer join (Select BUP.BusinessUnitId ClientBusinessUnitId, EDVR.entityid,DV.Content as 'CodeHU'from DimensionValue DV inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId inner join Dimension D on DV.DimensionId  = D.Id inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.DimensionId is not null ) CodeD on Shipment.Acthuid = CodeD.EntityId 
left outer join (Select BUP.BusinessUnitId ClientBusinessUnitId, EDVR.entityid,DV.Content as 'CodeLP'from DimensionValue DV inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId inner join Dimension D on DV.DimensionId  = D.Id inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.DimensionId is not null  ) CodeDlp on Shipment.lpid = CodeDlp.EntityId 
left outer join (Select BUP.BusinessUnitId ClientBusinessUnitId, EDVR.entityid,DV.Content as 'CodeSH'from DimensionValue DV inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId inner join Dimension D on DV.DimensionId  = D.Id inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.DimensionId is not null ) CodeSH on Shipment.shid = CodeSH.EntityId 

--left outer join (SELECT LoosePartId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE LoosePartId is not null) BUPlp on LP.id = BUPlp.LoosePartId
--left outer join (SELECT ShipmentHeaderId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE ShipmentHeaderId is not null) BUPsh on SH.id = BUPsh.ShipmentHeaderId
--left outer join (SELECT HandlingUnitId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE HandlingUnitId is not null) BUPhu on HU.id = BUPhu.HandlingUnitId

--left outer join customfield CF_LP_POS on Shipment.ClientBusinessUnitId = CF_LP_POS.clientbusinessunitid and CF_LP_POS.name = 'Position' and cf_lp_pos.entity = 15
--left outer join customvalue CV_LP_POS on CV_LP_POS.customfieldid = CF_LP_POS.Id and CV_LP_POS.EntityId = Shipment.lpId and cv_lp_pos.Entity = 15

--left outer join customfield CF_HU_POS on Shipment.ClientBusinessUnitId = CF_HU_POS.clientbusinessunitid and CF_HU_POS.name = 'Position' and cf_hu_pos.entity = 11
--left outer join customvalue CV_HU_POS on CV_HU_POS.customfieldid = CF_HU_POS.Id and CV_HU_POS.EntityId = shipment.acthuid and cv_hu_pos.Entity = 11

--left outer join customfield CF_HU_INH on Shipment.ClientBusinessUnitId = CF_HU_INH.clientbusinessunitid and CF_HU_INH.name = 'Inhalt Deutsch' and cf_hu_inh.entity = 11
--left outer join customvalue CV_HU_INH on CV_HU_INH.customfieldid = CF_HU_INH.Id and CV_HU_INH.EntityId = shipment.acthuid and cv_hu_inh.Entity = 11

left outer join customfield CF_SH_TIR on Shipment.ClientBusinessUnitId = CF_SH_TIR.clientbusinessunitid and CF_SH_TIR.name = 'Truck Number' and cf_SH_TIR.entity = 31
left outer join customvalue CV_SH_TIR on CV_SH_TIR.customfieldid = CF_SH_TIR.Id and CV_SH_TIR.EntityId = shipment.shid and cv_SH_TIR.Entity = 31

left outer join customfield CF_SH_SPE on Shipment.ClientBusinessUnitId = CF_SH_SPE.clientbusinessunitid and CF_SH_SPE.name = 'Spedition' and cf_SH_SPE.entity = 31
left outer join customvalue CV_SH_SPE on CV_SH_SPE.customfieldid = CF_SH_SPE.Id and CV_SH_SPE.EntityId = shipment.shid and cv_SH_SPE.Entity = 31

--left outer join customfield CF_LP_CO on Shipment.ClientBusinessUnitId = CF_LP_CO.clientbusinessunitid and CF_LP_CO.name = 'Colli' and cf_lp_co.entity = 15
--left outer join customvalue CV_LP_CO on CV_LP_CO.customfieldid = CF_LP_CO.Id and CV_LP_CO.EntityId = Shipment.lpId and cv_lp_co.Entity = 15

--left outer join customfield CF_LP_BRUTTO on Shipment.ClientBusinessUnitId = CF_LP_BRUTTO.clientbusinessunitid and CF_LP_BRUTTO.name = 'Brutto kg' and cf_lp_BRUTTO.entity = 15
--left outer join customvalue CV_LP_BRUTTO on CV_LP_BRUTTO.customfieldid = CF_LP_BRUTTO.Id and CV_LP_BRUTTO.EntityId = Shipment.lpId and cv_lp_BRUTTO.Entity = 15

left outer join customfield CF_A_Notes on Shipment.ClientBusinessUnitId = CF_A_Notes.clientbusinessunitid and CF_A_Notes.name = 'Notes' and CF_A_Notes.entity = 0
left outer join customvalue CV_A_Notes on CV_A_Notes.customfieldid = CF_A_Notes.Id and CV_A_Notes.EntityId = SH.ToAddressId and CV_A_Notes.Entity = 0


left join  (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('Position','Inhalt Deutsch','Colli','Brutto kg','Kennwort') and CV.Entity in (15)
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Position],[Inhalt Deutsch],[Colli],[Brutto kg],[Kennwort])
) CFLP on LP.id = CFLP.EntityID
left join   (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('Position','Inhalt Deutsch','Macros','Verpackungsart') and CV.Entity in (11)
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Position],[Inhalt Deutsch],[Macros],[Verpackungsart])
) CFHU on HU.id = CFHU.EntityID



left outer join BusinessUnit BU on  Shipment.ClientBusinessUnitId = BU.id
left outer join STATUS S on shipment.shstid = S.id
left outer join Translation T on S.ID = T.entityId and T.[Language] = 'de'

