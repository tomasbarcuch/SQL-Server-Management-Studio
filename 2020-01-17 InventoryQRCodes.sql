select
Client.Id,
Client.Name Client
,IH.Code InnvetoryCode
,L.Code Location
,Z.Name Zone
,B.Code Bin
,IH.ID as IHid
,case IH.[Status]
when 0 then 'opened'
when 2 then 'closed'
else '' end as status

,IL.id as ILid
,isnull(IL.LoosePartId,IL.HandlingUnitId) as entityId
,isnull(LP.code, HU.Code) as EntCode
,isnull(LP.[Description], HU.[Description]) as EntDesc
,IL.CurrentQuantity
,IL.ExpectedQuantity
,isnull(TUOM.Text,UOM.Code) as UOM

from InventoryLine IL 
inner join InventoryHeader IH on IL.InventoryHeaderId = IH.id
inner join BusinessUnitPermission BUP on IH.id = BUP.InventoryHeaderId
inner join BusinessUnit Client on BUP.BusinessUnitId = Client.id and Client.type = 2 and Client.name = '1.20.19.0 client'
left join UnitOfMeasure UOM on IL.UnitOfMeasureId = UOM.Id
left join Translation TUOM on IL.UnitOfMeasureId = TUOM.EntityId and TUOM.[Column] = 'Code' and language = 'cs'

left join LoosePart LP on IL.LoosePartId = LP.Id
left join HandlingUnit HU on IL.HandlingUnitId = HU.Id
inner join [Location] L on IH.LocationId = L.id
left join [Zone] Z on IL.ZoneId = Z.id
left join Bin B on IL.BinId = B.Id

where IH.id = 'ea3c89d0-a4fb-4ff5-9be9-70e4888d2f43'