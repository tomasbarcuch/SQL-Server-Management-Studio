


begin TRANSACTION 
declare @handlingunitid as UNIQUEIDENTIFIER
declare @parenthandlingunitid as UNIQUEIDENTIFIER
set @handlingunitid = '32195024-f8b5-43bd-9372-8388d4945717'


delete from BusinessUnitPermission where HandlingUnitId = @handlingunitid
delete from EntityDimensionValueRelation where EntityId = @handlingunitid
delete from BusinessUnitPermission where ShipmentLineid in (select id from ShipmentLine where HandlingUnitId = @handlingunitid)
delete from BusinessUnitPermission where HandlingUnitId = @parenthandlingunitid
delete from WarehouseEntry where HandlingUnitId = @handlingunitid
delete from WorkFlowEntry where EntityId = @handlingunitid
delete from CustomFieldValueMapping where EntityId = @handlingunitid
delete from WarehouseEntry where HandlingUnitId = @parenthandlingunitid
delete from WarehouseEntry where ParentHandlingUnitId = @handlingunitid
delete from WarehouseContent where ParentHandlingUnitId = @handlingunitid
delete from WarehouseContent where HandlingUnitId = @handlingunitid
delete from HandlingUnitIdentifier where HandlingUnitId = @handlingunitid
delete from ShipmentLine where HandlingUnitId = @handlingunitid
delete from HandlingUnit where parenthandlingunitid = @handlingunitid
delete from HandlingUnit where id = @handlingunitid

INSERT INTO [IndexQueue] VALUES(NEWID(), 'Deufol.OSL.EntryTool.Data.Model.HandlingUnit, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null', @handlingunitid, 1, NULL,(select id from [User] where login = 'tomas.barcuch'), (select id from [User] where login = 'tomas.barcuch'), GETUTCDATE(),GETUTCDATE());

ROLLBACK


begin TRANSACTION 
declare @loosepartid as UNIQUEIDENTIFIER
set @loosepartid = '8529cbc9-cd6f-4c67-abe6-8546898b7603'

delete from BusinessUnitPermission where LoosePartId = @loosepartid
delete from BusinessUnitPermission where PackingOrderLineId in (select id from PackingOrderLine where LoosePartId = @loosepartid)
delete from EntityDimensionValueRelation where EntityId = @loosepartid
delete from CustomFieldValueMapping where EntityId = @loosepartid
delete from WarehouseEntry where LoosepartId = @loosepartid
delete from WarehouseContent where LoosePartId = @loosepartid
delete from LoosePartUnitOfMeasure where LoosePartId = @loosepartid
delete from PackingOrderLine where LoosePartId = @loosepartid
delete from LoosePartIdentifier where LoosePartId = @loosepartid
delete from LoosePart where id = @loosepartid

INSERT INTO [IndexQueue] VALUES(
 --select
NEWID(), 
'Deufol.OSL.EntryTool.Data.Model.LoosePart, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null', 
@loosepartid, -- EntityId
1, -- 0 = Insert x 1 = Delete
NULL,
(select id from [User] where login = 'tomas.barcuch'), -- user id
(select id from [User] where login = 'tomas.barcuch'), -- user id
GETUTCDATE(),
GETUTCDATE()
)

ROLLBACK


begin TRANSACTION 
declare @PackingOrderId as UNIQUEIDENTIFIER
set @PackingOrderId = '74c31ee8-76f2-4614-a40c-afc4dfbc3ca9'

delete from BusinessUnitPermission where PackingOrderHeaderId = @PackingOrderId
delete from EntityDimensionValueRelation where EntityId = @PackingOrderId
delete from CustomFieldValueMapping where EntityId = @PackingOrderId
delete from WorkFlowEntry where EntityId = @handlingunitid
delete from PackingOrderHeader where id = @PackingOrderId

INSERT INTO [IndexQueue] VALUES(
 --select
NEWID(), 
'Deufol.OSL.EntryTool.Data.Model.PackingOrderHeader, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null', 
@PackingOrderId, -- EntityId
1, -- 0 = Insert x 1 = Delete
NULL,
(select id from [User] where login = 'tomas.barcuch'), -- user id
(select id from [User] where login = 'tomas.barcuch'), -- user id
GETUTCDATE(),
GETUTCDATE()
)



ROLLBACK

