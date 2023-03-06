begin TRANSACTION

declare @DimensionValueId as UNIQUEIDENTIFIER = '96a94649-1000-4c6c-affd-9e667db2b476'

delete from BusinessUnitPermission where DimensionValueId = @DimensionValueId
delete from EntityDimensionValueRelation where DimensionValueId = @DimensionValueId
delete from DimensionFieldValue where DimensionValueId = @DimensionValueId
delete from DimensionValue where id = @DimensionValueId

INSERT INTO [IndexQueue] VALUES(NEWID(), 'Deufol.OSL.EntryTool.Data.Model.DimensionValue, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null',@DimensionValueId,1,NULL,(select id from [User] where login = 'tomas.barcuch'), (select id from [User] where login = 'tomas.barcuch'), GETUTCDATE(),GETUTCDATE())

COMMIT

