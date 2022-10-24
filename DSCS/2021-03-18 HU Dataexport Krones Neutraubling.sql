
select
HU.id,
CF.COUNTRY as 'Land',
Project.GRAddressName as 'WEMPF',
HU.Code as 'Barcode',
L.[Description] as 'Standort',
BOXClosed.Created as 'Datum Packstück zu',
BU as 'Verpackungsort',
                Dimensions.[Order] as 'Auftrag',
isnull(TypeT.Text,HUT.[Description]) as 'Kistenart', 
HU.ColliNumber as 'Kollinummer',
Dimensions.Commission as 'Kommission', 
HU.Length/10.0 as 'Länge cm', 
HU.Width/10.0 as 'Breite cm', 
HU.Height/10.0 as 'Höhe cm', 
HU.Brutto as 'Brutto kg', 
HU.Netto as 'Netto kg', 
ISNULL(ST.Text, S.name) as 'Status', 
B.Code as 'Lagerfläche',
Commission.LAST_DELIVERY_DATE as 'späteste Sendung', 
BOXClosed.[Login] as 'User erstes KisteZu',
TopHu.Code as 'Innenkiste von'


from HandlingUnit HU 
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.name = 'KRONES GLOBAL'
left join HandlingUnitType HUT on HU.TypeId = HUT.id
left join Translation TypeT on HUT.id = TypeT.EntityId and TypeT.[Column] = 'Description' and TypeT.[Language] = 'de'
left join HandlingUnit TopHU on HU.TopHandlingUnitId = TopHU.id
left join Bin B on HU.ActualBinId = B.Id
left join [Location] L on HU.ActualLocationId = L.id
inner join [Status] S on HU.StatusId = S.Id
left join Translation ST on S.id = ST.EntityId and ST.[Column] = 'Name' and ST.[Language] = 'de'
--dimensions
inner join  (
select D.name,DV.Content as Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join DimensionField DF on D.id = DF.DimensionId
left join Translation T on D.Id = T.EntityId and T.[Language] = 'de'

where D.name in ('Project','Order','Commission')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions on HU.id = Dimensions.EntityId

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
PIVOT (max([SRC].[CV_Content]) for [SRC].[CF_Name]  in ([COUNTRY],[CF1],[CF2]) -- add customfield names here
        ) as [CF] on HU.id = [CF].[EntityID]


inner join  (

select
min(WFE.created)  over (PARTITION by WFE.EntityId) as FirsCreated, 
Wfe.Created,
WFE.EntityId,
U.[Login],
BU.Name as BU
from WorkflowEntry WFE 
inner join [User] U on WFE.CreatedById = u.Id
inner join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
where WFE.StatusId in (select id from status where name = 'BOX_CLOSED'


) and WFE.Entity = 11 


) BOXClosed on HU.id = BOXClosed.EntityId and BOXClosed.FirsCreated = BOXClosed.Created





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
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network],[FIRST_DELIVERY_DATE],[LAST_DELIVERY_DATE])) as Commission on HU.id = Commission.EntityId

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
pivot (max(SRC.Content) for SRC.Name   in ([GRAddressPostCode],[GRAddressContactPerson],[GRLanguage],[GRAddressName],[GRAddressPhoneNo],[GRAddressStreet],[GRAddressCity],[GRAddressCountry],[Comments])) as Project on HU.id = Project.EntityId


where BOXClosed.Created between '2021-04-01' and '2021-04-30'
