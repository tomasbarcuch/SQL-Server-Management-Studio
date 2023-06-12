select 
CASE WHEN TOPHU.Id = ACTHU.Id THEN NULL ELSE TOPHU.Code END AS TOPHU
,ACTHU.Code 'Package No.:'
,ACTHU.Length 'Length(CM):'
,ACTHU.Width 'Width(CM):'
,ACTHU.Height 'Height(CM):'
,ACTHU.Netto 'Net Weight(KG):'
,ACTHU.Brutto 'Gross Weight(KG):'
,ACTHU.Volume 'Volume(M3):'
,CASE ACTHU.DangerousGoods WHEN 0 THEN 'No' ELSE 'Yes' END 'Dangerous Goods'
,ISNULL(HUTT.Text,HUT.[Description]) 'Package Type'
,ACTHUCUS.REMARKS 'Storage Remark'
,ACTHUCUS.DELIVERY_ID 'No.:'
,LP.Code LPCode
,LP.[Description] 'Description EN/DE'
,LP.Weight 'Net weight:'
,LP.Article 'Material No.'
,WC.QuantityBase 'Quantity'
,ISNULL(UOMT.Text,UOM.Name) 'Unit of Measure'
,LP.Code
,LPCUS.WBS 'Customer Ref.'
,LPCUS.DOCUMENT_NUMBER 'Loose Part Item'
,Project.Project 'Your Order:'
,Project.ProjectNr 'Our Order No.:'
,Project.DETAILS_REQUIRED_COUNTRY 'Country of origin:'
from LoosePart LP
INNER JOIN BusinessUnitPermission bup ON LP.id = BUP.LoosePartId and BUP.BusinessUnitId = (Select id from BusinessUnit where Name = 'Thyssenkrupp Uhde GmbH')
INNER JOIN HandlingUnit ACTHU on LP.ActualHandlingUnitId = ACTHU.Id
INNER JOIN HandlingUnit TOPHU On LP.TopHandlingUnitId = TOPHU.ID-- and TOPHU.Id <> ACTHU.Id
LEFT JOIN HandlingUnitType HUT on ACTHU.TypeId = HUT.Id
LEFT JOIN Translation HUTT on HUT.Id = HUTT.EntityId AND HUTT.[Column] = 'Description' and HUTT.[Language] = 'en'
INNER JOIN UnitOfMeasure UOM on LP.BaseUnitOfMeasureId = UOM.Id
LEFT JOIN Translation UOMT on UOM.Id = UOMT.EntityId AND UOMT.[Column] = 'Name' and UOMT.[Language] = 'en'
INNER JOIN WarehouseContent WC on LP.id = WC.LoosePartId

LEFT JOIN (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('REMARKS','DELIVERY_ID')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([REMARKS],[DELIVERY_ID])) as ACTHUCUS on ACTHU.Id = ACTHUCUS.EntityId

LEFT JOIN (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('WBS','DOCUMENT_NUMBER')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([WBS],[DOCUMENT_NUMBER])) as LPCUS on LP.Id = LPCUS.EntityId

LEFT JOIN (
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
DF.name in ('DETAILS_REQUIRED_COUNTRY'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([DETAILS_REQUIRED_COUNTRY])) as Project on ACTHU.Id = Project.EntityId

       


where LP.ActualHandlingUnitId in (
'0367c976-462a-47e0-af32-c4b41e395182'
)