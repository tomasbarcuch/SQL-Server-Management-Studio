select top (1000)
CFHU.COUNTRY as'Land', 
Project.GRAddressName as'WEMPF', 
Dimensions.[Order] as'Auftrag', 
LP.Code as'Barcode', 
Dimensions.Commission as'Kommission', 
ActHU.ColliNumber as'Kolli-Nr.', 
CF.[AssemblyStep] as'Montageabschnitt',
CF.MaterialNo as'Sachnummer / Mat-Nr',
'' as'Lieferant', 
LP.[Description] as'Losteilbez .Deutsch', 
WC.QuantityBase as'Menge', 
ISNULL(UOMT.text, UOM.Code) as'Mengeneinheit', 
ISNULL(ST.Text,S.name) as'Status', 
StatusFrom.CreatedFrom as'Status seit', 
L.Name as'Standort', 
Commission.LAST_DELIVERY_DATE as'letzte Verladung Datum', 
Inbound.FirstCreated as'WE-Deufol', 
Isnull(ToLoc.Name, SH.ToAddressName) as'Transport Zielort (intern)'

from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.name = 'KRONES GLOBAL'
--left join HandlingUnit TopHU on LP.TopHandlingUnitId = TopHU.id
left join HandlingUnit ActHU on LP.ActualHandlingUnitId = ActHU.id
left join Bin B on LP.ActualBinId = B.Id
left join [Location] L on LP.ActualLocationId = L.id
inner join [Status] S on LP.StatusId = S.Id
inner join (select MAX(WFE.Created) over (PARTITION by WFE.EntityId,WFE.StatusId) CreatedFrom , WFE.StatusId, WFE.EntityId, WFE.Created from WorkflowEntry WFE where WFE.Entity = 15 ) StatusFrom on LP.id = StatusFrom.EntityId and LP.StatusId = StatusFrom.StatusId and StatusFrom.CreatedFrom = StatusFrom.Created
inner join Translation ST on S.id = ST.EntityId and ST.[Column] = 'Name' and ST.[Language] = 'de'
inner join WarehouseContent WC on LP.id = WC.LoosePartId
inner join UnitOfMeasure UOM on LP.BaseUnitOfMeasureId = UOM.Id
inner join Translation UOMT on UOM.Id = UOMT.EntityId and UOMT.[Language] = 'de' and UOMT.[Column] = 'Code'

--dimensions
inner join  (
select DV.Id as DimesnionValueID, D.name,DV.Content as Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join DimensionField DF on D.id = DF.DimensionId
left join Translation T on D.Id = T.EntityId and T.[Language] = 'de'

where D.name in ('Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions on LP.id = Dimensions.EntityId

--custom fields
left join  (
SELECT
[CF].[Name] as [CF_Name], 
[CV].[Content] as [CV_Content],
[CV].[EntityId] as [EntityID]
FROM [CustomField] [CF]
INNER JOIN [CustomValue] [CV] ON [CF].[Id] = [CV].[CustomFieldId]
LEFT JOIN [Translation] [T] on [CF].[Id] = [T].[EntityId] and [T].[Language] = 'de'
WHERE [name] in (select [name] from [CustomField] group by [name]) and [CV].[Entity] = 11
) [SRC]
PIVOT (max([SRC].[CV_Content]) for [SRC].[CF_Name]  in ([COUNTRY]) -- add customfield names here
        ) as [CFHU] on ActHU.id = [CFHU].[EntityID]

left join  (
SELECT
[CF].[Name] as [CF_Name], 
[CV].[Content] as [CV_Content],
[CV].[EntityId] as [EntityID]
FROM [CustomField] [CF]
INNER JOIN [CustomValue] [CV] ON [CF].[Id] = [CV].[CustomFieldId]
LEFT JOIN [Translation] [T] on [CF].[Id] = [T].[EntityId] and [T].[Language] = 'de'
WHERE [name] in (select [name] from [CustomField] group by [name]) and [CV].[Entity] = 15
) [SRC]
PIVOT (max([SRC].[CV_Content]) for [SRC].[CF_Name]  in ([AssemblyStep],[MaterialNo]) -- add customfield names here
        ) as [CF] on LP.id = [CF].[EntityID]


left join  (

select
min(WFE.created)  over (PARTITION by WFE.EntityId) as FirstCreated, 
Wfe.Created,
WFE.EntityId,
U.[Login],
BU.Name as BU
from WorkflowEntry WFE 
inner join [User] U on WFE.CreatedById = u.Id
inner join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
where WFE.WorkflowAction in (1) and WFE.Entity = 15 


) Inbound on LP.id = Inbound.EntityId and Inbound.FirstCreated = Inbound.Created





inner join(
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
DF.name in ('Plant','Comments','OrderPosition','Network','FIRST_DELIVERY_DATE','LAST_DELIVERY_DATE'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network],[FIRST_DELIVERY_DATE],[LAST_DELIVERY_DATE])) as Commission on LP.id = Commission.EntityId

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
DF.name in ('GRAddressPostCode','GRAddressContactPerson','GRLanguage','GRAddressName','GRAddressPhoneNo','GRAddressStreet','GRAddressCity','GRAddressCountry','Comments'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([GRAddressPostCode],[GRAddressContactPerson],[GRLanguage],[GRAddressName],[GRAddressPhoneNo],[GRAddressStreet],[GRAddressCity],[GRAddressCountry],[Comments])) as Project on LP.id = Project.EntityId

left join ShipmentHeader SH on LP.ShipmentHeaderId = SH.Id
left join [Location] ToLoc on SH.ToLocationId = ToLoc.Id

where  DimesnionValueID in (select id from DimensionValue where ParentDimensionValueId = '19715216-5694-4543-8888-ab668f1425a0') --$P{Order})
--where --Inbound.Created between '2021-03-15' and '2021-03-31'
--and L.code like '%*%'
--and L.[Description] like '%*%'

--and Dimensions.Commission like '%*%'


