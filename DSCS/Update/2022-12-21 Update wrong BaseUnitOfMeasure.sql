BEGIN TRANSACTION

declare @client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Siemens Duisburg')

declare @UOMold as UNIQUEIDENTIFIER = (
    select UOM.Id from UnitOfMeasure UOM 
    inner join BusinessUnitPermission BUP on UOM.id = BUP.UnitOfMeasureId and BUP.BusinessUnitId = @client
where UOM.Code = 'ST' )


declare @UOMnew as UNIQUEIDENTIFIER = (
    select UOM.Id from UnitOfMeasure UOM 
    inner join BusinessUnitPermission BUP on UOM.id = BUP.UnitOfMeasureId and BUP.BusinessUnitId = @client
where UOM.Code = 'PC' )





--UPDATE LP set LP.BaseUnitOfMeasureId = @UOMnew from LoosePart LP where LP.BaseUnitOfMeasureId = @UOMold and LP.Id in (--1.step
UPDATE LPUOM set LPUOM.UnitOfMeasureId = @UOMnew FROM LoosePartUnitOfMeasure LPUOM where LPUOM.UnitOfMeasureId = @UOMold and LPUOM.LoosePartId in (--2.step



select LP.id from LoosePart LP
where LP.Code in (

'BC000395C214952',
'BC000395C214934',
'BC000395C214935',
'BC000395C214960'
))
COMMIT

