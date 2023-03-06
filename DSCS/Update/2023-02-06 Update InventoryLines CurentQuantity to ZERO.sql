
declare @packer as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')



declare @client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
declare @InventoryHeaderId as UNIQUEIDENTIFIER = ( Select IH.Id from InventoryHeader IH 
inner join BusinessUnitPermission BUP on IH.Id = BUP.InventoryHeaderId  and BUP.BusinessUnitId = @packer and IH.Code = 'INV-DF-2023')

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

declare @LocationId as UNIQUEIDENTIFIER = (select LocationId from InventoryHeader where id = @InventoryHeaderId)

BEGIN TRANSACTION

UPDATE IL set IL.CurrentQuantity = 0 from InventoryLine IL where IL.InventoryHeaderId = @InventoryHeaderId and CurrentQuantity IS NULL

ROLLBACK