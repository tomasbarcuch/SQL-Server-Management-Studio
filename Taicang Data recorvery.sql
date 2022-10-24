
declare @clientid as UNIQUEIDENTIFIER = (select id from DFCZ_OSLET_BAK.dbo.BusinessUnit where name in ('Krones Taicang'))
declare @packerid as UNIQUEIDENTIFIER = (select id from DFCZ_OSLET_BAK.dbo.BusinessUnit where name in ('Deufol Taicang'))
declare @LocationDeufol as UNIQUEIDENTIFIER = (select id from location where name = 'Deufol Taicang')
declare @LocationKrones as UNIQUEIDENTIFIER = (select id from location where name = 'Krones Taicang')

begin TRANSACTION
/*
insert into DFCZ_OSLET.dbo.Location (
    [Id],
	[Name],
	[AddressId],
	[BinMandatory],
	[DefaultBinId],
	[DefaultBinSelection],
	[BinCapacityPolicy],
	[Description],
	[Disabled],
	[CreatedById],
	[UpdatedById],
	[Created],
	[Updated],
	[AllowQuantityChange],
	[Code],
	[Capacity])

select 
[Id],
	[Name],
	[AddressId] ,
	[BinMandatory],
	[DefaultBinId],
	[DefaultBinSelection],
	[BinCapacityPolicy],
	[Description],
	[Disabled],
	[CreatedById],
	[UpdatedById],
	[Created],
	[Updated],
	[AllowQuantityChange],
	[Code],
	[Capacity]

 from DFCZ_OSLET_BAK.dbo.Location L where L.id in ('ced5ce4c-1850-48d4-8b1c-ec6d4718f463','e63d7522-3b12-4781-90d1-f21fb6c055c6')



insert into DFCZ_OSLET.dbo.BusinessUnitPermission (
    [Id],
    [BusinessUnitId],
    [PermissionType],
    [HandlingUnitId],
    [LoosePartId],
    [ShipmentHeaderId],
    [ShipmentLineId],
    [InventoryHeaderId],
    [InventoryLineId],
    [CommentId],
    [ServiceTypeId],
    [ServiceLineId],
    [LocationId],
    [PackingOrderHeaderId],
    [PackingOrderLineId],
    [AddressId],
    [DimensionId],
    [HandlingUnitTypeId],
    [UnitOfMeasureId],
    [WorkflowId],
    [StatusId],
    [StatusFilterId],
    [BCSActionId],
    [NumberSeriesId],
    [CreatedById],
    [UpdatedById],
    [Created],
    [Updated],
    [DimensionValueId])

select [Id],
    [BusinessUnitId],
    [PermissionType],
    [HandlingUnitId],
    [LoosePartId],
    [ShipmentHeaderId],
    [ShipmentLineId],
    [InventoryHeaderId],
    [InventoryLineId],
    [CommentId],
    [ServiceTypeId],
    [ServiceLineId],
    [LocationId],
    [PackingOrderHeaderId],
    [PackingOrderLineId],
    [AddressId],
    [DimensionId],
    [HandlingUnitTypeId],
    [UnitOfMeasureId],
    [WorkflowId],
    [StatusId],
    [StatusFilterId],
    [BCSActionId],
    [NumberSeriesId],
    [CreatedById],
    [UpdatedById],
    [Created],
    [Updated],
    [DimensionValueId]
 from DFCZ_OSLET_BAK.dbo.BusinessUnitPermission BUP where BUP.LocationId in (@LocationDeufol,@LocationKrones) and BUP.BusinessUnitId in (@clientid,@packerid)


insert into DFCZ_OSLET.dbo.[Zone]
    ([Id],
    [LocationId],
    [Name],
    [Description],
    [Disabled],
    [CreatedById],
    [UpdatedById],
    [Created],
    [Updated],
    [Capacity])

   select  [Id],
    [LocationId],
    [Name],
    [Description],
    [Disabled],
    [CreatedById],
    [UpdatedById],
    [Created],
    [Updated],
    [Capacity] from DFCZ_OSLET_BAK.dbo.[Zone] Z where Z.LocationId in (@LocationDeufol,@LocationKrones)


insert into DFCZ_OSLET.dbo.[Bin]
([Id],
    [Code],
    [LocationId],
    [ZoneId],
    [Description],
    [Length],
    [Width],
    [Height],
    [Empty],
    [MaximumWeight],
    [BlockMovement],
    [Disabled],
    [CreatedById],
    [UpdatedById],
    [Created],
    [Updated],
    [MaximumVolume])

select [Id],
    [Code],
    [LocationId],
    [ZoneId],
    [Description],
    [Length],
    [Width],
    [Height],
    [Empty],
    [MaximumWeight],
    [BlockMovement],
    [Disabled],
    [CreatedById],
    [UpdatedById],
    [Created],
    [Updated],
    [MaximumVolume]
  from DFCZ_OSLET_BAK.dbo.Bin B where B.LocationId in (@LocationDeufol,@LocationKrones)



insert into DFCZ_OSLET.dbo.[WarehouseEntry]
(
[Id],
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
    [UnitOfMeasureId],
    [InventoryHeaderId]
)

select WE.[Id],
    WE.[RegisteringDate],
    WE.[LocationId],
    WE.[ZoneId],
    WE.[BinId],
    WE.[LoosepartId],
    WE.[HandlingUnitId],
    WE.[ParentHandlingUnitId],
    WE.[Quantity],
    WE.[QuantityBase],
    WE.[QuantityPerUOM],
    WE.[CreatedById],
    WE.[UpdatedById],
    WE.[Created],
    WE.[Updated],
    WE.[UnitOfMeasureId],
    WE.[InventoryHeaderId]

 from DFCZ_OSLET_BAK.dbo.WarehouseEntry WE

left outer join DFCZ_OSLET.dbo.WarehouseEntry WEpro on WE.id = WEpro.Id

where WEpro.id is null and



(WE.LoosepartId in (
select LoosePartID entityId from BusinessUnitPermission BUP
inner join DFCZ_OSLET.dbo.LoosePart LP on BUP.LoosePartId = LP.Id
where BusinessUnitId = @clientid)
or
 (WE.HandlingUnitId in (
select HandlingUnitId from BusinessUnitPermission BUP
inner join DFCZ_OSLET.dbo.HandlingUnit HU on BUP.HandlingUnitId = HU.Id
where BusinessUnitId = @clientid) and WE.LoosepartId is null)

or (WE.ParentHandlingUnitId in (
select HandlingUnitId from BusinessUnitPermission BUP
inner join DFCZ_OSLET.dbo.HandlingUnit HU on BUP.HandlingUnitId = HU.Id
where BusinessUnitId = @clientid) and WE.LoosePartId is null and WE.HandlingUnitId is null))


insert into DFCZ_OSLET.dbo.[WarehouseContent]
(   [Id],
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
    [QuantityBase])


select 
    WC.[Id],
    WC.[LocationId],
    WC.[ZoneId],
    WC.[BinId],
    WC.[LoosePartId],
    WC.[HandlingUnitId],
    WC.[ParentHandlingUnitId],
    WC.[BlockMovement],
    WC.[CreatedById],
    WC.[UpdatedById],
    WC.[Created],
    WC.[Updated],
    WC.[QuantityBase]
 from DFCZ_OSLET_BAK.dbo.WarehouseContent WC 

left outer join DFCZ_OSLET.dbo.WarehouseContent WCpro on WC.id = WCpro.Id
right join LoosePart LP on WC.LoosePartId = LP.id
where WCpro.id is null and LP.ActualLocationId in (@LocationDeufol,@LocationKrones) and

(WC.LoosepartId in (
select LoosePartID entityId from BusinessUnitPermission BUP
inner join DFCZ_OSLET.dbo.LoosePart LP on BUP.LoosePartId = LP.Id
where BusinessUnitId = @clientid)
or
 (WC.HandlingUnitId in (
select HandlingUnitId from BusinessUnitPermission BUP
inner join DFCZ_OSLET.dbo.HandlingUnit HU on BUP.HandlingUnitId = HU.Id
where BusinessUnitId = @clientid) and WC.LoosepartId is null)

or (WC.ParentHandlingUnitId in (
select HandlingUnitId from BusinessUnitPermission BUP
inner join DFCZ_OSLET.dbo.HandlingUnit HU on BUP.HandlingUnitId = HU.Id
where BusinessUnitId = @clientid) and WC.LoosePartId is null and WC.HandlingUnitId is null))




ROLLBACK

BEGIN TRANSACTION

UPDATE DFCZ_OSLET.dbo.WarehouseContent set LocationId = WC.LocationID, ZoneId = WC.ZoneId, BinId = WC.BinId

from
HandlingUnit HU
left join WarehouseContent WC on HU.id = WC.HandlingUnitId
inner join DFCZ_OSLET.dbo.WarehouseContent WCprod on WC.id = WCprod.ID

inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId where BUP.BusinessUnitId = @clientid
and WC.HandlingUnitId is not null and WC.LoosePartId is null
and ActualLocationId is not null
*/
ROLLBACK
/*

begin TRANSACTION 
update HandlingUnit set ActualLocationId = WC.LocationId, ActualZoneId = WC.ZoneId, ActualBinId = WC.BinId
from
HandlingUnit HU
left join WarehouseContent WC on HU.id = WC.HandlingUnitId
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId where BUP.BusinessUnitId = @clientid
and WC.HandlingUnitId is not null and WC.LoosePartId is null
and ActualLocationId is null and WC.LocationId is not null

ROLLBACK
*/
begin TRANSACTION

UPDATE Loosepart set ActualLocationId = WC.LocationId, ActualZoneId = WC.ZoneId, ActualBinId = WC.BinId
--select WC.LocationId, LP.ActualLocationId
from
LoosePart LP
left join WarehouseContent WC on LP.id = WC.LoosePartId
--inner join WarehouseContent WCprod on WC.id = WCprod.ID

inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId where BUP.BusinessUnitId = @clientid
and ActualLocationId is null and WC.LocationId is not null
commit