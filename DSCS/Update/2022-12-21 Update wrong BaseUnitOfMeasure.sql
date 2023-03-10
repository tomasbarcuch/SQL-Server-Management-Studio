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

UPDATE LP set LP.BaseUnitOfMeasureId = @UOMnew from LoosePart LP where LP.BaseUnitOfMeasureId = @UOMold and LP.Id in (

select LP.id from LoosePart LP
where LP.Code in (

SELECT 
SUBSTRING(XMLDocument,CHARINDEX('"Code" : "',XMLDocument,1)+10,15)
  FROM DCNLPWSQL05.[DFCZ_OSLETSYNC].[dbo].[Queue] 
where ErrorMessage = 'Import Error: BaseUnitOfMeasure - Column: BaseUnitOfMeasure Value: PC - It is not allowed to change base unit of measure; It is not allowed to change base unit of measure'

))

update LPUOM set LPUOM.UnitOfMeasureId = LP.BaseUnitOfMeasureId from LoosePartUnitOfMeasure LPUOM inner join LoosePart LP on LPUOM.LoosePartId = LP.id where LP.BaseUnitOfMeasureId <> LPUOM.UnitOfMeasureId

COMMIT


