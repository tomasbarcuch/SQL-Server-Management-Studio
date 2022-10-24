
BEGIN TRANSACTION

declare @packerid as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Brussels Airport')
--declare @clientid as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'BHS')
update BusinessUnit set disabled = 1 where ID in (
select 
bu.Id

 from BusinessUnitRelation BUR

inner join BusinessUnit BU on BUR.BusinessUnitId = BU.Id and BU.[Disabled] = 0
where RelatedBusinessUnitId = @packerid
--and bu.name not in ('Versalis','BÜHLER AG')
)

rollback
