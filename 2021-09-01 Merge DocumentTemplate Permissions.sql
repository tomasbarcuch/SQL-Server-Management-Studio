BEGIN TRANSACTION

declare @REPTOUSE as UNIQUEIDENTIFIER = (select id from documenttemplate where name = 'REP-0007')
declare @REPTODELETE as UNIQUEIDENTIFIER = (select id from documenttemplate where name = 'REP-0158')

update BusinessUnitPermission  set DocumentTemplateId = @REPTOUSE where id in (
select id from BusinessUnitPermission 
where DocumentTemplateId = @REPTODELETE


and BusinessUnitId not in (
select BusinessUnitId from BusinessUnitPermission 
where DocumentTemplateId = @REPTOUSE 
    group by BusinessUnitId
)
)

COMMIT

