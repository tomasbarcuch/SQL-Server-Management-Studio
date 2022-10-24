BEGIN TRANSACTION

DECLARE @wrong as UNIQUEIDENTIFIER  = (select Id from DimensionValue where Content = '0007033220X'
 and DimensionId in 
(Select DimensionId from BusinessUnitPermission where BusinessUnitId = (Select id from BusinessUnit where name = 'KRONES GLOBAL') and DimensionId is not null))
DECLARE @correct as UNIQUEIDENTIFIER = (select Id from DimensionValue where Content = '0007033220' and DimensionId in 
(Select DimensionId from BusinessUnitPermission where BusinessUnitId = (Select id from BusinessUnit where name = 'KRONES GLOBAL') and DimensionId is not null))


--update
update DimensionValue set ParentDimensionValueId = @correct where ParentDimensionValueId = @wrong
update EntityDimensionValueRelation set DimensionValueId = @correct where DimensionValueId = @wrong


--delete
delete from BusinessUnitPermission where DimensionValueId = @wrong
delete from DimensionFieldValue where DimensionValueId = @wrong
delete from DimensionValue where Id = @wrong


INSERT INTO [IndexQueue] VALUES(
 --select
NEWID(), 
'Deufol.OSL.EntryTool.Data.Model.Dimension, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null', -- 'Deufol.OSL.EntryTool.Data.Model.LoosePart, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null'
@wrong, -- EntityId
1, -- 0 = Insert x 1 = Delete
NULL,
(select id from [User] where login = 'tomas.barcuch'), -- user id
(select id from [User] where login = 'tomas.barcuch'), -- user id
GETUTCDATE(),
GETUTCDATE()
)



COMMIT