declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'SIEMENS BERLIN')
declare @PackerBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol BERLIN')

select Id, Code from HandlingUnit HU
WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HU.id) AND ([BUP].[BusinessUnitId] = @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HU.id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))


select Id, Code from LoosePart LP
WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosepartId] = LP.Id) AND ([BUP].[BusinessUnitId] = @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosepartId] = LP.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))


select Id, Code from ShipmentHeader SH
WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentHeaderId] = SH.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentHeaderId] = SH.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))


select Id, Code from PackingOrderHeader POH
WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[PackingOrderHeaderId] = POH.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[PackingOrderHeaderId] = POH.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))



select Id, [Description] as Code from ServiceLine SL
WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ServiceLineId] = SL.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ServiceLineId] = SL.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))

select Id, [Description] as Code from DimensionValue DV
WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[DimensionValueId] = DV.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[DimensionValueId] = DV.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))



