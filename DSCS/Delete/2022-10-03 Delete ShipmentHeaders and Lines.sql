begin TRANSACTION
declare @ShipmentHeaderId as UNIQUEIDENTIFIER = 'c069b6fb-9af5-48f9-9233-562bca5b08ad'--'bd92cbc5-f752-4db3-9747-089523a5ca3a'
--select * from ShipmentHeader where code = 'TEST_US_Offsite-hub'


delete from BusinessUnitPermission where ShipmentHeaderId = @ShipmentHeaderId
delete from EntityDimensionValueRelation where EntityId = @ShipmentHeaderId
delete from EntityDimensionValueRelation where EntityId = (select Id from ShipmentLine where ShipmentHeaderId = @ShipmentHeaderId)
delete from WorkFlowEntry where EntityId = @ShipmentHeaderId
delete from CustomFieldValueMapping where EntityId = @ShipmentHeaderId
delete from ShipmentHeader where id = @ShipmentHeaderId
--delete from BusinessUnitPermission where ShipmentLineId in (select Id from ShipmentLine where ShipmentHeaderId = @ShipmentHeaderId)
--delete from ShipmentLine where @ShipmentHeaderId = @ShipmentHeaderId



INSERT INTO [IndexQueue] VALUES(NEWID(), 'Deufol.OSL.EntryTool.Data.Model.ShipmentHeader, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null', @ShipmentHeaderId, 1, NULL,(select id from [User] where login = 'tomas.barcuch'), (select id from [User] where login = 'tomas.barcuch'), GETUTCDATE(),GETUTCDATE());

ROLLBACK



