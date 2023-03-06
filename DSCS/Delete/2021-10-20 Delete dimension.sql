begin TRANSACTION

Declare @DimensionId as UNIQUEIDENTIFIER = 'bcb09aeb-7c3f-4c83-bc93-2010c2b53de8'



delete from BusinessUnitPermission where NumberSeriesId in (select id from NumberSeries where DimensionId = @DimensionId)
delete from BusinessUnitPermission where WorkflowId in (select id from Workflow where DimensionId = @DimensionId)
delete from BusinessUnitPermission where DimensionId = @DimensionId
delete from BusinessUnitPermission where DimensionValueId in (select id from DimensionValue where DimensionId = @DimensionId)
delete from NumberSeries where DimensionId = @DimensionId
delete from DimensionField where DimensionId = @DimensionId
delete from Workflow where DimensionId = @DimensionId
update Dimension set ParentDimensionId = NULL from Dimension where ParentDimensionId = @DimensionId
delete from Tab where DimensionId = @DimensionId
delete from EntityDimensionValueRelation where DimensionValueId in (select id from DimensionValue where DimensionId = @DimensionId)
delete from DimensionValue where DimensionId = @DimensionId
delete from Dimension where id = @DimensionId

ROLLBACK