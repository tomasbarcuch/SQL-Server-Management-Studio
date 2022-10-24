
DECLARE @NEWCLIENT as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
DECLARE @PACKER as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Braunschweig')

begin TRANSACTION

PRINT '=== Update Elastic search ===';
INSERT INTO [IndexQueue]
select NEWID(), 
'Deufol.OSL.EntryTool.Data.Model.DimensionValue, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null',
 DV.Id,
 0,
 NULL,
(select id from [User] where login = 'tomas.barcuch'), 
(select id from [User] where login = 'tomas.barcuch'), GETUTCDATE(),GETUTCDATE()
from DimensionValue DV
--inner join BusinessUnitPermission BUP on DV.Id = BUP.DimensionValueId and BUP.BusinessUnitId = @NEWCLIENT

WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[DimensionValueId] = DV.Id) AND ([BUP].[BusinessUnitId] =  @NEWCLIENT))
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[DimensionValueId] = DV.Id) AND ([BUP].[BusinessUnitId] = @PACKER))



COMMIT