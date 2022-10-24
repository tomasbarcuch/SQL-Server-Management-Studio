select * from loosepart LP 
left outer join (SELECT LoosePartId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE LoosePartId is not null) BUPlp on LP.id = BUPlp.LoosePartId

select * from HandlingUnit HU 
left outer join (SELECT HandlingUnitId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE HandlingUnitId is not null) BUPhu on HU.id = BUPhu.HandlingUnitId

select * from ServiceLine SL 
left outer join (SELECT ServiceLineId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE ServiceLineId is not null) BUPsl on SL.id = BUPsl.ServiceLineId

select * from ShipmentHeader SH 
left outer join (SELECT ShipmentHeaderId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE ShipmentHeaderId is not null) BUPsh on SH.id = BUPsh.ShipmentHeaderId

select * from BCSAction BCSA 
left outer join (SELECT BCSActionId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE BCSActionId is not null) BUPbcsa on BCSA.id = BUPbcsa.BCSActionId

select * from Status S 
left outer join (SELECT StatusId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE StatusId is not null) BUPs on S.id = BUPs.StatusId

select * from PackingOrderHeader POH
left outer join (SELECT PackingOrderHeaderId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE PackingOrderHeaderId is not null) BUPpoh on POH.id = BUPpoh.PackingOrderHeaderId

select * from WorkflowEntry WFE
left outer join (SELECT WorkflowId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE PackingOrderHeaderId is not null) BUPpoh on POH.id = BUPpoh.PackingOrderHeaderId


select 
lp.*,
BUPlp.BusinessUnitId,
CV_KENNlp.Content as 'Kennwort',
CV_POSlp.Content as 'Position'  from loosepart LP 
left outer join (SELECT LoosePartId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE LoosePartId is not null) BUPlp on LP.id = BUPlp.LoosePartId

INNER join customfield CF_KENNlp on BUPlp.BusinessUnitId = CF_KENNlp.clientbusinessunitid and BUPlp.LoosePartId = LP.id and CF_KENNlp.name = 'Kennwort'
INNER join customvalue CV_KENNlp on CV_KENNlp.customfieldid = CF_KENNlp.Id and BUPlp.LoosePartId = LP.id and CV_KENNlp.EntityId = LP.Id
INNER join customfield CF_POSlp on BUPlp.BusinessUnitId = CF_POSlp.clientbusinessunitid and CF_POSlp.name = 'Position'
INNER join customvalue CV_POSlp on CV_POSlp.customfieldid = CF_POSlp.Id and BUPlp.LoosePartId = LP.id and CV_POSlp.EntityId = LP.Id

