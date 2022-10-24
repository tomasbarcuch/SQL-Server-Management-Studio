select 
KHU.Code KHU_Code
,KHUDimensions.[Order] KHU_Order
,KHUDimensions.Commission KHU_Commission
,KHU.ColliNumber KHU_ColliNumber
,KHUHUT.[Description] KHU_Description
,KHU.Length KHU_Length
,KHU.Width KHU_Width
,KHU.Height KHU_Height
,KHU.Brutto KHU_Gross
,KHU.Netto KHU_Net
,CAST(KHUBOXClosed.Created as DATE) as KHU_BOXClosed
,KHUSH.Code as ShipmentHeader
,KHUSH.TruckNumber LicencePlate
,KHULoc.[Description] ToLocation
,KHUSH.ToAddressName
,CAST(KHUShipped.Created as DATE) KHU_Shipped
,CAST(KHUUnloaded.Created as DATE) KHU_Unloaded
,KAGHU.Code KAG_Code
,KAGDimensions.Commission KAG_Commision
,KAGHU.ColliNumber _KAG_ColliNumber
,KAGHU.[Description] KAG_Description
,HUI.Identifier
,CAST(KAGInStock.Created as DATE) KAG_Inbound
,CAST(KAGBoxClosed.Created as DATE) KAG_BoxClosed
from HandlingUnit KAGHU 
inner join BusinessUnitPermission BUP on KAGHU.id = BUP.HandlingUnitId and BUP.BusinessUnitId = (
select id from BusinessUnit where Name = ('KRONES GLOBAL')
)
inner join HandlingUnitIdentifier HUI on KAGHU.id = HUI.HandlingUnitId and LEN(HUI.Identifier) > 0

inner join    (
select 
D.name, 
DV.Content, 
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
) as KAGDimensions on KAGHU.id = KAGDimensions.EntityId



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
where WFE.StatusId in (select id from status where name = 'STORED'
) and WFE.Entity = 11 
) KAGInStock on KAGHU.id = KAGInStock.EntityId and KAGInStock.FirstCreated = KAGInStock.Created 

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
where WFE.StatusId in (select id from status where name = 'BOX_CLOSED'
) and WFE.Entity = 11 
) KAGBoxClosed on KAGHU.id = KAGBoxClosed.EntityId and KAGBoxClosed.FirstCreated = KAGBoxClosed.Created 



inner join (
 select HU.* from HandlingUnit HU 
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId and BUP.BusinessUnitId = (
select id from BusinessUnit where Name = ('KHU Debrecen')
)
 
 --where HU.ColliNumber = '602522'
) KHU on HUI.Identifier = KHU.ColliNumber

left join HandlingUnitType KHUHUT on KHU.TypeId = KHUHUT.Id

inner join    (
select 
D.name, 
DV.Content, 
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
) as KHUDimensions on KHU.id = KHUDimensions.EntityId


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
where WFE.StatusId in (select id from status where name = 'HuBoxClosed'
) and WFE.Entity = 11 
) KHUBOXClosed on KHU.id = KHUBOXClosed.EntityId and KHUBOXClosed.FirstCreated = KHUBOXClosed.Created 

inner join ShipmentLine KHUSL on KHU.id = KHUSL.HandlingUnitId
inner join ShipmentHeader KHUSH on KHUSL.ShipmentHeaderId = KHUSH.Id and KHUSH.[Type] = 0
left join [Location] KHULoc on KHUSH.ToLocationId = KHULoc.id

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
where WFE.StatusId in (select id from status where name = 'SpShipped'
) and WFE.Entity = 31 
) KHUShipped on KHUSH.id = KHUShipped.EntityId and KHUShipped.FirstCreated = KHUShipped.Created 

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
where WFE.StatusId in (select id from status where name = 'SpUnloaded'
) and WFE.Entity = 31 
) KHUUnloaded on KHUSH.id = KHUUnloaded.EntityId and KHUUnloaded.FirstCreated = KHUUnloaded.Created 