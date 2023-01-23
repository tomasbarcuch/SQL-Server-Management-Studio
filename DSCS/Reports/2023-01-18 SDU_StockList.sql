select distinct
'Lagerbestand' 'STATUS'
,IsNull(WEColliFields.BEMERKUNG2, '') 'Siemens Versandaufgabe'
,Isnull(WEColliFields.SDU_BESTELLPOS, '')  'Pos1'
,DV.Content 'Labelnummer'
,ISNULL(ZoneData.PROVIDER_NO, '') 'Dienstleister'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN CONVERT(varchar, HU.InboundDate, 104) ELSE TRY_CONVERT(varchar, TRY_CONVERT(datetime, WEFields.LOADING_DATE, 104), 104) END 'Datum WE'
,'' 'Siemens Abholavis'
,'' 'Pos2'
,ISNULL(HU.Code, '') 'Externe WA-Nummer'
,Isnull(CONVERT(varchar(12), BOXAusgang.Created, 104), '') 'Datum WA'
,ISNULL(Dimensions.Project, '') 'Auftragsnummer'
,ISNULL(WEColliFields.BEMERKUNG7, '') 'Innenauftrag'
,ISNULL(WEColliFields.[SDU_KUNDENAUFTRAG], '') 'Kundenauftragsummer'
,ISNULL(DimensionsDesc.Project, '') 'Kennwort'
,ISNULL(HU.[Description], DV.DESCRIPTION) 'Artikelbezeichnung'
,ISNULL(WEColliFields.BEMERKUNG3, '') 'Materialnummer'
,ISNULL(WEColliFields.BEMERKUNG5, '') 'Fauf-Nr'
,ISNULL(WEColliFields.SDU_BESTELLNR, '') 'Bestell-Nr'
,ISNULL(WEColliFields.SDU_BESTELLPOS, '') 'Bestell-Pos'
,ISNULL(WEColliFields.BEMERKUNG4, '') 'Banf-Nr'
,1 'Anz Stck'
,ISNULL(WEColliFields.HUTYPE, '') 'Verpackungsart'
,CASE WHEN ISNULL(WEColliFields.ZOLLGUT, 0) = 1 THEN 'X' ELSE '' END 'Zollgut_ja'
,CASE WHEN ISNULL(WEColliFields.ZOLLGUT, 0) = 0 THEN 'X' ELSE '' END 'Zollgut_nein'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Length / 10, 0) ELSE TRY_CONVERT(FLOAT, WEColliFields.Lenght) END 'Länge'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Width / 10, 0) ELSE TRY_CONVERT(FLOAT, WEColliFields.WIDTH) END 'Breite'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Height / 10, 0) ELSE TRY_CONVERT(FLOAT, WEColliFields.HEIGHT) END 'Höhe'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Netto / 1000, 0) ELSE ISNULL(TRY_CONVERT(float, WEColliFields.NETTO), 0) / 1000 END 'Netto'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Brutto / 1000, 0) ELSE ISNULL(TRY_CONVERT(float, WEColliFields.GROSSW), 0) / 1000 END 'Brutto'

,ISNULL((TRY_CAST(WEColliFields.Lenght / 10 as numeric) * TRY_CAST(WEColliFields.Width / 10 as numeric)) / 100, ISNULL((TRY_CAST(HU.Length / 10 as numeric) * TRY_CAST(HU.Width / 10 as numeric)) / 10000, 0)) 'Lagerfläche qm'

,CASE 
    WHEN SUBSTRING([ZONE].[NAME],1,1) IN ('H', 'F') AND TRY_CAST(SUBSTRING([ZONE].[NAME],2,LEN([ZONE].[NAME])-1) AS INT) < 10 THEN SUBSTRING([ZONE].[NAME],1,LEN([ZONE].[NAME])-1) + '0' + SUBSTRING([ZONE].[NAME],2,LEN([ZONE].[NAME])-1) 
    WHEN [ZONE].[NAME] LIKE '%WESEL%' THEN 'WES'
    ELSE ISNULL([ZONE].[NAME], '') END as "Halle"
,CASE 
    WHEN [BIN].[Description] LIKE '%Feld%' THEN 'F' + SUBSTRING([BIN].[Description],6,LEN([BIN].[Description])-5)
    WHEN SUBSTRING([ZONE].[NAME],1,1) = 'F' THEN [ZONE].[NAME] 
    ELSE '' 
END AS "Feld"
,CASE WHEN [BIN].[Description] LIKE '%Regal%' THEN SUBSTRING([BIN].[Code], 1, 2) ELSE '' END AS "Regal"
,CASE WHEN [BIN].[Description] LIKE '%Regal%' THEN SUBSTRING([BIN].[Code], 3, 2) ELSE '' END AS "Reihe"
,CASE WHEN [BIN].[Description] LIKE '%Regal%' THEN SUBSTRING([BIN].[Code], 5, 2) ELSE '' END AS "Fach"
,CASE WHEN SUBSTRING([ZONE].[NAME],1,1) = 'F' THEN 'X' ELSE '' END AS 'FREIFLÄCHE'

,ISNULL(HU.ColliNumber, '') 'Kolli Nr Siemens Energy'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN Isnull(WEColliFieldsHeader.SDU_Kennzahl, '') ELSE Isnull(WEColliFields.SDU_Kennzahl, '') END 'Kennzahl'
,ISNULL(HU.InboundCode, '') 'Externe Komm-Nr'
,ISNULL(DV.Content, '') 'externe WE-Nr'
,ISNULL(WEFields.Supplier, '') 'Lieferant'
,'' 'externe Bemerkung'
,'' 'Pappkarton'
,ISNULL(HU.Code, '') 'Boxcad'
,ISNULL(SHH.Code, '') 'Deufol Lieferschein Nr'
,Isnull(WEColliFields.SDU_VAN_ID, '') 'VAN ID'
,'' 'Summe Lagerfläche qm'
,'' 'Abrechnungsbetrag 1'
,'' 'Summe Auftragsnummer 1'
,'' 'Abrechnungsbetrag 2'
,'' 'Summe Auftragsnummer 2'
,'' 'Freifeld'

from Dimension D  WITH (NOLOCK) 
inner join DimensionValue DV with (nolock) on DV.DimensionId = D.id 

INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'

LEFT join [Status] sWE WITH (NOLOCK) on DV.statusid = sWE.id
LEFT join EntityDimensionValueRelation EDVR WITH (NOLOCK) on (Dv.Id = EDVR.DimensionValueId OR Dv.ParentDimensionValueId = EDVR.DimensionValueId) and edvr.entity = 11
LEFT join HandlingUnit HU WITH (NOLOCK) ON EDVR.EntityId = HU.Id
LEFT join [Status] sHU WITH (NOLOCK) on HU.statusid = sHU.id
left join [Bin] WITH (NOLOCK) on [Bin].[Id] = HU.[ActualBinId]
left join [Location] WITH (NOLOCK) ON [Location].Id = HU.ActualLocationId
left join [Zone] WITH (NOLOCK) ON [Zone].Id = HU.ActualZoneId
left join ShipmentLine SHL WITH (NOLOCK) ON SHL.HandlingUnitId = HU.ID
left JOIN ShipmentHeader SHH WITH (NOLOCK) ON SHH.ID = SHL.ShipmentHeaderId

-- LoadingReceiptGoods Data
left join (
    select
    DV.ID,
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = ('LoadingReceiptGoods')
    INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'
    where
    [DF].[Name] in ('LOADING_DATE','ORDERNO','COMMISSIONNO','SUPPLIER','DELIVERYNOTE')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([LOADING_DATE],[ORDERNO],[COMMISSIONNO],[SUPPLIER],[DELIVERYNOTE])
) as [WEFields] on [DV].ParentDimensionValueId = [WEFields].ID 

-- ReceiptGoods Data
LEFT join (
    select
    DV.ID,
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = ('ReceiptGoods')
    INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'
    where
    [DF].[Name] in ('COLLI_NUMBER_EXTERN','LENGHT','HEIGHT','WIDTH','DUTY','HUTYPE','DELIVERYNOTE','KEYWORD','BEMERKUNG2','BEMERKUNG3','BEMERKUNG4','BEMERKUNG5','BEMERKUNG7','SDU_BESTELLNR','SDU_BESTELLPOS','ZOLLGUT','SDU_KENNZAHL','SDU_KUNDENAUFTRAG','SDU_VAN_ID','GROSSW','NETTO','ORDERNO','COMMISSIONNO')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([COLLI_NUMBER_EXTERN],[LENGHT],[HEIGHT],[WIDTH],[DUTY],[HUTYPE],[DELIVERYNOTE],[KEYWORD],[BEMERKUNG2],[BEMERKUNG3],[BEMERKUNG4],[BEMERKUNG5],[BEMERKUNG7],[SDU_BESTELLNR],[SDU_BESTELLPOS],[ZOLLGUT],[SDU_KENNZAHL],[SDU_KUNDENAUFTRAG],[SDU_VAN_ID],[GROSSW],[NETTO],[ORDERNO],[COMMISSIONNO])
) as [WEColliFields] on [DV].[Id] = [WEColliFields].[Id]

-- ReceiptGoods Header
LEFT join (
    select
    DV.ID,
    dv.ParentDimensionValueId,
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = ('ReceiptGoods')
    INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'
    where
    [DF].[Name] in ('COLLI_NUMBER_EXTERN','LENGHT','HEIGHT','WIDTH','DUTY','HUTYPE','DELIVERYNOTE','KEYWORD','BEMERKUNG2','BEMERKUNG3','BEMERKUNG4','BEMERKUNG5','BEMERKUNG7','SDU_BESTELLNR','SDU_BESTELLPOS','ZOLLGUT','SDU_KENNZAHL','SDU_KUNDENAUFTRAG','SDU_VAN_ID','GROSSW','NETTO','ORDERNO','COMMISSIONNO')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([COLLI_NUMBER_EXTERN],[LENGHT],[HEIGHT],[WIDTH],[DUTY],[HUTYPE],[DELIVERYNOTE],[KEYWORD],[BEMERKUNG2],[BEMERKUNG3],[BEMERKUNG4],[BEMERKUNG5],[BEMERKUNG7],[SDU_BESTELLNR],[SDU_BESTELLPOS],[ZOLLGUT],[SDU_KENNZAHL],[SDU_KUNDENAUFTRAG],[SDU_VAN_ID],[GROSSW],[NETTO],[ORDERNO],[COMMISSIONNO])
) as [WEColliFieldsHeader] on [DV].[ID] = [WEColliFieldsHeader].[ParentDimensionValueId]

left join (
    select 
    CV.content,
    CF.Name,
    CV.EntityId
    from CustomValue CV
    inner join CustomField CF ON CF.Id = CV.CustomFieldId 
    where CF.name in ('PROVIDER_NO') 
) SRC
    PIVOT (max(src.Content) for SRC.Name in ([PROVIDER_NO])
) as ZONEDATA on [Zone].id = ZONEDATA.EntityId 

left join (
    select
    DV.ID,
    [DV].[Content] [ProjectNr],
    [DV].[Description] [Project],
    [D].[Description] [Dimemsion],
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = 'Project'
    where
    [DF].[Name] in ('PackingType','SDU_KENNWORT','KEYWORD','MACHINE')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([PackingType],[SDU_KENNWORT],[KEYWORD],[MACHINE])
) as [ProFields] on [DV].[Id] = [ProFields].[Id]

LEFT JOIN (
    select 
    D.name, 
    DV.Content+' '+isnull(DV.[Description],'') as content,
    edvr.EntityId from DimensionValue DV 
    inner join Dimension D on DV.DimensionId = D.id 
    inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
    where D.name in ('Customer','Project','Order','Commission') ) SRC
        PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
) as Dimensions on EDVR.EntityId = Dimensions.EntityId

LEFT JOIN (
    select 
    D.name, 
    DV.Content as content,
    edvr.EntityId from DimensionValue DV 
    inner join Dimension D on DV.DimensionId = D.id 
    inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
    where D.name in ('Customer','Project','Order','Commission') ) SRC
        PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
) as DimensionsDesc on EDVR.EntityId = DimensionsDesc.EntityId

LEFT JOIN  (
    select
    max(WFE.created) over (PARTITION by WFE.EntityId) as FirstCreated, 
    Wfe.Created,
    WFE.EntityId,
    U.FirstName+' '+U.LastName [User],
    BU.Name as BU
    from WorkflowEntry WFE  WITH (NOLOCK)
    inner join [User] U WITH (NOLOCK) on WFE.CreatedById = u.Id
    inner join BusinessUnit BU WITH (NOLOCK) on WFE.BusinessUnitId = BU.Id
    where WFE.StatusId in (select id from status WITH (NOLOCK) where name IN ('ON_SHIPMENT', 'ON_THE_WAY')
) and WFE.Entity IN (11)
) BOXAusgang on HU.id = BOXAusgang.EntityId and BOXAusgang.FirstCreated = BOXAusgang.Created 

where DV.Description not like '%Esso Service%'
and shu.id IN (select S.id from [Status] S
    inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BUP.BusinessUnitID = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    where S.name IN ('ON_STOCK','CLOSED','READY_FOR_LOADING','ITEM_INSIDE')
    and S.NAME NOT IN ('CANCELED'))
and ISNULL([ZONE].[NAME], '') NOT IN ('Werksverpackung', 'Außenbaustelle', 'Münsterland')  
and d.name in ('ReceiptGoods', 'LoadingReceiptGoods')


UNION


select distinct
'Verpackte' 'STATUS'
,IsNull(WEColliFields.BEMERKUNG2, '') 'Siemens Versandaufgabe'
,Isnull(WEColliFields.SDU_BESTELLPOS, '')  'Pos1'
,DV.Content 'Labelnummer'
,ISNULL(ZoneData.PROVIDER_NO, '') 'Dienstleister'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN CONVERT(varchar, HU.InboundDate, 104) ELSE TRY_CONVERT(varchar, TRY_CONVERT(datetime, WEFields.LOADING_DATE, 104), 104) END 'Datum WE'
,'' 'Siemens Abholavis'
,'' 'Pos2'
,ISNULL(HU.Code, '') 'Externe WA-Nummer'
,Isnull(CONVERT(varchar(12), BOXAusgang.Created, 104), '') 'Datum WA'
,ISNULL(Dimensions.Project, '') 'Auftragsnummer'
,ISNULL(WEColliFields.BEMERKUNG7, '') 'Innenauftrag'
,ISNULL(WEColliFields.[SDU_KUNDENAUFTRAG], '') 'Kundenauftragsummer'
,ISNULL(DimensionsDesc.Project, '') 'Kennwort'
,ISNULL(HU.[Description], DV.DESCRIPTION) 'Artikelbezeichnung'
,ISNULL(WEColliFields.BEMERKUNG3, '') 'Materialnummer'
,ISNULL(WEColliFields.BEMERKUNG5, '') 'Fauf-Nr'
,ISNULL(WEColliFields.SDU_BESTELLNR, '') 'Bestell-Nr'
,ISNULL(WEColliFields.SDU_BESTELLPOS, '') 'Bestell-Pos'
,ISNULL(WEColliFields.BEMERKUNG4, '') 'Banf-Nr'
,1 'Anz Stck'
,ISNULL(WEColliFields.HUTYPE, '') 'Verpackungsart'
,CASE WHEN ISNULL(WEColliFields.ZOLLGUT, 0) = 1 THEN 'X' ELSE '' END 'Zollgut_ja'
,CASE WHEN ISNULL(WEColliFields.ZOLLGUT, 0) = 0 THEN 'X' ELSE '' END 'Zollgut_nein'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Length / 10, 0) ELSE TRY_CONVERT(FLOAT, WEColliFields.Lenght) END 'Länge'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Width / 10, 0) ELSE TRY_CONVERT(FLOAT, WEColliFields.WIDTH) END 'Breite'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Height / 10, 0) ELSE TRY_CONVERT(FLOAT, WEColliFields.HEIGHT) END 'Höhe'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Netto / 1000, 0) ELSE ISNULL(TRY_CONVERT(float, WEColliFields.NETTO), 0) / 1000 END 'Netto'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Brutto / 1000, 0) ELSE ISNULL(TRY_CONVERT(float, WEColliFields.GROSSW), 0) / 1000 END 'Brutto'

,ISNULL((TRY_CAST(WEColliFields.Lenght / 10 as numeric) * TRY_CAST(WEColliFields.Width / 10 as numeric)) / 100, ISNULL((TRY_CAST(HU.Length / 10 as numeric) * TRY_CAST(HU.Width / 10 as numeric)) / 10000, 0)) 'Lagerfläche qm'

,CASE 
    WHEN SUBSTRING([ZONE].[NAME],1,1) IN ('H', 'F') AND TRY_CAST(SUBSTRING([ZONE].[NAME],2,LEN([ZONE].[NAME])-1) AS INT) < 10 THEN SUBSTRING([ZONE].[NAME],1,LEN([ZONE].[NAME])-1) + '0' + SUBSTRING([ZONE].[NAME],2,LEN([ZONE].[NAME])-1) 
    WHEN [ZONE].[NAME] LIKE '%WESEL%' THEN 'WES'
    ELSE ISNULL([ZONE].[NAME], '') END as "Halle"
,CASE 
    WHEN [BIN].[Description] LIKE '%Feld%' THEN 'F' + SUBSTRING([BIN].[Description],6,LEN([BIN].[Description])-5)
    WHEN SUBSTRING([ZONE].[NAME],1,1) = 'F' THEN [ZONE].[NAME] 
    ELSE '' 
END AS "Feld"
,CASE WHEN [BIN].[Description] LIKE '%Regal%' THEN SUBSTRING([BIN].[Code], 1, 2) ELSE '' END AS "Regal"
,CASE WHEN [BIN].[Description] LIKE '%Regal%' THEN SUBSTRING([BIN].[Code], 3, 2) ELSE '' END AS "Reihe"
,CASE WHEN [BIN].[Description] LIKE '%Regal%' THEN SUBSTRING([BIN].[Code], 5, 2) ELSE '' END AS "Fach"
,CASE WHEN SUBSTRING([ZONE].[NAME],1,1) = 'F' THEN 'X' ELSE '' END AS 'FREIFLÄCHE'

,ISNULL(HU.ColliNumber, '') 'Kolli Nr Siemens Energy'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN Isnull(WEColliFieldsHeader.SDU_Kennzahl, '') ELSE Isnull(WEColliFields.SDU_Kennzahl, '') END 'Kennzahl'
,ISNULL(HU.InboundCode, '') 'Externe Komm-Nr'
,ISNULL(DV.Content, '') 'externe WE-Nr'
,ISNULL(WEFields.Supplier, '') 'Lieferant'
,'' 'externe Bemerkung'
,'' 'Pappkarton'
,ISNULL(HU.Code, '') 'Boxcad'
,ISNULL(SHH.Code, '') 'Deufol Lieferschein Nr'
,Isnull(WEColliFields.SDU_VAN_ID, '') 'VAN ID'
,'' 'Summe Lagerfläche qm'
,'' 'Abrechnungsbetrag 1'
,'' 'Summe Auftragsnummer 1'
,'' 'Abrechnungsbetrag 2'
,'' 'Summe Auftragsnummer 2'
,'' 'Freifeld'

from Dimension D  WITH (NOLOCK) 
inner join DimensionValue DV with (nolock) on DV.DimensionId = D.id 

INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'

LEFT join [Status] sWE WITH (NOLOCK) on DV.statusid = sWE.id
LEFT join EntityDimensionValueRelation EDVR WITH (NOLOCK) on (Dv.Id = EDVR.DimensionValueId OR Dv.ParentDimensionValueId = EDVR.DimensionValueId) and edvr.entity = 11
LEFT join HandlingUnit HU WITH (NOLOCK) ON EDVR.EntityId = HU.Id
LEFT join [Status] sHU WITH (NOLOCK) on HU.statusid = sHU.id
left join [Bin] WITH (NOLOCK) on [Bin].[Id] = HU.[ActualBinId]
left join [Location] WITH (NOLOCK) ON [Location].Id = HU.ActualLocationId
left join [Zone] WITH (NOLOCK) ON [Zone].Id = HU.ActualZoneId
left join ShipmentLine SHL WITH (NOLOCK) ON SHL.HandlingUnitId = HU.ID
left JOIN ShipmentHeader SHH WITH (NOLOCK) ON SHH.ID = SHL.ShipmentHeaderId

-- LoadingReceiptGoods Data
left join (
    select
    DV.ID,
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = ('LoadingReceiptGoods')
    INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'
    where
    [DF].[Name] in ('LOADING_DATE','ORDERNO','COMMISSIONNO','SUPPLIER','DELIVERYNOTE')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([LOADING_DATE],[ORDERNO],[COMMISSIONNO],[SUPPLIER],[DELIVERYNOTE])
) as [WEFields] on [DV].ParentDimensionValueId = [WEFields].ID 

-- ReceiptGoods Data
LEFT join (
    select
    DV.ID,
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = ('ReceiptGoods')
    INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'
    where
    [DF].[Name] in ('COLLI_NUMBER_EXTERN','LENGHT','HEIGHT','WIDTH','DUTY','HUTYPE','DELIVERYNOTE','KEYWORD','BEMERKUNG2','BEMERKUNG3','BEMERKUNG4','BEMERKUNG5','BEMERKUNG7','SDU_BESTELLNR','SDU_BESTELLPOS','ZOLLGUT','SDU_KENNZAHL','SDU_KUNDENAUFTRAG','SDU_VAN_ID','GROSSW','NETTO','ORDERNO','COMMISSIONNO')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([COLLI_NUMBER_EXTERN],[LENGHT],[HEIGHT],[WIDTH],[DUTY],[HUTYPE],[DELIVERYNOTE],[KEYWORD],[BEMERKUNG2],[BEMERKUNG3],[BEMERKUNG4],[BEMERKUNG5],[BEMERKUNG7],[SDU_BESTELLNR],[SDU_BESTELLPOS],[ZOLLGUT],[SDU_KENNZAHL],[SDU_KUNDENAUFTRAG],[SDU_VAN_ID],[GROSSW],[NETTO],[ORDERNO],[COMMISSIONNO])
) as [WEColliFields] on [DV].[Id] = [WEColliFields].[Id]

-- ReceiptGoods Header
LEFT join (
    select
    DV.ID,
    dv.ParentDimensionValueId,
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = ('ReceiptGoods')
    INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'
    where
    [DF].[Name] in ('COLLI_NUMBER_EXTERN','LENGHT','HEIGHT','WIDTH','DUTY','HUTYPE','DELIVERYNOTE','KEYWORD','BEMERKUNG2','BEMERKUNG3','BEMERKUNG4','BEMERKUNG5','BEMERKUNG7','SDU_BESTELLNR','SDU_BESTELLPOS','ZOLLGUT','SDU_KENNZAHL','SDU_KUNDENAUFTRAG','SDU_VAN_ID','GROSSW','NETTO','ORDERNO','COMMISSIONNO')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([COLLI_NUMBER_EXTERN],[LENGHT],[HEIGHT],[WIDTH],[DUTY],[HUTYPE],[DELIVERYNOTE],[KEYWORD],[BEMERKUNG2],[BEMERKUNG3],[BEMERKUNG4],[BEMERKUNG5],[BEMERKUNG7],[SDU_BESTELLNR],[SDU_BESTELLPOS],[ZOLLGUT],[SDU_KENNZAHL],[SDU_KUNDENAUFTRAG],[SDU_VAN_ID],[GROSSW],[NETTO],[ORDERNO],[COMMISSIONNO])
) as [WEColliFieldsHeader] on [DV].[ID] = [WEColliFieldsHeader].[ParentDimensionValueId]

left join (
    select 
    CV.content,
    CF.Name,
    CV.EntityId
    from CustomValue CV
    inner join CustomField CF ON CF.Id = CV.CustomFieldId 
    where CF.name in ('PROVIDER_NO') 
) SRC
    PIVOT (max(src.Content) for SRC.Name in ([PROVIDER_NO])
) as ZONEDATA on [Zone].id = ZONEDATA.EntityId 

left join (
    select
    DV.ID,
    [DV].[Content] [ProjectNr],
    [DV].[Description] [Project],
    [D].[Description] [Dimemsion],
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = 'Project'
    where
    [DF].[Name] in ('PackingType','SDU_KENNWORT','KEYWORD','MACHINE')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([PackingType],[SDU_KENNWORT],[KEYWORD],[MACHINE])
) as [ProFields] on [DV].[Id] = [ProFields].[Id]

LEFT JOIN (
    select 
    D.name, 
    DV.Content+' '+isnull(DV.[Description],'') as content,
    edvr.EntityId from DimensionValue DV 
    inner join Dimension D on DV.DimensionId = D.id 
    inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
    where D.name in ('Customer','Project','Order','Commission') ) SRC
        PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
) as Dimensions on EDVR.EntityId = Dimensions.EntityId

LEFT JOIN (
    select 
    D.name, 
    DV.Content as content,
    edvr.EntityId from DimensionValue DV 
    inner join Dimension D on DV.DimensionId = D.id 
    inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
    where D.name in ('Customer','Project','Order','Commission') ) SRC
        PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
) as DimensionsDesc on EDVR.EntityId = DimensionsDesc.EntityId

LEFT JOIN  (
    select
    max(WFE.created) over (PARTITION by WFE.EntityId) as FirstCreated, 
    Wfe.Created,
    WFE.EntityId,
    U.FirstName+' '+U.LastName [User],
    BU.Name as BU
    from WorkflowEntry WFE  WITH (NOLOCK)
    inner join [User] U WITH (NOLOCK) on WFE.CreatedById = u.Id
    inner join BusinessUnit BU WITH (NOLOCK) on WFE.BusinessUnitId = BU.Id
    where WFE.StatusId in (select id from status WITH (NOLOCK) where name IN ('ON_SHIPMENT', 'ON_THE_WAY')
) and WFE.Entity IN (11)
) BOXAusgang on HU.id = BOXAusgang.EntityId and BOXAusgang.FirstCreated = BOXAusgang.Created 

where DV.Description not like '%Esso Service%'
and shu.id IN (select S.id from [Status] S
    inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BUP.BusinessUnitID = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    where S.name IN ('PACKED','IN_CRATE','MARKING')
    and S.NAME NOT IN ('CANCELED'))
and ISNULL([ZONE].[NAME], '') NOT IN ('Werksverpackung', 'Außenbaustelle', 'Münsterland')    
and d.name in ('ReceiptGoods', 'LoadingReceiptGoods')


UNION


select distinct
'Auslieferungen' 'STATUS'
,IsNull(WEColliFields.BEMERKUNG2, '') 'Siemens Versandaufgabe'
,Isnull(WEColliFields.SDU_BESTELLPOS, '')  'Pos1'
,DV.Content 'Labelnummer'
,ISNULL(ZoneData.PROVIDER_NO, '') 'Dienstleister'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN CONVERT(varchar, HU.InboundDate, 104) ELSE TRY_CONVERT(varchar, TRY_CONVERT(datetime, WEFields.LOADING_DATE, 104), 104) END 'Datum WE'
,'' 'Siemens Abholavis'
,'' 'Pos2'
,ISNULL(HU.Code, '') 'Externe WA-Nummer'
,Isnull(CONVERT(varchar(12), BOXAusgang.Created, 104), '') 'Datum WA'
,ISNULL(Dimensions.Project, '') 'Auftragsnummer'
,ISNULL(WEColliFields.BEMERKUNG7, '') 'Innenauftrag'
,ISNULL(WEColliFields.[SDU_KUNDENAUFTRAG], '') 'Kundenauftragsummer'
,ISNULL(DimensionsDesc.Project, '') 'Kennwort'
,ISNULL(HU.[Description], DV.DESCRIPTION) 'Artikelbezeichnung'
,ISNULL(WEColliFields.BEMERKUNG3, '') 'Materialnummer'
,ISNULL(WEColliFields.BEMERKUNG5, '') 'Fauf-Nr'
,ISNULL(WEColliFields.SDU_BESTELLNR, '') 'Bestell-Nr'
,ISNULL(WEColliFields.SDU_BESTELLPOS, '') 'Bestell-Pos'
,ISNULL(WEColliFields.BEMERKUNG4, '') 'Banf-Nr'
,1 'Anz Stck'
,ISNULL(WEColliFields.HUTYPE, '') 'Verpackungsart'
,CASE WHEN ISNULL(WEColliFields.ZOLLGUT, 0) = 1 THEN 'X' ELSE '' END 'Zollgut_ja'
,CASE WHEN ISNULL(WEColliFields.ZOLLGUT, 0) = 0 THEN 'X' ELSE '' END 'Zollgut_nein'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Length / 10, 0) ELSE TRY_CONVERT(FLOAT, WEColliFields.Lenght) END 'Länge'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Width / 10, 0) ELSE TRY_CONVERT(FLOAT, WEColliFields.WIDTH) END 'Breite'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Height / 10, 0) ELSE TRY_CONVERT(FLOAT, WEColliFields.HEIGHT) END 'Höhe'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Netto / 1000, 0) ELSE ISNULL(TRY_CONVERT(float, WEColliFields.NETTO), 0) / 1000 END 'Netto'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Brutto / 1000, 0) ELSE ISNULL(TRY_CONVERT(float, WEColliFields.GROSSW), 0) / 1000 END 'Brutto'

,ISNULL((TRY_CAST(WEColliFields.Lenght / 10 as numeric) * TRY_CAST(WEColliFields.Width / 10 as numeric)) / 100, ISNULL((TRY_CAST(HU.Length / 10 as numeric) * TRY_CAST(HU.Width / 10 as numeric)) / 10000, 0)) 'Lagerfläche qm'

,CASE 
    WHEN SUBSTRING([ZONE].[NAME],1,1) IN ('H', 'F') AND TRY_CAST(SUBSTRING([ZONE].[NAME],2,LEN([ZONE].[NAME])-1) AS INT) < 10 THEN SUBSTRING([ZONE].[NAME],1,LEN([ZONE].[NAME])-1) + '0' + SUBSTRING([ZONE].[NAME],2,LEN([ZONE].[NAME])-1) 
    WHEN [ZONE].[NAME] LIKE '%WESEL%' THEN 'WES'
    ELSE ISNULL([ZONE].[NAME], '') END as "Halle"
,CASE 
    WHEN [BIN].[Description] LIKE '%Feld%' THEN 'F' + SUBSTRING([BIN].[Description],6,LEN([BIN].[Description])-5)
    WHEN SUBSTRING([ZONE].[NAME],1,1) = 'F' THEN [ZONE].[NAME] 
    ELSE '' 
END AS "Feld"
,CASE WHEN [BIN].[Description] LIKE '%Regal%' THEN SUBSTRING([BIN].[Code], 1, 2) ELSE '' END AS "Regal"
,CASE WHEN [BIN].[Description] LIKE '%Regal%' THEN SUBSTRING([BIN].[Code], 3, 2) ELSE '' END AS "Reihe"
,CASE WHEN [BIN].[Description] LIKE '%Regal%' THEN SUBSTRING([BIN].[Code], 5, 2) ELSE '' END AS "Fach"
,CASE WHEN SUBSTRING([ZONE].[NAME],1,1) = 'F' THEN 'X' ELSE '' END AS 'FREIFLÄCHE'

,ISNULL(HU.ColliNumber, '') 'Kolli Nr Siemens Energy'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN Isnull(WEColliFieldsHeader.SDU_Kennzahl, '') ELSE Isnull(WEColliFields.SDU_Kennzahl, '') END 'Kennzahl'
,ISNULL(HU.InboundCode, '') 'Externe Komm-Nr'
,ISNULL(DV.Content, '') 'externe WE-Nr'
,ISNULL(WEFields.Supplier, '') 'Lieferant'
,'' 'externe Bemerkung'
,'' 'Pappkarton'
,ISNULL(HU.Code, '') 'Boxcad'
,ISNULL(SHH.Code, '') 'Deufol Lieferschein Nr'
,Isnull(WEColliFields.SDU_VAN_ID, '') 'VAN ID'
,'' 'Summe Lagerfläche qm'
,'' 'Abrechnungsbetrag 1'
,'' 'Summe Auftragsnummer 1'
,'' 'Abrechnungsbetrag 2'
,'' 'Summe Auftragsnummer 2'
,'' 'Freifeld'

from Dimension D  WITH (NOLOCK) 
inner join DimensionValue DV with (nolock) on DV.DimensionId = D.id 

INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'

LEFT join [Status] sWE WITH (NOLOCK) on DV.statusid = sWE.id
LEFT join EntityDimensionValueRelation EDVR WITH (NOLOCK) on (Dv.Id = EDVR.DimensionValueId OR Dv.ParentDimensionValueId = EDVR.DimensionValueId) and edvr.entity = 11
LEFT join HandlingUnit HU WITH (NOLOCK) ON EDVR.EntityId = HU.Id
LEFT join [Status] sHU WITH (NOLOCK) on HU.statusid = sHU.id
left join [Bin] WITH (NOLOCK) on [Bin].[Id] = HU.[ActualBinId]
left join [Location] WITH (NOLOCK) ON [Location].Id = HU.ActualLocationId
left join [Zone] WITH (NOLOCK) ON [Zone].Id = HU.ActualZoneId
left join ShipmentLine SHL WITH (NOLOCK) ON SHL.HandlingUnitId = HU.ID
left JOIN ShipmentHeader SHH WITH (NOLOCK) ON SHH.ID = SHL.ShipmentHeaderId

-- LoadingReceiptGoods Data
left join (
    select
    DV.ID,
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = ('LoadingReceiptGoods')
    INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'
    where
    [DF].[Name] in ('LOADING_DATE','ORDERNO','COMMISSIONNO','SUPPLIER','DELIVERYNOTE')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([LOADING_DATE],[ORDERNO],[COMMISSIONNO],[SUPPLIER],[DELIVERYNOTE])
) as [WEFields] on [DV].ParentDimensionValueId = [WEFields].ID 

-- ReceiptGoods Data
LEFT join (
    select
    DV.ID,
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = ('ReceiptGoods')
    INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'
    where
    [DF].[Name] in ('COLLI_NUMBER_EXTERN','LENGHT','HEIGHT','WIDTH','DUTY','HUTYPE','DELIVERYNOTE','KEYWORD','BEMERKUNG2','BEMERKUNG3','BEMERKUNG4','BEMERKUNG5','BEMERKUNG7','SDU_BESTELLNR','SDU_BESTELLPOS','ZOLLGUT','SDU_KENNZAHL','SDU_KUNDENAUFTRAG','SDU_VAN_ID','GROSSW','NETTO','ORDERNO','COMMISSIONNO')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([COLLI_NUMBER_EXTERN],[LENGHT],[HEIGHT],[WIDTH],[DUTY],[HUTYPE],[DELIVERYNOTE],[KEYWORD],[BEMERKUNG2],[BEMERKUNG3],[BEMERKUNG4],[BEMERKUNG5],[BEMERKUNG7],[SDU_BESTELLNR],[SDU_BESTELLPOS],[ZOLLGUT],[SDU_KENNZAHL],[SDU_KUNDENAUFTRAG],[SDU_VAN_ID],[GROSSW],[NETTO],[ORDERNO],[COMMISSIONNO])
) as [WEColliFields] on [DV].[Id] = [WEColliFields].[Id]

-- ReceiptGoods Header
LEFT join (
    select
    DV.ID,
    dv.ParentDimensionValueId,
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = ('ReceiptGoods')
    INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'
    where
    [DF].[Name] in ('COLLI_NUMBER_EXTERN','LENGHT','HEIGHT','WIDTH','DUTY','HUTYPE','DELIVERYNOTE','KEYWORD','BEMERKUNG2','BEMERKUNG3','BEMERKUNG4','BEMERKUNG5','BEMERKUNG7','SDU_BESTELLNR','SDU_BESTELLPOS','ZOLLGUT','SDU_KENNZAHL','SDU_KUNDENAUFTRAG','SDU_VAN_ID','GROSSW','NETTO','ORDERNO','COMMISSIONNO')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([COLLI_NUMBER_EXTERN],[LENGHT],[HEIGHT],[WIDTH],[DUTY],[HUTYPE],[DELIVERYNOTE],[KEYWORD],[BEMERKUNG2],[BEMERKUNG3],[BEMERKUNG4],[BEMERKUNG5],[BEMERKUNG7],[SDU_BESTELLNR],[SDU_BESTELLPOS],[ZOLLGUT],[SDU_KENNZAHL],[SDU_KUNDENAUFTRAG],[SDU_VAN_ID],[GROSSW],[NETTO],[ORDERNO],[COMMISSIONNO])
) as [WEColliFieldsHeader] on [DV].[ID] = [WEColliFieldsHeader].[ParentDimensionValueId]

left join (
    select 
    CV.content,
    CF.Name,
    CV.EntityId
    from CustomValue CV
    inner join CustomField CF ON CF.Id = CV.CustomFieldId 
    where CF.name in ('PROVIDER_NO') 
) SRC
    PIVOT (max(src.Content) for SRC.Name in ([PROVIDER_NO])
) as ZONEDATA on [Zone].id = ZONEDATA.EntityId 

left join (
    select
    DV.ID,
    [DV].[Content] [ProjectNr],
    [DV].[Description] [Project],
    [D].[Description] [Dimemsion],
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = 'Project'
    where
    [DF].[Name] in ('PackingType','SDU_KENNWORT','KEYWORD','MACHINE')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([PackingType],[SDU_KENNWORT],[KEYWORD],[MACHINE])
) as [ProFields] on [DV].[Id] = [ProFields].[Id]

LEFT JOIN (
    select 
    D.name, 
    DV.Content+' '+isnull(DV.[Description],'') as content,
    edvr.EntityId from DimensionValue DV 
    inner join Dimension D on DV.DimensionId = D.id 
    inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
    where D.name in ('Customer','Project','Order','Commission') ) SRC
        PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
) as Dimensions on EDVR.EntityId = Dimensions.EntityId

LEFT JOIN (
    select 
    D.name, 
    DV.Content as content,
    edvr.EntityId from DimensionValue DV 
    inner join Dimension D on DV.DimensionId = D.id 
    inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
    where D.name in ('Customer','Project','Order','Commission') ) SRC
        PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
) as DimensionsDesc on EDVR.EntityId = DimensionsDesc.EntityId

LEFT JOIN  (
    select
    max(WFE.created) over (PARTITION by WFE.EntityId) as FirstCreated, 
    Wfe.Created,
    WFE.EntityId,
    U.FirstName+' '+U.LastName [User],
    BU.Name as BU
    from WorkflowEntry WFE  WITH (NOLOCK)
    inner join [User] U WITH (NOLOCK) on WFE.CreatedById = u.Id
    inner join BusinessUnit BU WITH (NOLOCK) on WFE.BusinessUnitId = BU.Id
    where WFE.StatusId in (select id from status WITH (NOLOCK) where name IN ('ON_SHIPMENT', 'ON_THE_WAY')
) and WFE.Entity IN (11)
) BOXAusgang on HU.id = BOXAusgang.EntityId and BOXAusgang.FirstCreated = BOXAusgang.Created 

where DV.Description not like '%Esso Service%'
and shu.id IN (select S.id from [Status] S
    inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BUP.BusinessUnitID = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    where S.name IN ('ON_SHIPMENT','ON_THE_WAY')
    and S.NAME NOT IN ('CANCELED'))
and ISNULL([ZONE].[NAME], '') NOT IN ('Werksverpackung', 'Außenbaustelle', 'Münsterland')
and d.name in ('ReceiptGoods', 'LoadingReceiptGoods')


UNION


select distinct
'Esso Service' 'STATUS'
,IsNull(WEColliFields.BEMERKUNG2, '') 'Siemens Versandaufgabe'
,Isnull(WEColliFields.SDU_BESTELLPOS, '')  'Pos1'
,DV.Content 'Labelnummer'
,ISNULL(ZoneData.PROVIDER_NO, '') 'Dienstleister'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN CONVERT(varchar, HU.InboundDate, 104) ELSE TRY_CONVERT(varchar, TRY_CONVERT(datetime, WEFields.LOADING_DATE, 104), 104) END 'Datum WE'
,'' 'Siemens Abholavis'
,'' 'Pos2'
,ISNULL(HU.Code, '') 'Externe WA-Nummer'
,Isnull(CONVERT(varchar(12), BOXAusgang.Created, 104), '') 'Datum WA'
,ISNULL(Dimensions.Project, '') 'Auftragsnummer'
,ISNULL(WEColliFields.BEMERKUNG7, '') 'Innenauftrag'
,ISNULL(WEColliFields.[SDU_KUNDENAUFTRAG], '') 'Kundenauftragsummer'
,ISNULL(DimensionsDesc.Project, '') 'Kennwort'
,ISNULL(HU.[Description], DV.DESCRIPTION) 'Artikelbezeichnung'
,ISNULL(WEColliFields.BEMERKUNG3, '') 'Materialnummer'
,ISNULL(WEColliFields.BEMERKUNG5, '') 'Fauf-Nr'
,ISNULL(WEColliFields.SDU_BESTELLNR, '') 'Bestell-Nr'
,ISNULL(WEColliFields.SDU_BESTELLPOS, '') 'Bestell-Pos'
,ISNULL(WEColliFields.BEMERKUNG4, '') 'Banf-Nr'
,1 'Anz Stck'
,ISNULL(WEColliFields.HUTYPE, '') 'Verpackungsart'
,CASE WHEN ISNULL(WEColliFields.ZOLLGUT, 0) = 1 THEN 'X' ELSE '' END 'Zollgut_ja'
,CASE WHEN ISNULL(WEColliFields.ZOLLGUT, 0) = 0 THEN 'X' ELSE '' END 'Zollgut_nein'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Length / 10, 0) ELSE TRY_CONVERT(FLOAT, WEColliFields.Lenght) END 'Länge'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Width / 10, 0) ELSE TRY_CONVERT(FLOAT, WEColliFields.WIDTH) END 'Breite'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Height / 10, 0) ELSE TRY_CONVERT(FLOAT, WEColliFields.HEIGHT) END 'Höhe'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Netto / 1000, 0) ELSE ISNULL(TRY_CONVERT(float, WEColliFields.NETTO), 0) / 1000 END 'Netto'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN ISNULL(hu.Brutto / 1000, 0) ELSE ISNULL(TRY_CONVERT(float, WEColliFields.GROSSW), 0) / 1000 END 'Brutto'

,ISNULL((TRY_CAST(WEColliFields.Lenght / 10 as numeric) * TRY_CAST(WEColliFields.Width / 10 as numeric)) / 100, ISNULL((TRY_CAST(HU.Length / 10 as numeric) * TRY_CAST(HU.Width / 10 as numeric)) / 10000, 0)) 'Lagerfläche qm'

,CASE 
    WHEN SUBSTRING([ZONE].[NAME],1,1) IN ('H', 'F') AND TRY_CAST(SUBSTRING([ZONE].[NAME],2,LEN([ZONE].[NAME])-1) AS INT) < 10 THEN SUBSTRING([ZONE].[NAME],1,LEN([ZONE].[NAME])-1) + '0' + SUBSTRING([ZONE].[NAME],2,LEN([ZONE].[NAME])-1) 
    WHEN [ZONE].[NAME] LIKE '%WESEL%' THEN 'WES'
    ELSE ISNULL([ZONE].[NAME], '') END as "Halle"
,CASE 
    WHEN [BIN].[Description] LIKE '%Feld%' THEN 'F' + SUBSTRING([BIN].[Description],6,LEN([BIN].[Description])-5)
    WHEN SUBSTRING([ZONE].[NAME],1,1) = 'F' THEN [ZONE].[NAME] 
    ELSE '' 
END AS "Feld"
,CASE WHEN [BIN].[Description] LIKE '%Regal%' THEN SUBSTRING([BIN].[Code], 1, 2) ELSE '' END AS "Regal"
,CASE WHEN [BIN].[Description] LIKE '%Regal%' THEN SUBSTRING([BIN].[Code], 3, 2) ELSE '' END AS "Reihe"
,CASE WHEN [BIN].[Description] LIKE '%Regal%' THEN SUBSTRING([BIN].[Code], 5, 2) ELSE '' END AS "Fach"
,CASE WHEN SUBSTRING([ZONE].[NAME],1,1) = 'F' THEN 'X' ELSE '' END AS 'FREIFLÄCHE'

,ISNULL(HU.ColliNumber, '') 'Kolli Nr Siemens Energy'
,CASE WHEN d.name = 'LoadingReceiptGoods' THEN Isnull(WEColliFieldsHeader.SDU_Kennzahl, '') ELSE Isnull(WEColliFields.SDU_Kennzahl, '') END 'Kennzahl'
,ISNULL(HU.InboundCode, '') 'Externe Komm-Nr'
,ISNULL(DV.Content, '') 'externe WE-Nr'
,ISNULL(WEFields.Supplier, '') 'Lieferant'
,'' 'externe Bemerkung'
,'' 'Pappkarton'
,ISNULL(HU.Code, '') 'Boxcad'
,ISNULL(SHH.Code, '') 'Deufol Lieferschein Nr'
,Isnull(WEColliFields.SDU_VAN_ID, '') 'VAN ID'
,'' 'Summe Lagerfläche qm'
,'' 'Abrechnungsbetrag 1'
,'' 'Summe Auftragsnummer 1'
,'' 'Abrechnungsbetrag 2'
,'' 'Summe Auftragsnummer 2'
,'' 'Freifeld'

from Dimension D  WITH (NOLOCK) 
inner join DimensionValue DV with (nolock) on DV.DimensionId = D.id 

INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'

LEFT join [Status] sWE WITH (NOLOCK) on DV.statusid = sWE.id
LEFT join EntityDimensionValueRelation EDVR WITH (NOLOCK) on (Dv.Id = EDVR.DimensionValueId OR Dv.ParentDimensionValueId = EDVR.DimensionValueId) and edvr.entity = 11
LEFT join HandlingUnit HU WITH (NOLOCK) ON EDVR.EntityId = HU.Id
LEFT join [Status] sHU WITH (NOLOCK) on HU.statusid = sHU.id
left join [Bin] WITH (NOLOCK) on [Bin].[Id] = HU.[ActualBinId]
left join [Location] WITH (NOLOCK) ON [Location].Id = HU.ActualLocationId
left join [Zone] WITH (NOLOCK) ON [Zone].Id = HU.ActualZoneId
left join ShipmentLine SHL WITH (NOLOCK) ON SHL.HandlingUnitId = HU.ID
left JOIN ShipmentHeader SHH WITH (NOLOCK) ON SHH.ID = SHL.ShipmentHeaderId

-- LoadingReceiptGoods Data
left join (
    select
    DV.ID,
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = ('LoadingReceiptGoods')
    INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'
    where
    [DF].[Name] in ('LOADING_DATE','ORDERNO','COMMISSIONNO','SUPPLIER','DELIVERYNOTE')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([LOADING_DATE],[ORDERNO],[COMMISSIONNO],[SUPPLIER],[DELIVERYNOTE])
) as [WEFields] on [DV].ParentDimensionValueId = [WEFields].ID 

-- ReceiptGoods Data
LEFT join (
    select
    DV.ID,
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = ('ReceiptGoods')
    INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'
    where
    [DF].[Name] in ('COLLI_NUMBER_EXTERN','LENGHT','HEIGHT','WIDTH','DUTY','HUTYPE','DELIVERYNOTE','KEYWORD','BEMERKUNG2','BEMERKUNG3','BEMERKUNG4','BEMERKUNG5','BEMERKUNG7','SDU_BESTELLNR','SDU_BESTELLPOS','ZOLLGUT','SDU_KENNZAHL','SDU_KUNDENAUFTRAG','SDU_VAN_ID','GROSSW','NETTO','ORDERNO','COMMISSIONNO')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([COLLI_NUMBER_EXTERN],[LENGHT],[HEIGHT],[WIDTH],[DUTY],[HUTYPE],[DELIVERYNOTE],[KEYWORD],[BEMERKUNG2],[BEMERKUNG3],[BEMERKUNG4],[BEMERKUNG5],[BEMERKUNG7],[SDU_BESTELLNR],[SDU_BESTELLPOS],[ZOLLGUT],[SDU_KENNZAHL],[SDU_KUNDENAUFTRAG],[SDU_VAN_ID],[GROSSW],[NETTO],[ORDERNO],[COMMISSIONNO])
) as [WEColliFields] on [DV].[Id] = [WEColliFields].[Id]

-- ReceiptGoods Header
LEFT join (
    select
    DV.ID,
    dv.ParentDimensionValueId,
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = ('ReceiptGoods')
    INNER JOIN BusinessUnitPermission BUP WITH (NOLOCK) on D.id = BUP.DimensionId and bup.BusinessUnitId = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    INNER join BusinessUnit as BU WITH (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'
    where
    [DF].[Name] in ('COLLI_NUMBER_EXTERN','LENGHT','HEIGHT','WIDTH','DUTY','HUTYPE','DELIVERYNOTE','KEYWORD','BEMERKUNG2','BEMERKUNG3','BEMERKUNG4','BEMERKUNG5','BEMERKUNG7','SDU_BESTELLNR','SDU_BESTELLPOS','ZOLLGUT','SDU_KENNZAHL','SDU_KUNDENAUFTRAG','SDU_VAN_ID','GROSSW','NETTO','ORDERNO','COMMISSIONNO')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([COLLI_NUMBER_EXTERN],[LENGHT],[HEIGHT],[WIDTH],[DUTY],[HUTYPE],[DELIVERYNOTE],[KEYWORD],[BEMERKUNG2],[BEMERKUNG3],[BEMERKUNG4],[BEMERKUNG5],[BEMERKUNG7],[SDU_BESTELLNR],[SDU_BESTELLPOS],[ZOLLGUT],[SDU_KENNZAHL],[SDU_KUNDENAUFTRAG],[SDU_VAN_ID],[GROSSW],[NETTO],[ORDERNO],[COMMISSIONNO])
) as [WEColliFieldsHeader] on [DV].[ID] = [WEColliFieldsHeader].[ParentDimensionValueId]

left join (
    select 
    CV.content,
    CF.Name,
    CV.EntityId
    from CustomValue CV
    inner join CustomField CF ON CF.Id = CV.CustomFieldId 
    where CF.name in ('PROVIDER_NO') 
) SRC
    PIVOT (max(src.Content) for SRC.Name in ([PROVIDER_NO])
) as ZONEDATA on [Zone].id = ZONEDATA.EntityId 

left join (
    select
    DV.ID,
    [DV].[Content] [ProjectNr],
    [DV].[Description] [Project],
    [D].[Description] [Dimemsion],
    [DF].[Name],
    [DFV].[Content]
    from [DimensionField] [DF] WITH (NOLOCK)
    inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
    inner join [DimensionValue] [DV] WITH (NOLOCK) on [DFV].[DimensionValueId] = [DV].[Id]
    inner join [Dimension] [D] WITH (NOLOCK) on [DF].DimensionId = [D].[Id] and [D].[Name] = 'Project'
    where
    [DF].[Name] in ('PackingType','SDU_KENNWORT','KEYWORD','MACHINE')) [SRC]
        pivot (max([SRC].[Content]) for [SRC].[Name]   in ([PackingType],[SDU_KENNWORT],[KEYWORD],[MACHINE])
) as [ProFields] on [DV].[Id] = [ProFields].[Id]

LEFT JOIN (
    select 
    D.name, 
    DV.Content+' '+isnull(DV.[Description],'') as content,
    edvr.EntityId from DimensionValue DV 
    inner join Dimension D on DV.DimensionId = D.id 
    inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
    where D.name in ('Customer','Project','Order','Commission') ) SRC
        PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
) as Dimensions on EDVR.EntityId = Dimensions.EntityId

LEFT JOIN (
    select 
    D.name, 
    DV.Content as content,
    edvr.EntityId from DimensionValue DV 
    inner join Dimension D on DV.DimensionId = D.id 
    inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
    where D.name in ('Customer','Project','Order','Commission') ) SRC
        PIVOT (max(src.Content) for src.Name  in ([Customer],[Project],[Order],[Commission])
) as DimensionsDesc on EDVR.EntityId = DimensionsDesc.EntityId

LEFT JOIN  (
    select
    max(WFE.created) over (PARTITION by WFE.EntityId) as FirstCreated, 
    Wfe.Created,
    WFE.EntityId,
    U.FirstName+' '+U.LastName [User],
    BU.Name as BU
    from WorkflowEntry WFE  WITH (NOLOCK)
    inner join [User] U WITH (NOLOCK) on WFE.CreatedById = u.Id
    inner join BusinessUnit BU WITH (NOLOCK) on WFE.BusinessUnitId = BU.Id
    where WFE.StatusId in (select id from status WITH (NOLOCK) where name IN ('ON_SHIPMENT', 'ON_THE_WAY')
) and WFE.Entity IN (11)
) BOXAusgang on HU.id = BOXAusgang.EntityId and BOXAusgang.FirstCreated = BOXAusgang.Created 

where DV.Description like '%Esso Service%'
and shu.id IN (select S.id from [Status] S
    inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BUP.BusinessUnitID = (Select ID from BusinessUnit Where [Name] = 'Siemens Duisburg')
    and S.NAME NOT IN ('CANCELED'))
and ISNULL([ZONE].[NAME], '') NOT IN ('Werksverpackung', 'Außenbaustelle', 'Münsterland')
and d.name in ('ReceiptGoods', 'LoadingReceiptGoods')

order by [Status], Labelnummer, [Datum WE]