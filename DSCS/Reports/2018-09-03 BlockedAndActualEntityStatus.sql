SELECT 
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
 Entitys.ClientBusinessUnitId,
 Entitys.id as entityid,
 Entitys.StatusId as ActualStatusID,
 EDS.StatusId as BlockedStatusID,
 Entitys.EntType,
Tbl.text as BlockedStatus,
Tac.text as ActualStatus,
Entitys.Code,
U.FirstName+' '+U.LastName as CreatedBy,
EDS.Created,
cast(EDS.Created as Date) as Datum
FROM 
[EntityDisableStatus] EDS
inner join [Status] SBL on EDS.StatusId = SBL.Id
left outer join dbo.[Translation] Tbl on SBL.ID = Tbl.entityId and tbl.Language = 'de'--$P{Language} 
inner join 
(select id, BUPlp.BusinessUnitId ClientBusinessUnitId, 15 as Entity, StatusId, Code, 'Loose Part' as EntType  from loosepart
left outer join (SELECT LoosePartId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE LoosePartId is not null) BUPlp on LoosePart.id = BUPlp.LoosePartId
union 
select id, BUPhu.BusinessUnitId ClientBusinessUnitId, 11 as Entity, StatusId, Code, 'Handling Unit' as EntType from HandlingUnit 
left outer join (SELECT HandlingUnitId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE HandlingUnitId is not null) BUPhu on HandlingUnit.id = BUPhu.HandlingUnitId
union 
select id, BUPsl.BusinessUnitId ClientBusinessUnitId, 48 as Entity, StatusId, [Description] Code, 'Service Line' as EntType  from ServiceLine
left outer join (SELECT ServiceLineId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE ServiceLineId is not null) BUPsl on ServiceLine.id = BUPsl.ServiceLineId
union 
select id, BUPsh.BusinessUnitId ClientBusinessUnitId, 31 as Entity, StatusId, Code, 'Shipment Header' as EntType  from ShipmentHeader
left outer join (SELECT ShipmentHeaderId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE ShipmentHeaderId is not null) BUPsh on ShipmentHeader.id = BUPsh.ShipmentHeaderId
union 
select id, BUPpoh.BusinessUnitId ClientBusinessUnitId, 35 as Entity, StatusId, Code, 'Packing Order' as EntType  from PackingOrderHeader
left outer join (SELECT PackingOrderHeaderId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE PackingOrderHeaderId is not null) BUPpoh on PackingOrderHeader.id = BUPpoh.PackingOrderHeaderId
) as Entitys on EDS.EntityId = Entitys.Id and EDS.Entity = Entitys.Entity
inner join [Status] SAC on Entitys.StatusId = SAC.Id
left outer join dbo.[Translation] Tac on SAC.ID = Tac.entityId and Tac.language =  'de'--$P{Language} 
inner join [user] U on EDS.CreatedByID = U.id
inner join BusinessUnit BU on Entitys.ClientBusinessUnitId = BU.Id

where 
Entitys.ClientBusinessUnitId = $P{ClientBusinessUnitID} 
and cast(EDS.Created as Date) >=  $P{FromDate} 
and cast(EDS.Created as Date) <=  $P{ToDate}
