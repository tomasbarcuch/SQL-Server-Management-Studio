


DECLARE @packer as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Frankenthal')

SELECT 
--DATA.Packer, 
SUM(DATA.Entities) as Entities,MAX(DATA.LastUpdate) [Last activity]
,DATA.Client
FROM(

select  COUNT(LP.id) Entities, MAX(LP.Updated) LastUpdate--,BU.Name Packer
,Client.Name as Client
from BusinessUnitPermission BUP with (NOLOCK)
inner join LoosePart LP with (NOLOCK) on BUP.LoosePartId = LP.Id
INNER join BusinessUnit Client on BUP.BusinessUnitId = Client.id and Client.[Disabled] = 0 and Client.[Type] = 2

WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosePartId] = LP.id) AND ([BUP].[BusinessUnitId] in (select BusinessUnitId from BusinessUnitRelation BUR where RelatedBusinessUnitId = @Packer))) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosePartId] = LP.id) AND ([BUP].[BusinessUnitId] = @Packer)) 

group by Client.Name

UNION

select  COUNT(HU.id) Entities, MAX(HU.Updated) LastUpdate--,BU.Name Packer
,Client.Name as Client
from BusinessUnitPermission BUP with (NOLOCK)
inner join HandlingUnit HU with (NOLOCK) on BUP.HandlingUnitId = HU.Id
INNER join BusinessUnit Client on BUP.BusinessUnitId = Client.id and Client.[Disabled] = 0 and Client.[Type] = 2

WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HU.id) AND ([BUP].[BusinessUnitId] in (select BusinessUnitId from BusinessUnitRelation BUR where RelatedBusinessUnitId = @Packer))) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HU.id) AND ([BUP].[BusinessUnitId] = @Packer)) 

group by Client.Name

UNION

select  COUNT(SH.id) Entities, MAX(SH.Updated) LastUpdate--,BU.Name Packer
,Client.Name as Client
from BusinessUnitPermission BUP with (NOLOCK)
inner join ShipmentHeader SH with (NOLOCK) on BUP.ShipmentHeaderId = SH.Id
INNER join BusinessUnit Client on BUP.BusinessUnitId = Client.id and Client.[Disabled] = 0 and Client.[Type] = 2

WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentHeaderId] = SH.id) AND ([BUP].[BusinessUnitId] in (select BusinessUnitId from BusinessUnitRelation BUR where RelatedBusinessUnitId = @Packer))) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentHeaderId] = SH.id) AND ([BUP].[BusinessUnitId] = @Packer)) 
group by Client.Name

UNION

select  COUNT(PO.id) Entities, MAX(PO.Updated) LastUpdate--,BU.Name Packer
,Client.Name as Client
from BusinessUnitPermission BUP with (NOLOCK)
inner join PackingOrderHeader PO with (NOLOCK) on BUP.PackingOrderHeaderId = PO.Id
INNER join BusinessUnit Client on BUP.BusinessUnitId = Client.id and Client.[Disabled] = 0 and Client.[Type] = 2

WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[PackingOrderHeaderId] = PO.id) AND ([BUP].[BusinessUnitId] in (select BusinessUnitId from BusinessUnitRelation BUR where RelatedBusinessUnitId = @Packer))) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[PackingOrderHeaderId] = PO.id) AND ([BUP].[BusinessUnitId] = @Packer)) --$P{PackerBusinessUnitId}))

group by Client.Name




)DATA
GROUp BY DATA.Client