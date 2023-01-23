
select

'Lagerbestand' 'STATUS'
,ISNULL(ReceiptGoods.BEMERKUNG2, '') 'Siemens Versandaufgabe'
,ISNULL(ReceiptGoods.SDU_BESTELLPOS, '')  'Pos1'
,ReceiptGoodsNr 'Labelnummer'
,CV.Content 'Dienstleister'
,CAST(Inbound.Inbound as DATE) 'Datum WE'
,'' 'Siemens Abholavis'
,'' 'Pos2'
,ISNULL(ACTCRATES.ActualCode, '') 'Externe WA-Nummer'
,CAST(Outbound.Outbound as DATE) 'Datum WA'
,ISNULL(ProjectNr, '') 'Auftragsnummer'
,ISNULL(ReceiptGoods.BEMERKUNG7, '') 'Innenauftrag'
,ISNULL(ReceiptGoods.[SDU_KUNDENAUFTRAG], '') 'Kundenauftragsummer'
,ISNULL(Project.Project, '') 'Kennwort'
,ISNULL(ReceiptGoods.ReceiptGoods, '') 'Artikelbezeichnung'
,CASE WHEN LEN(ReceiptGoods.BEMERKUNG3) = 0 THEN LOOSEPARTS.LooseParts ELSE ReceiptGoods.BEMERKUNG3 END 'Materialnummer'
,ISNULL(ReceiptGoods.BEMERKUNG5, '') 'Fauf-Nr'
,ISNULL(ReceiptGoods.SDU_BESTELLNR, '') 'Bestell-Nr'
,ISNULL(ReceiptGoods.SDU_BESTELLPOS, '') 'Bestell-Pos'
,ISNULL(ReceiptGoods.BEMERKUNG4, '') 'Banf-Nr'
,1 'Anz Stck'
,ISNULL(ReceiptGoods.HUTYPE, '') 'Verpackungsart'
,CASE WHEN ReceiptGoods.SDU_ZOLLGUT = 'true' THEN 'X' ELSE '' END 'Zollgut_ja'
,CASE WHEN ReceiptGoods.SDU_ZOLLGUT = 'false' THEN 'X' ELSE '' END 'Zollgut_nein'
,TRY_CONVERT(FLOAT, ReceiptGoods.LENGHT) 'Länge'
,TRY_CONVERT(FLOAT, ReceiptGoods.WIDTH) 'Breite'
,TRY_CONVERT(FLOAT, ReceiptGoods.HEIGHT) 'Höhe'
,0  'Netto'
,ISNULL(TRY_CONVERT(float, ReceiptGoods.GROSSW), 0) / 1000 'Brutto'

,(ReceiptGoods.Lenght / 10)  * (ReceiptGoods.Width / 10)   'Lagerfläche qm'

,CASE 
    WHEN SUBSTRING([Z].[NAME],1,1) IN ('H', 'F') AND TRY_CAST(SUBSTRING([Z].[NAME],2,LEN([Z].[NAME])-1) AS INT) < 10 THEN SUBSTRING([Z].[NAME],1,LEN([Z].[NAME])-1) + '0' + SUBSTRING([Z].[NAME],2,LEN([Z].[NAME])-1) 
    WHEN [Z].[NAME] LIKE '%WESEL%' THEN 'WES'
    ELSE ISNULL([Z].[NAME], '') END as "Halle"
,CASE 
    WHEN [B].[Description] LIKE '%Feld%' THEN 'F' + SUBSTRING([B].[Description],6,LEN([B].[Description])-5)
    WHEN SUBSTRING([Z].[NAME],1,1) = 'F' THEN [Z].[NAME] 
    ELSE '' 
END AS "Feld"
,CASE WHEN [B].[Description] LIKE '%Regal%' THEN SUBSTRING([Bin].[Code], 1, 2) ELSE '' END AS "Regal"
,CASE WHEN [B].[Description] LIKE '%Regal%' THEN SUBSTRING([Bin].[Code], 3, 2) ELSE '' END AS "Reihe"
,CASE WHEN [B].[Description] LIKE '%Regal%' THEN SUBSTRING([Bin].[Code], 5, 2) ELSE '' END AS "Fach"
,CASE WHEN SUBSTRING([Z].[NAME],1,1) = 'F' THEN 'X' ELSE '' END AS 'FREIFLÄCHE'

,ISNULL(ACTCOLLI.ActualColli,'') 'Kolli Nr Siemens Energy'
,ISNULL(ReceiptGoods.SDU_KENNZAHL, '') 'Kennzahl'
,ISNULL(ACTCOLLI.ActualColli,'') 'Externe Komm-Nr'
,ISNULL(LoadingReceiptGoods.LoadingReceiptGoodsNr, '') 'externe WE-Nr'
,ISNULL(LoadingReceiptGoods.Supplier, '') 'Lieferant'
,'' 'externe Bemerkung'
,InboundCode.InboundCode 'Pappkarton'
,CRATES.HandlingUnits 'BoxCAD'
,ISNULL(SHIPMENT.ShipmentCode, '') 'Deufol Lieferschein Nr'
,Isnull(ReceiptGoods.SDU_VAN_ID, '') 'VAN ID'
,'' 'Summe Lagerfläche qm'
,'' 'Abrechnungsbetrag 1'
,'' 'Summe Auftragsnummer 1'
,'' 'Abrechnungsbetrag 2'
,'' 'Summe Auftragsnummer 2'
,'' 'Freifeld'
--,LOOSEPARTS.LooseParts 'Inhalt'

/*
HU.Code,
HU.ColliNumber,
LP.Code,
B.Code,
Project.*,
ReceiptGoods.*,
Outbound.Outbound,
LoadingReceiptGoods.*
*/
 from (
select
DV.ParentDimensionValueId,
DV.Id DimensionValueId ,
DV.Content ReceiptGoodsNr,
DV.[Description] ReceiptGoods, 
D.[Description] Dimension,
S.Name as Status,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
INNER join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'ReceiptGoods'
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Duisburg')
inner join Status S on DV.StatusId = S.id
where 
DF.name in ('DAMAGE','DAMAGE_WHAT','DAMAGE_WHY','LENGHT','WIDTH','HEIGHT','GROSSW','HUTYPE','DANGEROUS_GOODS','IS_BILLED','INVOICE_MONTH','FREE_TEXT_INVOICE_NO','BEMERKUNG2','BEMERKUNG7','BEMERKUNG3','BEMERKUNG5','BEMERKUNG4','SDU_BESTELLNR','SDU_BESTELLPOS','SDU_ZOLLGUT','SDU_KENNZAHL','SDU_KUNDENAUFTRAG','SDU_VAN_ID'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([DAMAGE],[DAMAGE_WHAT],[DAMAGE_WHY],[LENGHT],[WIDTH],[HEIGHT],[GROSSW],[HUTYPE],[DANGEROUS_GOODS],[IS_BILLED],[INVOICE_MONTH],[FREE_TEXT_INVOICE_NO],[BEMERKUNG2],[BEMERKUNG7],[BEMERKUNG3],[BEMERKUNG5],[BEMERKUNG4],[SDU_BESTELLNR],[SDU_BESTELLPOS],[SDU_ZOLLGUT],[SDU_KENNZAHL],[SDU_KUNDENAUFTRAG],[SDU_VAN_ID])) as ReceiptGoods

inner join (select
DV.Id DimensionValueId,
DV.Content LoadingReceiptGoodsNr,
DV.[Description] LoadingReceiptGoods, 
D.[Description] Dimension,
--EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'LoadingReceiptGoods'
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Duisburg')

where 
DF.name in ('LOADING_DATE','RESPONSIBLE_FOR_LOADING','ACCOMPANYING_DOCUMENTS','SUPPLIER','DELIVERYNOTE','DAMAGE','DAMAGE_WHY','DAMAGE_WHAT','GOODS_LABELED_AND_SCANNED','NUMBER_OF_PACKAGES_OK','NUMBER_OF_PACKAGES_OK_TEXT'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([LOADING_DATE],[RESPONSIBLE_FOR_LOADING],[ACCOMPANYING_DOCUMENTS],[SUPPLIER],[DELIVERYNOTE],[DAMAGE],[DAMAGE_WHY],[DAMAGE_WHAT],[GOODS_LABELED_AND_SCANNED],[NUMBER_OF_PACKAGES_OK],[NUMBER_OF_PACKAGES_OK_TEXT])) as LoadingReceiptGoods on ReceiptGoods.ParentDimensionValueId = LoadingReceiptGoods.DimensionValueId



INNER JOIN (

select Distinct DV.Id DimensionValueId, Project.DimensionValueId ProjectDimensionVAlueId from EntityDimensionValueRelation EDVR
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DV.DimensionId = D.id and D.name = 'ReceiptGoods'
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Duisburg')
Left join (select DV.Id DimensionValueId, EDVR.EntityID from EntityDimensionValueRelation EDVR
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DV.DimensionId = D.id and D.name = 'Project'
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Duisburg')) Project on EDVR.EntityId = Project.EntityId
) DimensionMap on ReceiptGoods.DimensionValueId = DimensionMap.DimensionValueId

LEFT join (select
DV.Id DimensionValueId,
DV.Content ProjectNr,
DV.[Description] Project, 
D.[Description] Dimension,
--EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project'
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Duisburg')
where 
DF.name in ('PACKINGTYPE','MACHINE'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([PACKINGTYPE],[MACHINE])) as Project on DimensionMap.ProjectDimensionVAlueId = Project.DimensionValueId



LEFT JOIN (
select 
Dimensions.ReceiptGoods
,MAX(WFE.Created) as Outbound
from WorkflowEntry WFE
INNER JOIN  (
select D.name, DV.Id as DimensionValueId, edvr.EntityId from DimensionValue DV 
left join Dimension D on DV.DimensionId = D.id 
left join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
left join DimensionField DF on D.id = DF.DimensionId
where D.name in ('ReceiptGoods')
) SRC
PIVOT (max(src.DimensionValueId) for src.Name  in ([ReceiptGoods])
        ) as Dimensions on WFE.EntityId = Dimensions.EntityId
inner join [Status] S on WFE.StatusId = S.Id and S.NAME = 'ON_THE_WAY'
group by 
Dimensions.ReceiptGoods
) Outbound on ReceiptGoods.DimensionValueId = Outbound.ReceiptGoods




LEFT JOIN (
select 
Dimensions.ReceiptGoods
,Min(WFE.Created) as Inbound
from WorkflowEntry WFE
INNER JOIN  (
select D.name, DV.Id as DimensionValueId, edvr.EntityId from DimensionValue DV 
left join Dimension D on DV.DimensionId = D.id 
left join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
left join DimensionField DF on D.id = DF.DimensionId
where D.name in ('ReceiptGoods')
) SRC
PIVOT (max(src.DimensionValueId) for src.Name  in ([ReceiptGoods])
        ) as Dimensions on WFE.EntityId = Dimensions.EntityId
inner join [Status] S on WFE.StatusId = S.Id and S.NAME = 'ON_STOCK'
group by 
Dimensions.ReceiptGoods
) Inbound on ReceiptGoods.DimensionValueId = Inbound.ReceiptGoods

LEFT JOIN (
SELECT 
 distinct DV.ID, 
            stuff((select distinct ',' + IsNull(HUD.Code , '')
            from HandlingUnit HUD
            inner join EntityDimensionValueRelation EDVR on HUD.Id = EDVR.EntityId
            inner join DimensionValue DVD ON DVD.Id = EDVR.DimensionValueId
            where DVD.ID = DV.ID
            group by DVD.ID, HUD.Code
            for xml path('')), 1, 1, '') [HandlingUnits]

  from DimensionValue DV
  inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'ReceiptGoods'
) CRATES on ReceiptGoods.DimensionValueId = CRATES.ID 

LEFT JOIN (
SELECT 
 distinct DV.ID, 
            STUFF((select distinct ',' + IsNull(LP.Code, '')
            from LoosePart LP
            inner join EntityDimensionValueRelation EDVR on LP.Id = EDVR.EntityId
            inner join DimensionValue DVD ON DVD.Id = EDVR.DimensionValueId
            where DVD.ID = DV.ID
            group by DVD.ID, LP.Code
            for xml path('')), 1, 1, '') [LooseParts]

  from DimensionValue DV
  inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'ReceiptGoods'
  inner join BusinessUnitPermission BUP on D.Id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Duisburg')

) LOOSEPARTS on ReceiptGoods.DimensionValueId = LOOSEPARTS.ID

LEFT JOIN (
SELECT 
 distinct DV.ID, 
            STUFF((select distinct ',' + IsNull(LP.InboundCode, '')
            from LoosePart LP
            inner join EntityDimensionValueRelation EDVR on LP.Id = EDVR.EntityId
            inner join DimensionValue DVD ON DVD.Id = EDVR.DimensionValueId
            where DVD.ID = DV.ID
            group by DVD.ID, LP.InboundCode
            for xml path('')), 1, 1, '') [InboundCode]

  from DimensionValue DV
  inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'ReceiptGoods'
  inner join BusinessUnitPermission BUP on D.Id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Duisburg')

) InboundCode on ReceiptGoods.DimensionValueId = InboundCode.ID


LEFT JOIN (
SELECT 
 distinct DV.ID, 
            STUFF((select distinct ',' + IsNull(HU.Code, '')
            from LoosePart LP
            inner join HandlingUnit HU on LP.ActualHandlingUnitId = HU.Id
            inner join EntityDimensionValueRelation EDVR on LP.Id = EDVR.EntityId
            inner join DimensionValue DVD ON DVD.Id = EDVR.DimensionValueId
            where DVD.ID = DV.ID
            group by DVD.ID, HU.Code
            for xml path('')), 1, 1, '') [ActualCode]

  from DimensionValue DV
  inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'ReceiptGoods'
  inner join BusinessUnitPermission BUP on D.Id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Duisburg')

) ACTCRATES on ReceiptGoods.DimensionValueId = ACTCRATES.ID 


LEFT JOIN (
SELECT 
 distinct DV.ID, 
            STUFF((select distinct ',' + IsNull(HU.ColliNumber, '')
            from LoosePart LP
            inner join HandlingUnit HU on LP.ActualHandlingUnitId = HU.Id
            inner join EntityDimensionValueRelation EDVR on LP.Id = EDVR.EntityId
            inner join DimensionValue DVD ON DVD.Id = EDVR.DimensionValueId
            where DVD.ID = DV.ID
            group by DVD.ID, HU.ColliNumber
            for xml path('')), 1, 1, '') [ActualColli]

  from DimensionValue DV
  inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'ReceiptGoods'
  inner join BusinessUnitPermission BUP on D.Id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Duisburg')

) ACTCOLLI on ReceiptGoods.DimensionValueId = ACTCOLLI.ID 

LEFT JOIN (
SELECT 
 distinct DV.ID, 
            STUFF((select distinct ',' + IsNull(SH.Code, '')
            from LoosePart LP
            inner join ShipmentHeader SH on LP.ShipmentHeaderId = SH.Id
            inner join EntityDimensionValueRelation EDVR on LP.Id = EDVR.EntityId
            inner join DimensionValue DVD ON DVD.Id = EDVR.DimensionValueId
            where DVD.ID = DV.ID
            group by DVD.ID, SH.Code
            for xml path('')), 1, 1, '') [ShipmentCode]

  from DimensionValue DV
  inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'ReceiptGoods'
  inner join BusinessUnitPermission BUP on D.Id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Duisburg')

) SHIPMENT on ReceiptGoods.DimensionValueId = SHIPMENT.ID 

LEFT JOIN (
SELECT 
 distinct DV.ID, 
            STUFF((select distinct ',' + IsNull(B.Description, '')
            from LoosePart LP
            inner join Bin B on LP.ActualBinId = B.Id
            inner join EntityDimensionValueRelation EDVR on LP.Id = EDVR.EntityId
            inner join DimensionValue DVD ON DVD.Id = EDVR.DimensionValueId
            where DVD.ID = DV.ID
            group by DVD.ID, B.Description
            for xml path('')), 1, 1, '') [Description]

  from DimensionValue DV
  inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'ReceiptGoods'
  inner join BusinessUnitPermission BUP on D.Id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Duisburg')

) B on ReceiptGoods.DimensionValueId = B.ID 


LEFT JOIN (
SELECT 
 distinct DV.ID, 
            STUFF((select distinct ',' + IsNull(B.Code, '')
            from LoosePart LP
            inner join Bin B on LP.ActualBinId = B.Id
            inner join EntityDimensionValueRelation EDVR on LP.Id = EDVR.EntityId
            inner join DimensionValue DVD ON DVD.Id = EDVR.DimensionValueId
            where DVD.ID = DV.ID
            group by DVD.ID, B.Code
            for xml path('')), 1, 1, '') [Code]

  from DimensionValue DV
  inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'ReceiptGoods'
  inner join BusinessUnitPermission BUP on D.Id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Duisburg')

) BIN on ReceiptGoods.DimensionValueId = BIN.ID 

LEFT JOIN (
SELECT 
 distinct DV.ID, 
            STUFF((select distinct ',' + IsNull(Z.Name, '')
            from LoosePart LP
            inner join Zone Z on LP.ActualZoneId = Z.Id
            inner join EntityDimensionValueRelation EDVR on LP.Id = EDVR.EntityId
            inner join DimensionValue DVD ON DVD.Id = EDVR.DimensionValueId
            where DVD.ID = DV.ID
            group by DVD.ID, Z.Name
            for xml path('')), 1, 1, '') [Name]

  from DimensionValue DV
  inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'ReceiptGoods'
  inner join BusinessUnitPermission BUP on D.Id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Duisburg')

) Z on ReceiptGoods.DimensionValueId = Z.ID 


LEFT JOIN (
SELECT 
 distinct DV.ID, 
            STUFF((select distinct ',' + IsNull(CV.Content, '')
            from LoosePart LP
            inner join Zone Z on LP.ActualZoneId = Z.Id
            inner join EntityDimensionValueRelation EDVR on LP.Id = EDVR.EntityId
            inner join DimensionValue DVD ON DVD.Id = EDVR.DimensionValueId
            inner join CustomValue CV on Z.Id = CV.EntityId and CV.CustomFieldId = 'a88a1229-dba4-419e-a47c-097fca73fff0'
            where DVD.ID = DV.ID
            group by DVD.ID, CV.Content
            for xml path('')), 1, 1, '') [Content]

  from DimensionValue DV
  inner join Dimension D on DV.DimensionId = D.Id and D.Name = 'ReceiptGoods'
  inner join BusinessUnitPermission BUP on D.Id = BUP.DimensionId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Duisburg')

) CV on ReceiptGoods.DimensionValueId = CV.ID 

--LEFT JOIN EntityDimensionValueRelation EDVRLP on ReceiptGoods.DimensionValueId = EDVRLP.DimensionValueId and EDVRLP.Entity = 15
--LEFT JOIN LoosePart LP on EDVRLP.EntityId = LP.Id
--LEFT JOIN HandlingUnit ACTHU on LP.ActualHandlingUnitId = ACTHU.Id
--LEFT JOIN ShipmentHeader SH on LP.ShipmentHeaderId = SH.Id
--LEFT JOIN Bin B on LP.ActualBinId = B.Id
--LEFT JOIN Zone Z on LP.ActualZoneId = Z.Id
--LEFT JOIN CustomValue CV on Z.Id = CV.EntityId and CV.CustomFieldId = 'a88a1229-dba4-419e-a47c-097fca73fff0'


where Project.ProjectNr not in ('ESSO')
and [Z].[NAME] NOT IN ('Werksverpackung', 'Außenbaustelle', 'Münsterland') 

--and Inbound.Inbound BETWEEN '2023-01-01' AND '2023-01-31'

UNION 

SELECT
'Lagerbestand' 'STATUS'
,ISNULL(ReceiptGoods.BEMERKUNG2, '') 'Siemens Versandaufgabe'
,ISNULL(ReceiptGoods.SDU_BESTELLPOS, '')  'Pos1'
,ReceiptGoodsNr 'Labelnummer'
,'' 'Dienstleister'
,NULL 'Datum WE'
,'' 'Siemens Abholavis'
,'' 'Pos2'
,'' 'Externe WA-Nummer'
,NULL 'Datum WA'
,'' 'Auftragsnummer'
,ISNULL(ReceiptGoods.BEMERKUNG7, '') 'Innenauftrag'
,ISNULL(ReceiptGoods.[SDU_KUNDENAUFTRAG], '') 'Kundenauftragsummer'
,'' 'Kennwort'
,ISNULL(ReceiptGoods.ReceiptGoods, '') 'Artikelbezeichnung'
,ISNULL(ReceiptGoods.BEMERKUNG3, '') 'Materialnummer'
,ISNULL(ReceiptGoods.BEMERKUNG5, '') 'Fauf-Nr'
,ISNULL(ReceiptGoods.SDU_BESTELLNR, '') 'Bestell-Nr'
,ISNULL(ReceiptGoods.SDU_BESTELLPOS, '') 'Bestell-Pos'
,ISNULL(ReceiptGoods.BEMERKUNG4, '') 'Banf-Nr'
,1 'Anz Stck'
,ISNULL(ReceiptGoods.HUTYPE, '') 'Verpackungsart'
,CASE WHEN ReceiptGoods.SDU_ZOLLGUT = 'true' THEN 'X' ELSE '' END 'Zollgut_ja'
,CASE WHEN ReceiptGoods.SDU_ZOLLGUT = 'false' THEN 'X' ELSE '' END 'Zollgut_nein'
,TRY_CONVERT(FLOAT, ReceiptGoods.LENGHT) 'Länge'
,TRY_CONVERT(FLOAT, ReceiptGoods.WIDTH) 'Breite'
,TRY_CONVERT(FLOAT, ReceiptGoods.HEIGHT) 'Höhe'
,0  'Netto'
,ISNULL(TRY_CONVERT(float, ReceiptGoods.GROSSW), 0) / 1000 'Brutto'
,(ReceiptGoods.Lenght / 10)  * (ReceiptGoods.Width / 10)   'Lagerfläche qm'
,'' "Halle"
,'' "Feld"
,'' "Regal"
,'' "Reihe"
,'' "Fach"
,'' 'FREIFLÄCHE'

,'' 'Kolli Nr Siemens Energy'
,ISNULL(ReceiptGoods.SDU_KENNZAHL, '') 'Kennzahl'
,'' 'Externe Komm-Nr'
,ISNULL(LoadingReceiptGoods.LoadingReceiptGoodsNr, '') 'externe WE-Nr'
,ISNULL(LoadingReceiptGoods.Supplier, '') 'Lieferant'
,'' 'externe Bemerkung'
,'' 'Pappkarton'
,'' 'BoxCAD'
,'' 'Deufol Lieferschein Nr'
,ISNULL(ReceiptGoods.SDU_VAN_ID, '') 'VAN ID'
,'' 'Summe Lagerfläche qm'
,'' 'Abrechnungsbetrag 1'
,'' 'Summe Auftragsnummer 1'
,'' 'Abrechnungsbetrag 2'
,'' 'Summe Auftragsnummer 2'
,'' 'Freifeld'

 
 from (
select
DV.ParentDimensionValueId,
DV.Id DimensionValueId ,
DV.Content ReceiptGoodsNr,
DV.[Description] ReceiptGoods, 
D.[Description] Dimension,
S.Name as Status,
DF.Name, 
DFV.Content


from DimensionValue DV --DimensionField DF
inner join DimensionFieldValue DFV on DV.id = DFV.DimensionValueId
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'ReceiptGoods'
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Duisburg')
inner join Status S on DV.StatusId = S.id
LEFT join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
where EDVR.EntityId IS NULL AND
DF.name in ('DAMAGE','DAMAGE_WHAT','DAMAGE_WHY','LENGHT','WIDTH','HEIGHT','GROSSW','HUTYPE','DANGEROUS_GOODS','IS_BILLED','INVOICE_MONTH','FREE_TEXT_INVOICE_NO','BEMERKUNG2','BEMERKUNG7','BEMERKUNG3','BEMERKUNG5','BEMERKUNG4','SDU_BESTELLNR','SDU_BESTELLPOS','SDU_ZOLLGUT','SDU_KENNZAHL','SDU_KUNDENAUFTRAG','SDU_VAN_ID'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([DAMAGE],[DAMAGE_WHAT],[DAMAGE_WHY],[LENGHT],[WIDTH],[HEIGHT],[GROSSW],[HUTYPE],[DANGEROUS_GOODS],[IS_BILLED],[INVOICE_MONTH],[FREE_TEXT_INVOICE_NO],[BEMERKUNG2],[BEMERKUNG7],[BEMERKUNG3],[BEMERKUNG5],[BEMERKUNG4],[SDU_BESTELLNR],[SDU_BESTELLPOS],[SDU_ZOLLGUT],[SDU_KENNZAHL],[SDU_KUNDENAUFTRAG],[SDU_VAN_ID])) as ReceiptGoods

inner join (select
DV.Id DimensionValueId,
DV.Content LoadingReceiptGoodsNr,
DV.[Description] LoadingReceiptGoods, 
D.[Description] Dimension,
--EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionValue DV
inner join DimensionFieldValue DFV on DV.id = DFV.DimensionValueId
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'LoadingReceiptGoods'
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Duisburg')
inner join Status S on DV.StatusId = S.id
LEFT join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
where EDVR.EntityId IS NULL AND
DF.name in ('LOADING_DATE','RESPONSIBLE_FOR_LOADING','ACCOMPANYING_DOCUMENTS','SUPPLIER','DELIVERYNOTE','DAMAGE','DAMAGE_WHY','DAMAGE_WHAT','GOODS_LABELED_AND_SCANNED','NUMBER_OF_PACKAGES_OK','NUMBER_OF_PACKAGES_OK_TEXT'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([LOADING_DATE],[RESPONSIBLE_FOR_LOADING],[ACCOMPANYING_DOCUMENTS],[SUPPLIER],[DELIVERYNOTE],[DAMAGE],[DAMAGE_WHY],[DAMAGE_WHAT],[GOODS_LABELED_AND_SCANNED],[NUMBER_OF_PACKAGES_OK],[NUMBER_OF_PACKAGES_OK_TEXT])) as LoadingReceiptGoods on ReceiptGoods.ParentDimensionValueId = LoadingReceiptGoods.DimensionValueId


