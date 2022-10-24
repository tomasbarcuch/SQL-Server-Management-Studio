/*

select hu.id, min(we.Created)packdatum, max(we.Created)lastdatum,hu.code from WarehouseEntry WE 
inner join HandlingUnit HU on we.HandlingUnitId = HU.Id
where WE.HandlingUnitId in (
select id from HandlingUnit where code in (
    'HUKR-000182',    'HUKR-000181',    'HUKR-000183',    'HUKR-000116',    'HUKR-000180',    'HUKR-000121',    'HUKR-000186',    'HUKR-000117',    'HUKR-000120'    ) or
    id in (select ParentHandlingUnitId from HandlingUnit where code in (
 'HUKR-000182',    'HUKR-000181',    'HUKR-000183',      'HUKR-000116',    'HUKR-000180',    'HUKR-000121',    'HUKR-000186',    'HUKR-000117',    'HUKR-000120')
    ) )    and we.LoosepartId is not null and QuantityBase > 0     group by hu.code, hu.id     order by min(we.Created)
*/
BEGIN TRANSACTION -- oprava parent bedny


--DECLARE @TopHUId AS UNIQUEIDENTIFIER = '02ed08ac-8e76-483b-89f2-d23d0f0d362b';
DECLARE @TopHUId AS UNIQUEIDENTIFIER = '3e0a3efb-67b5-4237-83fc-03bb2f2fbfed';
--DECLARE @ParentHUId AS UNIQUEIDENTIFIER = 'aedb557b-06fd-4330-91e1-7b1d8287569d';
--DECLARE @HUId AS UNIQUEIDENTIFIER = '9761fcb1-1315-4482-898d-c2fb439ee3eb';
DECLARE @TopLocationId AS UNIQUEIDENTIFIER = (select id from location where code = 'JOBSITE');
DECLARE @TopZoneId AS UNIQUEIDENTIFIER = (select id from zone where name = 'CONTAINER_BREWHOUSE');
DECLARE @TopBinId AS UNIQUEIDENTIFIER = (select id from bin where code = 'SVWU7224064');
DECLARE @FromCreated AS DATETIME = '2019-10-22T11:40:00';

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
WHERE lp.TopHandlingUnitId = @TopHUId AND lp.ActualLocationId <> @TopLocationId
AND we.HandlingUnitId = @TopHUId AND we.Created >= @FromCreated and we.LoosepartId is null
and qt.LoosepartId = lp.Id
order by lp.id

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
SELECT NEWID() AS Id, we.RegisteringDate, we.LocationId, we.ZoneId, we.BinId, null AS LoosepartId, hu.Id As HandlingUnitId, hu.ParentHandlingUnitId AS ParentHandlingUnitId, 
we.Quantity, we.QuantityBase, we.QuantityPerUOM, we.CreatedById, we.UpdatedById, we.Created, we.Updated, null AS UnitOfMeasureId
FROM HandlingUnit hu, WarehouseEntry we 
WHERE hu.TopHandlingUnitId = @TopHUId AND ActualLocationId <> @TopLocationId
AND we.HandlingUnitId = @TopHUId AND we.loosepartId IS NULL 
AND we.Created >= @FromCreated

DELETE FROM WarehouseContent WHERE LoosepartId IN (
SELECT lp.Id FROM LoosePart lp WHERE lp.TopHandlingUnitId = @TopHUId AND lp.ActualLocationId <> @TopLocationId
)

DELETE FROM WarehouseContent WHERE HandlingUnitId IN (
SELECT hu.Id FROM HandlingUnit hu WHERE hu.TopHandlingUnitId = @TopHUId AND ActualLocationId <> @TopLocationId
) AND LoosePartId IS NULL

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
where lp.TopHandlingUnitId = @TopHUId AND lp.ActualLocationId <> @TopLocationId and we.QuantityBase>0
group by lp.id) data on WE.LoosepartId = data.Id and we.Created = data.created and we.QuantityBase > 0

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
	we.[QuantityBase]  

from WarehouseEntry We
inner join (select hu.id, max(we.created) as created from HandlingUnit hu
inner join WarehouseEntry WE on hu.Id = WE.HandlingUnitId AND we.LoosepartId is NULL
where hu.TopHandlingUnitId = @TopHUId AND hu.ActualLocationId <> @TopLocationId and we.QuantityBase>0
group by hu.id, we.LoosepartId) data on WE.HandlingUnitId = data.Id and we.Created = data.created and we.LoosepartId is null and we.QuantityBase > 0

UPDATE LoosePart SET ActualLocationId = NULL, ActualZoneId = NULL, ActualBinId = NULL 
WHERE TopHandlingUnitId = @TopHUId AND ActualLocationId <> @TopLocationId

UPDATE HandlingUnit SET ActualLocationId = @TopLocationId, ActualZoneId = @TopZoneId, ActualBinId = @TopBinId 
WHERE TopHandlingUnitId = @TopHUId AND ActualLocationId <> @TopLocationId

ROLLBACK