
declare @packer as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')


declare @InventoryHeaderId as UNIQUEIDENTIFIER = '74e57b1e-8257-4fcb-a6a8-8790cd5a6252'
declare @client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
declare @LocationId as UNIQUEIDENTIFIER = (select LocationId from InventoryHeader where id = @InventoryHeaderId )

select 
A.Id
,A.Code
,ISNULL(T.Text,A.[Description]) as Description

from BCSAction A
INNER JOIN BusinessUnitPermission BUP on A.Id = BUP.BCSActionId and BUP.BusinessUnitId = @client and A.BCSaction = 15
LEFT JOIN Translation T on A.id = T.EntityId and T.[Column] = 'Description' and T.[Language] = 'de'