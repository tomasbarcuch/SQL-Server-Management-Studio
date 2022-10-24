select 
LP.Code [Pg Number]
,CAST(ISNULL(LP.InboundDate,InboundDate.Created) as DATE) [Receipt Date]
,SH.FromAddressName [Supplier]
,'?' [Type Stock]
,CF.InvoiceCode [Réf Facturation]
,LP.Article [N° article IBA]
,LP.Description [Déscription article]
,CF.Description2 [Déscription IBA]
,WC.QuantityBase as [Quantité item livré]
,LP.SerialNo [S/N]
,LP.LotNo [N° Batch]
,S.Text as [Status]
,Dimensions.Project [N° Projet]
,'?' [N° OB]
,ACTHU.Code [N° HU]
,ISNULL(ACTHU.BoxClosedDate,BoxClosedDate.Created) [Packing Date]
,ACTHU.Protection [Protection Specification]
,DATEDIFF(DAY,LP.InboundDate,GETDATE()) [#Number of days on stock]
,LP.Length
,LP.Width
,LP.Height
,CASE  when LP.Netto = 0 then LP.Weight else LP.Netto end as [Net kg]
,LP.Weight [Gross kg]
,ACTLOC.[Name] [Location]
,ACTZON.Name [Location zone]
,ACTBIN.[Description] [Location bin]
,'' [Shipping Specification]
,TOPHU.Code [Case No.]
,Dimensions.[Order] [Job No.]
,'?' [Cust Package No.]
,SH.Code [Receipt No.
]

from LoosePart LP
INNER JOIN BusinessUnitPermission BUP on LP.Id = BUP.LoosePartId and BUP.BusinessUnitId = (select id from BusinessUnit WHERE name = 'IBA International')
INNER JOIN ShipmentLine SL on LP.id = SL.LoosePartId
INNER JOIN ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id and SH.type = 1
INNER JOIN WarehouseContent WC on LP.id = WC.LoosePartId
LEFT JOIN [Translation] S on LP.StatusId = S.EntityId and S.[Language] = 'fr' AND S.[Column] = 'Name'
LEFT JOIN HandlingUnit ACTHU on LP.ActualHandlingUnitId = ACTHU.id
LEFT JOIN HandlingUnit TOPHU on LP.TOPHandlingUnitId = TOPHU.id
LEFT JOIN [Location] ACTLOC on LP.ActualLocationId = ACTLOC.Id
LEFT JOIN [Zone] ACTZON on LP.ActualZoneId = ACTZON.Id
LEFT JOIN Bin ACTBIN on LP.ActualBinId = ACTBIN.Id

LEFT JOIN  (
select
min(WFE.created)  over (PARTITION by WFE.EntityId) as FirstCreated, 
Wfe.Created,
WFE.EntityId,
U.FirstName+' '+U.LastName [User],
BU.Name as BU
from WorkflowEntry WFE  WITH (NOLOCK)
inner join [User] U on WFE.CreatedById = u.Id
inner join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
where WFE.StatusId in (select id from status where name = 'ON_STOCK'
) and WFE.Entity = 15 
) InboundDate on LP.id = InboundDate.EntityId and InboundDate.FirstCreated = InboundDate.Created 

LEFT JOIN  (
select
min(WFE.created)  over (PARTITION by WFE.EntityId) as FirstCreated, 
Wfe.Created,
WFE.EntityId,
U.FirstName+' '+U.LastName [User],
BU.Name as BU
from WorkflowEntry WFE  WITH (NOLOCK)
inner join [User] U on WFE.CreatedById = u.Id
inner join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
where WFE.StatusId in (select id from status where name = 'CLOSED'
) and WFE.Entity = 11 
) BoxClosedDate on ACTHU.id = BoxClosedDate.EntityId and BoxClosedDate.FirstCreated = BoxClosedDate.Created 


LEFT JOIN (
select 
D.name, 
Case D.name when 'Project' then DV.Content+' '+isnull(DV.[Description],'.') else DV.Content end as Content, 
--DV.Content+' '+isnull(DV.[Description],'') as content,
--DV.Content, 
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order])
        ) as Dimensions on LP.Id = Dimensions.EntityId


left join (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in (select name from CustomField where ClientBusinessUnitId = (select id from BusinessUnit where name = 'IBA International') group by name) and CV.Entity = 15
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([InvoiceCode],[Description2])
        ) as CF on LP.id = CF.EntityID