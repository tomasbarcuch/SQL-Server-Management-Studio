declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
declare @PackerBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Karl Gross Internationale Spedition GmbH')
declare @NewPackerBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'KAG Karl Gross Spediteur')

begin transaction

update BusinessUnitPermission set BusinessUnitId = @NewPackerBusinessUnitId where HandlingUnitId in (
select Id from HandlingUnit HU
WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HU.id) AND ([BUP].[BusinessUnitId] = @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HU.id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))
) and BusinessUnitId = @PackerBusinessUnitId


update BusinessUnitPermission set BusinessUnitId = @NewPackerBusinessUnitId where LoosePartId in (
select Id from LoosePart LP
WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosepartId] = LP.Id) AND ([BUP].[BusinessUnitId] = @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosepartId] = LP.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))
) and BusinessUnitId = @PackerBusinessUnitId


update BusinessUnitPermission set BusinessUnitId = @NewPackerBusinessUnitId where ShipmentHeaderId in (
select Id from ShipmentHeader SH
WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentHeaderId] = SH.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentHeaderId] = SH.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))
) and BusinessUnitId = @PackerBusinessUnitId

update BusinessUnitPermission set BusinessUnitId = @NewPackerBusinessUnitId where ShipmentLineId in (
select Id from ShipmentLine SL
WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentLineId] = SL.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentLineId] = SL.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))
) and BusinessUnitId = @PackerBusinessUnitId


update BusinessUnitPermission set BusinessUnitId = @NewPackerBusinessUnitId where PackingOrderHeaderId in (
select Id from PackingOrderHeader POH
WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[PackingOrderHeaderId] = POH.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[PackingOrderHeaderId] = POH.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))
) and BusinessUnitId = @PackerBusinessUnitId

update BusinessUnitPermission set BusinessUnitId = @NewPackerBusinessUnitId where ServiceLineId in (
select Id as Code from ServiceLine SL
WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ServiceLineId] = SL.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ServiceLineId] = SL.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))
) and BusinessUnitId = @PackerBusinessUnitId


COMMIT
