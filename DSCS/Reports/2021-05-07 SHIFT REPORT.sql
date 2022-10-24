select 
HU.id as QRCode,
BusinessUnit = (select Name from BusinessUnit where id = (select id from BusinessUnit where name = 'Deufol Neutraubling')) --$P{BusinessUnitId})
,ClientBusinessUnit = (select Name from BusinessUnit where id = (select id from BusinessUnit where name = 'KRONES GLOBAL')) --$P{BusinessUnitId})
 ,[ord].[Order] as [Anlagen Nr.]
,[Project].[ProjectNr]
,[Commission].[CommissionNr]
,[ORD].[OrderNr]
,[HU].ColliNumber
,[Commission].[OrderPosition]
,[Project].[GRAddressCountry]
,[HU].[Code]
,[HU].[Description]
,[HU].[Length]
,[HU].[Width]
,[HU].[Height]
,[HU].[Weight]
,[HU].[Brutto]
,[CUS].[Deliverytype]
,[CUS].[Foil]
,CUS.ADD_INFO
,ItemInserted.[Login] InsertedBy
,ItemInserted.FirstCreated InsertedDate
,ItemInsertedBCS.FirstScanned InsertedDateBCS
,ItemInsertedBCS.[Login] InsertedbByBCS 
        ,ISNULL(ISNULL(ItemInsertedBCS.FirstScanned,ItemInserted.FirstCreated),BOXClosed.FirstCreated) PackingStart
        ,case when ItemInsertedBCS.FirstScanned is null  then 'manually' else 'BCS' end
     ,BOXClosed.[Login] ClosedBy
,BOXClosed.FirstCreated ClosedDate
,BoxClosedBCS.FirstScanned AT TIME ZONE 'Eastern Standard Time' ClosedDateBCS
,BoxClosedBCS.[Login] ClosedByBCS



from [HandlingUnit] [HU]
inner join [BusinessUnitPermission] [BUP] on [HU].[Id] = [BUP].[HandlingUnitId] and [BUP].[BusinessUnitId] = (select id from BusinessUnit where name = 'KRONES GLOBAL') --$P{ClientBusinessUnitId} 

left join HandlingUnitType HUT on HU.TypeId = HUT.id
left join Translation TypeT on HUT.id = TypeT.EntityId and TypeT.[Column] = 'Description' and TypeT.[Language] = 'de'

left join (
select 
BCSPacking.*, 
Loc.[Location],
Loc.Zone
from (
select 
MIN(L.Created) over (PARTITION by L.entityId) as BCSPacked
,ISNULL(AT.text,A.Description) Action
,U.FirstName+' '+U.LastName as CreatedBy
,L.Created
,L.EntityId
,L.PackerBusinessUnitId
,L.ClientBusinessUnitId
from BCSLog L
inner join BCSAction A on L.ActionId = A.Id and A.BCSaction = 35 and L.result <> 2 and L.Entity = 11
inner join [User] U on L.CreatedById = U.Id
left join Translation AT on A.id = AT.EntityId and AT.[Language] = 'de' and AT.[Column] = 'Description'
) BCSPacking
left join (select
HandlingUnitId,L.[Description] Location, Z.Name Zone, B.[Description] As Bin, MIN(WE.created) LocFrom, MAX(WE.Created) LocTo 
from WarehouseEntry WE
inner join [Location] L on WE.LocationId = L.id
left join [Zone] Z on WE.ZoneId = Z.Id
left join [Bin] B on WE.BinId = B.Id
where HandlingUnitId is not null
group by HandlingUnitId,L.[Description], Z.Name, B.[Description]) Loc on BCSPacking.EntityId = Loc.HandlingUnitId and BCSPacking.BCSPacked between Loc.LocFrom and Loc.LocTo
where BCSPacking.BCSPacked = BCSPacking.Created
) BCSPACKING on HU.id = BCSPACKING.EntityId






inner join  (

select
min(WFE.created)  over (PARTITION by WFE.EntityId) as FirstCreated, 
Wfe.Created,
WFE.EntityId,
U.FirstName+' '+U.LastName login,
BU.Name as BU
from WorkflowEntry WFE 
inner join [User] U on WFE.CreatedById = u.Id
inner join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
where WFE.StatusId in (select id from status where name = 'BOX_CLOSED'
) and WFE.Entity = 11 
) BOXClosed on HU.id = BOXClosed.EntityId and BOXClosed.FirstCreated = BOXClosed.Created 

left join (

select
min(WFE.created)  over (PARTITION by WFE.EntityId) as FirstCreated, 
Wfe.Created,
WFE.EntityId,
U.FirstName+' '+U.LastName login,
BU.Name as BU
from WorkflowEntry WFE 
inner join [User] U on WFE.CreatedById = u.Id
inner join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
where WFE.StatusId in (select id from status where name = 'ITEM_INSERTED'
) and WFE.Entity = 11 
) ItemInserted on HU.id = ItemInserted.EntityId and ItemInserted.FirstCreated = ItemInserted.Created 

left JOIN (
select 
BA.[Description],
MIN(BL.Created) over (PARTITION by BL.entityId) as FirstScanned,
U.FirstName+' '+U.LastName login,
BL.EntityId,
BL.Created
from BCSLog BL
inner join BCSAction BA on BL.ActionId = BA.Id
inner join [User] U on BL.CreatedById = U.id
where  
BA.BCSaction in (35)
and Result = 1 
and EntityStatusId not in ('dc61ebec-cecf-4f82-8c3d-8b3790f892ad')
) ItemInsertedBCS on HU.id = ItemInsertedBCS.EntityId and ItemInsertedBCS.FirstScanned = ItemInsertedBCS.Created  

LEFT JOIN (
select 
BA.[Description],
MIN(BL.Created) over (PARTITION by BL.entityId) as FirstScanned,
U.FirstName+' '+U.LastName login,
BL.EntityId,
BL.Created
from BCSLog BL
inner join BCSAction BA on BL.ActionId = BA.Id
inner join [User] U on BL.CreatedById = U.id
where  
BA.BCSaction in (17)
and BA.[Description] = 'BOX_CLOSED'
and BL.ErrorMessage in ('Fertig')--and BL.Result <> 0
) BoxClosedBCS on HU.id = BoxClosedBCS.EntityId and BoxClosedBCS.FirstScanned = BoxClosedBCS.Created 

left join  (select 
[CV].[EntityId],
[CV].[Content],
[CF].[Name]
from [CustomValue] [CV]
inner join [CustomField] [CF] on [CV].[CustomFieldId] = [CF].[Id]
where [CF].[Name] in ('Container No.','Seal No.','Deliverytype','Foil','ADD_INFO')) [SRC]
PIVOT (max([SRC].[Content]) for [SRC].[Name] in ([Container No.],[Seal No.],[Deliverytype],[Foil],[ADD_INFO])) as [CUS] on [HU].[Id] = [CUS].[EntityId]


left join  (
select
[DV].[Content] [CommissionNr],
[DV].[Description] [Commission], 
[D].[Description] [Dimension],
[EDVR].[EntityId],
[DF].[Name], 
[DFV].[Content]
from [DimensionField] [DF]
inner join [DimensionFieldValue] [DFV] on [DF].[Id] = [DFV].[DimensionFieldId]
inner join [EntityDimensionValueRelation] EDVR on [DFV].[DimensionValueId] = [EDVR].[DimensionValueId]
inner join [DimensionValue] [DV] on [EDVR].[DimensionValueId] = [DV].[Id]
inner join [Dimension] [D] on [DF].DimensionId = [D].[Id] and [D].[Name] = 'Commission'
where 
[DF].[Name] in ('Plant','Comments','OrderPosition','Network')) [SRC]
pivot (max([SRC].[Content]) for [SRC].[Name]   in ([Plant],[Comments],[OrderPosition],[Network])) as [Commission] on [HU].[Id] = [Commission].[EntityId]

left join   (
select
[DV].[Content] [OrderNr],
[DV].[Description] [Order], 
[D].[Description] [Dimension],
[EDVR].[EntityId],
[DF].[Name], 
[DFV].[Content]
from [DimensionField] [DF]
inner join [DimensionFieldValue] [DFV] on [DF].[Id] = [DFV].[DimensionFieldId]
inner join [EntityDimensionValueRelation] [EDVR] on [DFV].[DimensionValueId] = [EDVR].[DimensionValueId]
inner join [DimensionValue] [DV] on [EDVR].[DimensionValueId] = [DV].[Id]
inner join [Dimension] [D] on [DF].DimensionId = [D].[Id] and [D].[Name] = 'Order'
where 
[DF].[Name] in ('Comments','DateOfPlannedDeliveryToCustomer')) [SRC]
pivot (max([SRC].[Content]) for [SRC].[Name]   in ([Comments],[DateOfPlannedDeliveryToCustomer])) as [Ord] on [HU].[Id] = [Ord].[EntityId]

left join  (
select
[DV].[Content] [ProjectNr],
[DV].[Description] [Project], 
[D].[Description] [Dimemsion],
[EDVR].[EntityId],
[DF].[Name], 
[DFV].[Content]
from [DimensionField] [DF]
inner join [DimensionFieldValue] [DFV] on [DF].[Id] = [DFV].[DimensionFieldId]
inner join [EntityDimensionValueRelation] [EDVR] on [DFV].[DimensionValueId] = [EDVR].[DimensionValueId]
inner join [DimensionValue] [DV] on [EDVR].[DimensionValueId] = [DV].[Id]
inner join [Dimension] [D] on [DF].DimensionId = [D].[Id] and [D].[Name] = 'Project'
where 
[DF].[Name] in ('GRAddressPostCode','GRAddressContactPerson','GRLanguage','GRAddressName','GRAddressPhoneNo','GRAddressStreet','GRAddressCity','GRAddressCountry','Comments')) [SRC]
pivot (max([SRC].[Content]) for [SRC].[Name]   in ([GRAddressPostCode],[GRAddressContactPerson],[GRLanguage],[GRAddressName],[GRAddressPhoneNo],[GRAddressStreet],[GRAddressCity],[GRAddressCountry],[Comments])) as [Project] on [HU].[Id] = [Project].[EntityId]


WHERE HU.Id in (

'5ab480e1-6ea6-4718-b4ce-1ae8786799a3',
'6996a6e2-709c-45d3-8bc8-90b21a07855f',
'db628ddd-829f-49e5-846d-87203f7dfe3e',
'45414996-201c-452e-9f26-410c95b51fa3',
'352deb1a-7276-4a3d-a54d-ba3a2b1b5a7e',
'726cede1-a940-428a-8510-009c1c269e0d'
)

--WHERE $X{IN,[HU].[Id],HandlingUnitIDs}