declare @ClientMerged as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Hansa Meyer Gl. Trans. GmbH and Co. KG')
declare @Client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Hansa Meyer Global Transport GmbH und Co.KG')

begin TRANSACTION
--update BusinessUnitPermission set BusinessUnitId = @ClientMerged
select * from BusinessUnitPermission
where BusinessUnitId = @ClientMerged and (LoosePartId is not null or HandlingUnitId is not null or DimensionValueId is not null)

ROLLBACK