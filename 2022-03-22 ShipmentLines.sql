declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'SIEMENS BERLIN')
declare @PackerBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Berlin')

select Top(1000)
SH.Code,
SH.Description,
SH.Type,
SH.TruckNumber,
SH.Carrier,
SH.ContainerNumber,
SH.SealNumber,
SH.VesselNumber,
SH.DeliveryDate,
SH.LoadingDate,
ISNULL(SL.HandlingUnitId,SL.LoosePartId) as EntityId,
Entities.* 
from ShipmentLine SL
inner join BusinessUnitPermission BUP on SL.id = BUP.ShipmentLineId
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.id

INNER JOIN (SELECT 'HU'as [Entity],[Id],Null as [BaseUnitOfMeasureId],[Code],[Length],[Width],[Height],[Weight] as Tara,[Netto],[Brutto],[Surface],[BaseArea],[Volume],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ParentHandlingUnitId] as [ActualHandlingUnitId], [ShipmentHeaderId],[NumberSeriesId],[TopHandlingUnitId],[TypeId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled],NULL as [Article],[DangerousGoods],0 as [Damaged],[InboundCode],[InboundDate] FROM HandlingUnit
UNION
SELECT 'LP' as [Entity],[Id],[BaseUnitOfMeasureId],[Code],[Length],[Width],[Height],CASE when Netto > 0 then [Weight]-[Netto] else 0 end,Netto,Weight,[Surface],[BaseArea],[Volume],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ActualHandlingUnitId],[ShipmentHeaderId],[NumberSeriesId],[TopHandlingUnitId],null,null,null,null,null,'TRUE',null,null,null,null,[Article],[DangerousGoods],[Damaged],[InboundCode],[InboundDate] FROM LoosePart) as Entities on ISNULL(SL.HandlingUnitId,SL.LoosePartId) = Entities.Id


WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentLineId] = SL.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ShipmentLineId] = SL.Id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))