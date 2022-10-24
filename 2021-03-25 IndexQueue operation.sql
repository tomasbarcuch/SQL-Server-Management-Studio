declare @loosepartid as UNIQUEIDENTIFIER = '2d7b9a46-3c4b-4c08-a224-79bc2bc50ad9'

INSERT INTO [IndexQueue] VALUES(
 --select
NEWID(), 
'Deufol.OSL.EntryTool.Data.Model.LoosePart, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null', -- 'Deufol.OSL.EntryTool.Data.Model.LoosePart, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null'
@loosepartid, -- EntityId
1, -- 0 = Insert x 1 = Delete
NULL,
(select id from [User] where login = 'tomas.barcuch'), -- user id
(select id from [User] where login = 'tomas.barcuch'), -- user id
GETUTCDATE(),
GETUTCDATE()
)


select * from IndexQueue where operation = 1