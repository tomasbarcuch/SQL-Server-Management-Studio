select
'DSCS' as 'Source'
,Project.GRAddressCountry as 'Land WEMPF'
,dscs_hu.Code 'Barcode'
,ActLoc.Name 'Standort'
,cast(wfe.Created as date) 'Status seit'
,cast(PACKED.Created as date) 'Datum Packstück zu'
,NULL 'Verpackungsort'
,Project.ProjectNr 'Project'
,isnull(TypeDE.Text,Type.Code) 'Kistenart'
,dscs_hu.[Description] 'Inhalt Deutsch'
,dscs_hu.ColliNumber 'Collinummer'
,Commissions.CommissionNr 'Kommission'
,dscs_hu.Length/10 'Länge cm'
,dscs_hu.Width/10 'Breite cm'
,dscs_hu.Height/10 'Höhe cm'
,cast(dscs_hu.Brutto as INT) 'Brutto kg'
,cast(dscs_hu.Netto as INT) 'Netto kg'
,case S.Name
when 'BOX_CLOSED' then 'Kiste zu' 
else S.Name end as 'Status'
,ActBin.Code 'Lagerfläche 1'
,NULL 'Lagerfläche 2'
,Project.GRAddressName 'Adresse: Warenempfänger 1'
,cast(Orders.DateTimeOfPlannedDeliveryToCustomer as date) 'späteste Sendung'
,NULL 'Text 1'
,ParHu.Code 'Innenkiste von'
,SH.ToAddressName 'Transport Zielort (intern)'
,cast(dscs_hu.BaseArea as decimal (10,2)) 'qm Bodenfläche'
,NULL 'Versandsperre am Auftrag'
,NULL 'Luftfracht'
,Con.SerialNo 'Containerbezeichnung'
,cast(INB.Created as date) 'WE-Datum (aus WE-Tab)'
,NULL 'Wareneingang'
,cast(INB.Created as date) 'Datum Eingang-HH'
,cast(dscs_hu.Surface as decimal (10,2)) 'qm Aussenfläche'
,Project.[Status] as 'Project Status'

 from HandlingUnit dscs_hu
 inner join BusinessUnitPermission BUP on dscs_hu.id = BUP.HandlingUnitId and BUP.BusinessUnitId = (select ID from BusinessUnit where Name = 'KRONES GLOBAL')
 inner join [Status] S on dscs_hu.StatusId = S.id-- and S.name = 'BOX_CLOSED'
 left join [Location] ActLoc on dscs_hu.ActualLocationId = ActLoc.Id
 inner join WorkflowEntry WFE on dscs_hu.StatusId = WFE.StatusId and WFE.EntityId = dscs_hu.id
 left join WorkflowEntry PACKED on PACKED.EntityId = dscs_hu.id and PACKED.StatusId = '7d8927fb-456f-48bb-a44b-6e6dc555ddda'
 left join WorkflowEntry INB on INB.EntityId = dscs_hu.id and INB.StatusId in ('ad6082e9-3f57-40f8-adc6-504b5630b113','45a45541-730d-42bf-8ae5-c0cff45746a3')
 left join HandlingUnitType [Type] on dscs_hu.TypeId = [Type].id
 left join Translation TypeDE on [Type].id = TypeDE.EntityId and TypeDE.[Language] = 'de' and TypeDE.[Column] = 'Code'
 left join Bin ActBin on dscs_hu.ActualBinId = ActBin.Id
 left join HandlingUnit ParHu on dscs_hu.ParentHandlingUnitId = ParHu.Id
 left join HandlingUnit CON on dscs_hu.TopHandlingUnitId = CON.Id
 left join HandlingUnitType CONType on CON.TypeId = CONType.id and CONType.Container = 1
 left join ShipmentLine SL on dscs_hu.id = SL.HandlingUnitId
 left join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id
 



inner JOIN (
select
S.name as Status,
DV.Content ProjectNr,
DV.[Description] Project, 
D.[Description] Dimemsion,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project'
inner join [Status] S on DV.StatusId = S.id
where 
DF.name in ('GRAddressName','GRAddressCountry'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([GRAddressName],[GRAddressCountry])) as Project on dscs_hu.id = Project.EntityId


inner join (
select
DV.Content OrderNr,
DV.[Description] Ord, 
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
DF.name in ('DateTimeOfPlannedDeliveryToCustomer'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([DateTimeOfPlannedDeliveryToCustomer])) as Orders on dscs_hu.id = Orders.EntityId


inner join (
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
DF.name in ('Plant','Network'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Network])) as Commissions on dscs_hu.id = Commissions.EntityId

--where dscs_hu.code = '2022002220007940'
--where dscs_hu.parentHandlingUnitId is not null

UNION ALL

select
'VV' as 'Source'
,P.SAP_LANDWempf as 'Land WEMPF'
,vv_hu.Barcode
,O.TXX as Standort
,cast(vv_hu.DAT_LASTMOD as date) 'Status seit'
,cast(vv_hu.DAT_KISTEZU as date) 'Datum Packstück zu'
,PO.TXX as Verpackungsort
,vv_hu.vs_hier1 Project
,A.TXX Kistenart
,vv_hu.INHALT_TXD 'Inhalt Deutsch'
,vv_hu.KOLLINUMMER as 'Collinummer'
,vv_hu.vs_hier3 Kommission
,cast (vv_hu.ABMESS1_MM/10 as int) 'Länge cm'
,cast(vv_hu.ABMESS2_MM/10 as int) 'Breite cm'
,cast(vv_hu.ABMESS3_MM/10 as int) 'Höhe cm'
,vv_hu.BRUTTO_KG 'Brutto kg'
,vv_hu.NETTO_KG 'Netto kg'
,S.TXX as 'Status'
,vv_hu.LAGERORT1 'Lagerfläche 1'
,vv_hu.LAGERORT2 'Lagerfläche 2'
,P.Wempf 'Adresse: Warenempfänger 1'
,cast(D.DAT_LIEFERUNG as date) 'späteste Sendung'
,vv_hu.KONS_TEXT1 as 'Text 1'
,cast(vv_hu.Z_AUSSENKISTE as varchar) 'Innenkiste von'
,CO.TXX 'Transport Zielort (intern)'
,cast(0.000001*(vv_hu.ABMESS1_MM*vv_hu.ABMESS2_MM) as decimal (10,2)) 'qm Bodenfläche'
,CASE WHEN D.LISTE_KZ Like '%;HVS;%' THEN 2 ELSE NULL END 'Versandsperre am Auftrag'
,CASE WHEN D.LISTE_KZ Like '%;LUF;%' THEN 2 ELSE NULL END 'Luftfracht'
,CON.WELTWEITE 'Containerbezeichnung'
,cast(vv_hu.DAT_EINGANGZV as date) 'WE-Datum (aus WE-Tab)'
,vv_hu.WE_NR 'Wareneingang'
,cast(vv_hu.DAT_EINGANGZV as date) 'Datum Eingang-HH'
,cast(0.000002*(vv_hu.ABMESS1_MM*vv_hu.ABMESS2_MM+vv_hu.ABMESS1_MM*vv_hu.ABMESS3_MM+vv_hu.ABMESS2_MM*vv_hu.ABMESS3_MM) as decimal (10,2)) 'qm Aussenfläche'
,PS.TXX as 'Project Status'


 from DCNLPWSQL02.KRO_VV.dbo.DAT_Kisten vv_hu with (NOLOCK)
 left join DCNLPWSQL02.KRO_VV.dbo.N_ORTE O on vv_hu.W_Standort = O.WERT
  left join DCNLPWSQL02.KRO_VV.dbo.N_ORTE PO on vv_hu.W_ORT_VP = PO.WERT
  left join DCNLPWSQL02.KRO_VV.dbo.N_STATUS S on vv_hu.W_Status = S.Zaehler
	left join DCNLPWSQL02.[KRO_VV].[dbo].VS_HIER1 P on vv_hu.VS_HIER1 = P.TXX
	left join DCNLPWSQL02.[KRO_VV].[dbo].N_ARTEN A on vv_hu.W_ART = A.WERT and A.sap_sprache = 'D' --and A. NPARM_RESERVE = 'PROJ'
	left join DCNLPWSQL02.[KRO_VV].[dbo].DAT_CONTAINER C on vv_hu.Z_CONTAINER = C.ZAEHLER
	left join DCNLPWSQL02.[KRO_VV].[dbo].VS_HIER2 D on vv_hu.VS_HIER2 = D.VS_HIER2 
    left join DCNLPWSQL02.[KRO_VV].[dbo].DAT_CONTAINER CON on vv_hu.Z_CONTAINER = CON.ZAEHLER
    left join DCNLPWSQL02.KRO_VV.dbo.N_ORTE CO on CON.W_ORT_ZIEL = CO.WERT
    left join DCNLPWSQL02.KRO_VV.dbo.N_STATUS PS on P.W_STATUS = PS.Zaehler
where 
  vv_hu.Z_AKUNDE = 18 AND (vv_hu.W_STATUS <> 12000) AND (vv_hu.W_Status = 12040 OR vv_hu.W_Status = 12050) AND (vv_hu.Z_AUSSENKISTE = 0)
--AND vv_hu.BARCODE in ('2022002220007940')




