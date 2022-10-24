DECLARE @PACKER as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Paris Airport')
DECLARE @OLDCLIENT as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
DECLARE @NEWCLIENT as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Air Liquide Global')

DECLARE @Customer as UNIQUEIDENTIFIER = (select DV.Id from DimensionValue DV
inner join BusinessUnitPermission BUP on DV.id = BUP.DimensionValueId and BUP.BusinessUnitId = @OLDCLIENT
where DV.[Description] = 'Air Liquide Global E & C Solutions France')

select * from EntityDimensionValueRelation EDVR where EDVR.DimensionValueId = @Customer