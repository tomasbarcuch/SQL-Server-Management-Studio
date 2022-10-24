begin TRANSACTION

declare @DimensionValueId as UNIQUEIDENTIFIER = '76323dad-e616-421c-87b6-59e5e9cd932e'

delete from BusinessUnitPermission where DimensionValueId = @DimensionValueId
delete from EntityDimensionValueRelation where DimensionValueId = @DimensionValueId
delete from DimensionFieldValue where DimensionValueId = @DimensionValueId
delete from DimensionValue where id = @DimensionValueId

INSERT INTO [IndexQueue] VALUES(NEWID(), 'Deufol.OSL.EntryTool.Data.Model.DimensionValue, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null',@DimensionValueId,1,NULL,(select id from [User] where login = 'tomas.barcuch'), (select id from [User] where login = 'tomas.barcuch'), GETUTCDATE(),GETUTCDATE())

COMMIT

