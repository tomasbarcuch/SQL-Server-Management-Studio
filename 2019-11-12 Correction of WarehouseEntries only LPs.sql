BEGIN TRANSACTION -- oprava loosepartů

DECLARE @TopHUId AS UNIQUEIDENTIFIER = '02ed08ac-8e76-483b-89f2-d23d0f0d362b';
DECLARE @ParentHUId AS UNIQUEIDENTIFIER = 'aedb557b-06fd-4330-91e1-7b1d8287569d';
DECLARE @HUId AS UNIQUEIDENTIFIER = '191f798e-ea43-4be9-aab1-c61409b94a12';
DECLARE @TopLocationId AS UNIQUEIDENTIFIER = (select id from location where code = 'JOBSITE');
DECLARE @TopZoneId AS UNIQUEIDENTIFIER = (select id from zone where name = 'GR_JOBSITE');
DECLARE @TopBinId AS UNIQUEIDENTIFIER = (select id from bin where code = 'GR_JOBSITE');
DECLARE @FromCreated AS DATETIME = '2019-08-30T10:30:00';


INSERT INTO WarehouseEntry ([Id],
[RegisteringDate],
[LocationId],
[ZoneId],
[BinId],
[LoosepartId],
[HandlingUnitId],
[ParentHandlingUnitId],
[Quantity],
[QuantityBase],
[QuantityPerUOM],
[CreatedById],
[UpdatedById],
[Created],
[Updated],
[UnitOfMeasureId])
SELECT NEWID() AS Id, we.RegisteringDate, we.LocationId, we.ZoneId, we.BinId, lp.Id As LooasePartId, lp.ActualHandlingUnitId AS HandlingUnitId, null as ParentHandlingUnitId,
We.Quantity * qt.BaseQuantity, --předělat
we.QuantityBase * qt.BaseQuantity, --předělat
we.QuantityPerUOM, we.CreatedById, we.UpdatedById, we.Created, we.Updated, lp.BaseUnitOfMeasureId as UnitOfMeasureId
FROM LoosePart lp, WarehouseEntry we 
,(select max(QuantityBase) as BaseQuantity,LoosePartID from WarehouseEntry where QuantityBase > 0 group by LoosepartId) qt
WHERE lp.actualHandlingUnitId = @HUId AND lp.ActualLocationId <> @TopLocationId
AND we.HandlingUnitId = @HUId and we.LoosepartId is NULL AND we.Created >= @FromCreated
and qt.LoosepartId = lp.Id


DELETE FROM WarehouseContent WHERE LoosepartId IN (
SELECT lp.Id FROM LoosePart lp WHERE lp.actualHandlingUnitId = @HUId AND lp.ActualLocationId <> @TopLocationId
)


insert into WarehouseContent (
    [Id],
	[LocationId],
	[ZoneId],
	[BinId],
	[LoosePartId],
	[HandlingUnitId],
	[ParentHandlingUnitId],
	[BlockMovement],
	[CreatedById],
	[UpdatedById],
	[Created],
	[Updated],
	[QuantityBase]
    )  
select 
newid(),
	we.LocationId,
	we.ZoneId,
	we.BinId,
	we.LoosePartId,
	we.HandlingUnitId,
	we.[ParentHandlingUnitId],
	0,
	we.[CreatedById],
	we.[UpdatedById],
	we.[Created],
	we.[Updated],
	qt.BaseQuantity

from WarehouseEntry We
inner join (select max(QuantityBase) as BaseQuantity,LoosePartID from WarehouseEntry where QuantityBase > 0 group by LoosepartId) qt on we.LoosepartId = qt.LoosepartId
inner join (select lp.id, max(we.created) as created from LoosePart LP
left join WarehouseEntry WE on LP.Id = WE.LoosePartId
where lp.actualHandlingUnitId = @HUId AND lp.ActualLocationId <> @TopLocationId and we.QuantityBase>0
group by lp.id) data on WE.LoosepartId = data.Id and we.Created = data.created and we.QuantityBase > 0



UPDATE LoosePart SET ActualLocationId = @TopLocationId, ActualZoneId = @TopZoneId, ActualBinId = @TopBinId 
WHERE ActualHandlingUnitId = @HUId AND ActualLocationId <> @TopLocationId

ROLLBACK