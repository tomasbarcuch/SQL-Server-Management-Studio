SELECT 
sh.ClientBusinessUnitId,
sh.id,
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
T.Text as SHStatus,
CodeSH.CodeSH+' '+KennwortSH.KennwortSH as ProjectSH,
CV_SH_TIR.Content as 'Truck Number',
CV_SH_SPE.Content as 'Spedition',
SH.Code SHCode,
LP.code LPCode,
HU.Code HUCode,
SH.[Description],
SH.LoadingDate,
SH.FromAddressContactPerson,
SH.FromAddressPhoneNo,
SH.ToAddressContactPerson,
SH.ToAddressPhoneNo,
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
CV_LP_pos.Content as LPPos,
CodeD.CodeHU as HUProject,
CodeDlp.CodeLP as LPProject,
CV_HU_pos.Content as HUPos,
CV_HU_INH.Content as HUInh,
SL.[LineNo],
Sl.Quantity,
SL.[Type],
UOM.Name,
KennwortDhu.Kennwort,
KennwortLP.Kennwort as KennwortLP,
Macros.Macros,
Verpackungsart.Verpackungsart,
HU.Brutto,
hu.Netto,
HU.Weight,
HU.Length,
HU.Width,
HU.Height,
HU.Volume,
HUT.[Description] HUType,
HUT.Weight as HUWeight,
LP.Length as LPlenght,
LP.Width as LPWidth,
lp.Height as LPHeight,
lp.weight as LPWeight,
lp.Volume as LPVolume




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
SH.ClientBusinessUnitId,
sl.UnitOfMeasureId,
sh.StatusId shstid,
isnull(HU.StatusId,acthu.StatusId) hustid,
lp.StatusId lpstid,
SH.HandlingUnitTypeId

  FROM ShipmentLine Sl

inner JOIN ShipmentHeader Sh ON Sl.ShipmentHeaderId = Sh.[Id]
inner JOIN Status S ON Sh.StatusId = S.Id
left outer JOIN LoosePart AS Lp	ON SL.LoosePartId = Lp.Id
left outer join HandlingUnit ActHU on isnull(LP.TopHandlingUnitId,ActualHandlingUnitId) = ActHU.id
left outer JOIN Handlingunit AS HU	ON SL.HandlingUnitId = HU.Id
where SH.type = 0
) Shipment

left outer join ShipmentHeader SH on Shipment.shid = SH.id
left outer join ShipmentLine SL on Shipment.slid = SL.id
left outer join Address Afrom on Shipment.FromAddressId = Afrom.id
left outer join Address Ato on Shipment.ToAddressId = Ato.id
left outer join Location Lfrom on Shipment.FromLocationId = Lfrom.id
left outer join Location Lto on Shipment.ToLocationId = Lto.id
left outer join HandlingUnit HU on Shipment.acthuid = HU.Id
left outer join LoosePart LP on Shipment.lpid = LP.Id
left outer join UnitOfMeasure UOM on Shipment.UnitOfMeasureId = UOM.Id
left outer join HandlingUnitType HUT on Shipment.HandlingUnitTypeId = HUT.Id
--Kennwort LP
left outer join (select CF.ClientBusinessUnitId,CV.EntityId lpid,CV.Content as Kennwort from customvalue CV inner join CustomField CF on CV.CustomFieldId = cf.Id where CF.name = 'Kennwort'and CF.Entity = 15) KennwortLP on Shipment.lpid = KennwortLP.LPId
--Macros HU
left outer join (select CF.ClientBusinessUnitId,CV.EntityId huid,CV.Content as Macros from customvalue CV inner join CustomField CF on CV.CustomFieldId = cf.Id where CF.name = 'Macros'and CF.Entity = 11) Macros on Shipment.acthuid = Macros.huId
--Kennwort HU
left outer join (Select D.ClientBusinessUnitId, EDVR.entityid, DFV.Content as Kennwort from DimensionFieldValue DFV inner join DimensionField DF on DFV.DimensionFieldId = DF.Id and DF.Name = 'Kennwort' inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId inner join Dimension D on DF.DimensionId  = D.Id) KennwortDhu on Shipment.acthuid = KennwortDhu.EntityId
--Verpackungsart HU
left outer join (select CF.ClientBusinessUnitId,CV.EntityId huid,CV.Content as Verpackungsart from customvalue CV inner join CustomField CF on CV.CustomFieldId = cf.Id where CF.name = 'Verpackungsart'and CF.Entity = 11) Verpackungsart on Shipment.acthuid = Verpackungsart.huId
--Kennwort SH 
left outer join (Select D.ClientBusinessUnitId, EDVR.entityid, DFV.Content as KennwortSH from DimensionFieldValue DFV inner join DimensionField DF on DFV.DimensionFieldId = DF.Id and DF.Name = 'Kennwort' inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId inner join Dimension D on DF.DimensionId  = D.Id) KennwortSH on Shipment.shid = KennwortSH.EntityId 
--Dimension Code HU
left outer join (Select D.ClientBusinessUnitId, EDVR.entityid,DV.Content as 'CodeHU'from DimensionValue DV inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId inner join Dimension D on DV.DimensionId  = D.Id ) CodeD on Shipment.Acthuid = CodeD.EntityId 
--Dimension Code LP
left outer join (Select D.ClientBusinessUnitId, EDVR.entityid,DV.Content as 'CodeLP'from DimensionValue DV inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId inner join Dimension D on DV.DimensionId  = D.Id ) CodeDlp on Shipment.lpid = CodeD.EntityId 
--Dimension Code SH
left outer join (Select D.ClientBusinessUnitId, EDVR.entityid,DV.Content as 'CodeSH'from DimensionValue DV inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId inner join Dimension D on DV.DimensionId  = D.Id ) CodeSH on Shipment.shid = CodeSH.EntityId 
--Position LP
left outer join customfield CF_LP_POS on lp.ClientBusinessUnitId = CF_LP_POS.clientbusinessunitid and CF_LP_POS.name = 'Position' and cf_lp_pos.entity = 15
left outer join customvalue CV_LP_POS on CV_LP_POS.customfieldid = CF_LP_POS.Id and CV_LP_POS.EntityId = Shipment.lpId and cv_lp_pos.Entity = 15
--Position HU
left outer join customfield CF_HU_POS on hu.ClientBusinessUnitId = CF_HU_POS.clientbusinessunitid and CF_HU_POS.name = 'Position' and cf_hu_pos.entity = 11
left outer join customvalue CV_HU_POS on CV_HU_POS.customfieldid = CF_HU_POS.Id and CV_HU_POS.EntityId = shipment.acthuid and cv_hu_pos.Entity = 11
--Inhalt Deutsch HU
left outer join customfield CF_HU_INH on hu.ClientBusinessUnitId = CF_HU_INH.clientbusinessunitid and CF_HU_INH.name = 'Inhalt Deutsch' and cf_hu_inh.entity = 11
left outer join customvalue CV_HU_INH on CV_HU_INH.customfieldid = CF_HU_INH.Id and CV_HU_INH.EntityId = shipment.acthuid and cv_hu_inh.Entity = 11
--Truck Number SH
left outer join customfield CF_SH_TIR on sh.ClientBusinessUnitId = CF_SH_TIR.clientbusinessunitid and CF_SH_TIR.name = 'Truck Number' and cf_SH_TIR.entity = 31
left outer join customvalue CV_SH_TIR on CV_SH_TIR.customfieldid = CF_SH_TIR.Id and CV_SH_TIR.EntityId = shipment.shid and cv_SH_TIR.Entity = 31
--Spedition SH
left outer join customfield CF_SH_SPE on sh.ClientBusinessUnitId = CF_SH_SPE.clientbusinessunitid and CF_SH_SPE.name = 'Spedition' and cf_SH_SPE.entity = 31
left outer join customvalue CV_SH_SPE on CV_SH_SPE.customfieldid = CF_SH_SPE.Id and CV_SH_SPE.EntityId = shipment.shid and cv_SH_SPE.Entity = 31


left outer join BusinessUnit BU on  Shipment.ClientBusinessUnitId = BU.id
left outer join STATUS S on shipment.shstid = S.id
left join Translation T on S.ID = T.entityId and T.[Language] = 'de'

where Shipment.ClientBusinessUnitId ='ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2'
and sh.code = 'SP-00192'