
declare @packer as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')


/*
declare @client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
declare @InventoryHeaderId as UNIQUEIDENTIFIER = ( Select IH.Id from InventoryHeader IH 
inner join BusinessUnitPermission BUP on IH.Id = BUP.InventoryHeaderId  and BUP.BusinessUnitId = @packer and IH.Code = 'INV-2023-0002')
*/
/*
declare @client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'KRONES GLOBAL')
declare @InventoryHeaderId as UNIQUEIDENTIFIER = ( Select IH.Id from InventoryHeader IH 
inner join BusinessUnitPermission BUP on IH.Id = BUP.InventoryHeaderId  and BUP.BusinessUnitId = @packer and IH.Code = 'INVKR-1003')
*/
/*
declare @client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Siempelkamp Maschinen- und Anlagenbau GmbH')
declare @InventoryHeaderId as UNIQUEIDENTIFIER = ( Select IH.Id from InventoryHeader IH 
inner join BusinessUnitPermission BUP on IH.Id = BUP.InventoryHeaderId  and BUP.BusinessUnitId = @packer and IH.Code = 'INV-SIE-2023')
*/
/*
declare @client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'SMS Group')
declare @InventoryHeaderId as UNIQUEIDENTIFIER = ( Select IH.Id from InventoryHeader IH 
inner join BusinessUnitPermission BUP on IH.Id = BUP.InventoryHeaderId  and BUP.BusinessUnitId = @packer and IH.Code = 'INV-SMS-2023')
*/

declare @LocationId as UNIQUEIDENTIFIER = (select LocationId from InventoryHeader where id = @InventoryHeaderId )


begin TRANSACTION

delete from BusinessUnitPermission  where InventoryLineId in (select id from InventoryLine IL where IL.InventoryHeaderId = @InventoryHeaderId) and BusinessUnitId = @client
DELETE from BusinessUnitPermission  where InventoryLineId in (select id from InventoryLine IL where IL.InventoryHeaderId = @InventoryHeaderId) and BusinessUnitId = @packer
DELETE from InventoryLine where InventoryHeaderId = @InventoryHeaderId

ROLLBACK

begin TRANSACTION

INSERT INTO InventoryLine

Select
NEWID() Id 
,@InventoryHeaderId as InventoryHeaderId
,HU.ActualZoneId
,HU.ActualBinId
,NULL as LoosepartId
,HU.Id as HandlingUnitId
,1 as ExpectedQuantity
,NULL as CurrentQuantity
,NULL as UnitOfMeasureId
,(select id from [User] U where login = 'tomas.barcuch') CreatedById
,(select id from [User] U where login = 'tomas.barcuch') UpdatedById
,Getdate() Created
,Getdate() Updated

from HandlingUnit HU 
WHERE HU.ActualLocationId = @LocationId 
AND HU.TopHandlingUnitId IS NULL
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HU.id) AND ([BUP].[BusinessUnitId] = @client)) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HU.id) AND ([BUP].[BusinessUnitId] = @packer)) 
AND HU.Id not in (select IL.HandlingUnitId from InventoryLine IL where IL.InventoryHeaderId = @InventoryHeaderId AND IL.HandlingUnitId IS NOT NULL )

UNION

select 
NEWID() Id 
,@InventoryHeaderId as InventoryHeaderId
,LP.ActualZoneId
,LP.ActualBinId
,LP.Id as LoosepartId
,NULL as HandlingUnitId
,WC.QuantityBase as ExpectedQuantity
,NULL as CurrentQuantity
,LP.BaseUnitOfMeasureId as UnitOfMeasureId
,(select id from [User] U where login = 'tomas.barcuch')
,(select id from [User] U where login = 'tomas.barcuch')
,Getdate()
,Getdate()

FROM LoosePart LP
INNER join WarehouseContent WC on LP.id = WC.LoosePartId
WHERE LP.ActualLocationId = @LocationId
AND LP.ActualHandlingUnitId IS null
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosepartId] = LP.Id) AND ([BUP].[BusinessUnitId] = @client)) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[LoosepartId] = LP.Id) AND ([BUP].[BusinessUnitId] = @packer)) 
AND LP.Id not in (select IL.LoosePartId from InventoryLine IL where IL.InventoryHeaderId = @InventoryHeaderId AND IL.LoosePartId IS NOT NULL)


insert into [dbo].[BusinessUnitPermission]
select
	NEWID() [Id],
	[BusinessUnitId] = @client,
	1 [PermissionType],
	NULL [HandlingUnitId],
	NULL [LoosePartId],
	NULL [ShipmentHeaderId],
	NULL [ShipmentLineId],
	NULL [InventoryHeaderId],
	IL.Id [InventoryLineId],
	NULL [CommentId],
	NULL [ServiceTypeId],
	NULL [ServiceLineId],
	NULL [LocationId],
	NULL [PackingOrderHeaderId],
	NULL [PackingOrderLineId],
	NULL [AddressId],
	NULL [DimensionId],
	NULL [HandlingUnitTypeId],
	NULL [UnitOfMeasureId],
	NULL [WorkflowId],
	NULL [StatusId],
	NULL [StatusFilterId],
	NULL [BCSActionId],
	NULL [NumberSeriesId],
	[CreatedById] = (select id from [User] where login = 'tomas.barcuch'),
	[UpdatedById] = (select id from [User] where login = 'tomas.barcuch'),
	GETUTCDATE() [Created],
	GETUTCDATE() [Updated],
	NULL [DimensionValueId],
	NULL [TenderHeaderId],
	NULL [TenderLineId],
	NULL [DocumentTemplateId]

 from InventoryLine IL 
where IL.InventoryHeaderId = @InventoryHeaderId 
AND NOT EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[InventoryLineId] = IL.Id) AND ([BUP].[BusinessUnitId] = @client)) 



insert into [dbo].[BusinessUnitPermission]

select

	NEWID() [Id],
	[BusinessUnitId] = @packer,
	1 [PermissionType],
	NULL [HandlingUnitId],
	NULL [LoosePartId],
	NULL [ShipmentHeaderId],
	NULL [ShipmentLineId],
	NULL [InventoryHeaderId],
	IL.Id [InventoryLineId],
	NULL [CommentId],
	NULL [ServiceTypeId],
	NULL [ServiceLineId],
	NULL [LocationId],
	NULL [PackingOrderHeaderId],
	NULL [PackingOrderLineId],
	NULL [AddressId],
	NULL [DimensionId],
	NULL [HandlingUnitTypeId],
	NULL [UnitOfMeasureId],
	NULL [WorkflowId],
	NULL [StatusId],
	NULL [StatusFilterId],
	NULL [BCSActionId],
	NULL [NumberSeriesId],
	[CreatedById] = (select id from [User] where login = 'tomas.barcuch'),
	[UpdatedById] = (select id from [User] where login = 'tomas.barcuch'),
	GETUTCDATE() [Created],
	GETUTCDATE() [Updated],
	NULL [DimensionValueId],
	NULL [TenderHeaderId],
	NULL [TenderLineId],
	NULL [DocumentTemplateId]

 from InventoryLine IL 
where IL.InventoryHeaderId = @InventoryHeaderId 
AND 

(
NOT EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[InventoryLineId] = IL.Id) AND ([BUP].[BusinessUnitId] = @packer)) 
OR
NOT EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[InventoryLineId] = IL.Id) AND ([BUP].[BusinessUnitId] = @client)) 
)


ROLLBACK


/*
BEGIN TRANSACTION
delete from BusinessUnitPermission where id in (
select min(Id)--, count(ID), BusinessUnitId, ShipmentLineId
from BusinessUnitPermission
where InventoryLineId is not NULL
group by BusinessUnitId, InventoryLineId
having count(ID) > 1
)

ROLLBACK

*/

