begin TRANSACTION

Declare @DimensionId as UNIQUEIDENTIFIER = '45adc50f-f15b-4647-bbb2-d4b5e30ea251'



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

COMMIT