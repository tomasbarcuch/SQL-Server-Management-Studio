
DECLARE @NEWCLIENT as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Siemens Duisburg')
DECLARE @PACKER as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Mülheim')

begin TRANSACTION

PRINT '=== Update Elastic search ===';
INSERT INTO [IndexQueue]
select NEWID(), 
'Deufol.OSL.EntryTool.Data.Model.LoosePart, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null',
 LP.Id,
 0,
 NULL,
(select id from [User] where login = 'tomas.barcuch'), 
(select id from [User] where login = 'tomas.barcuch'), GETUTCDATE(),GETUTCDATE()
from LoosePart LP
inner join BusinessUnitPermission BUP on LP.Id = BUP.LoosePartId and BUP.BusinessUnitId = @NEWCLIENT

WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosePartId] = LP.Id) AND ([BUP].[BusinessUnitId] =  @NEWCLIENT))
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosePartId] = LP.Id) AND ([BUP].[BusinessUnitId] = @PACKER))


COMMIT