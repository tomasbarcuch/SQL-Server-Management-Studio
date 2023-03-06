SELECT 
ISNULL(CAST(PackingRules.[Position] as varchar)+'/'+CAST(PackingRules.[Count] as varchar),CAST(PackingOrderLines.[Position] as varchar)+'/'+CAST(PackingOrderLines.[Count] as varchar)) as PackingRulePosition
,CAST(PackingOrderLines.[Position] as varchar)+'/'+CAST(PackingOrderLines.[Count] as varchar) as PackingOrderPosition
  FROM [Loosepart] as [ENT]

LEFT JOIN (
Select
PR.LoosePartId
,ROW_NUMBER() over (partition by PR.ParentHandlingUnitId order by PR.ParentHandlingUnitId, PR.Created) Position
,COUNT(PR.Id) over (partition by PR.ParentHandlingUnitId) Count
 from PackingRule PR) PackingRules on ENT.ID = PackingRules.LoosePartId

LEFT JOIN (
Select
POL.LoosePartId
,ROW_NUMBER() over (partition by POL.PackingOrderHeaderId order by POL.PackingOrderHeaderId, POL.Created) Position
,COUNT(POL.Id) over (partition by POL.PackingOrderHeaderId) Count
 from PackingOrderLine POL) PackingOrderLines on ENT.ID = PackingOrderLines.LoosePartId



where ENT.Id in(
  'c7276fdb-4481-4f91-b79b-930a6f88606c'
  ,'e131293a-68fd-402c-8575-9e65f1a91060')

/*
Select
ISNULL(SL.HandlingUnitId,SL.LoosePartId) as EntityId
,ROW_NUMBER() over (partition by SL.ShipmentHeaderId order by SL.ShipmentHeaderId, SL.[LineNo]) Position
,COUNT(SL.Id) over (partition by SL.ShipmentHeaderId) Count
 from ShipmentLine SL
 where SL.[Type] <> 0
 */