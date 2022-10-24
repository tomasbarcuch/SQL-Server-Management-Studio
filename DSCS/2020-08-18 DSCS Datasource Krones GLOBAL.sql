select 
'Handling Unit' 'Entität'
,'DSCS' 'Source'
,dscs_hu.Code 'Barcode'
,Project.GRAddressCountry as 'Land WEMPF'
,ActLoc.Name 'Standort'
,cast(wfe.Created as date) 'Status seit'
,cast(PACKED.Created as date) 'Datum Packstück zu'
,'' 'Verpackungsort'
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
,'' 'Lagerfläche 2'
,Project.GRAddressName 'Adresse: Warenempfänger 1'
,cast(Orders.DateTimeOfPlannedDeliveryToCustomer as date) 'späteste Sendung'
,'' 'Text 1'
,ParHu.Code 'Innenkiste von'
,SH.ToAddressName 'Transport Zielort (intern)'
,dscs_hu.BaseArea 'qm Bodenfläche'
,'' 'Versandsperre am Auftrag'
,'' 'Luftfracht'
,Con.SerialNo 'Containerbezeichnung'
,cast(INB.Created as date) 'WE-Datum (aus WE-Tab)'
,'' 'Wareneingang'
,cast(INB.Created as date) 'Datum Eingang-HH'
,dscs_hu.Surface 'qm Aussenfläche'


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
 



inner join (
select
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

--where dscs_hu.parentHandlingUnitId is not null