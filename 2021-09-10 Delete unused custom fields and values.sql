
DECLARE @STEPS INT


DECLARE @CUSTOMFIELDID as UNIQUEIDENTIFIER
create TABLE #TEMP 
(
    ID UNIQUEIDENTIFIER
)

insert into #TEMP


select 
--TOP(1)
CF.id from customfield CF with (NOLOCK) 
inner join BusinessUnit BU on CF.ClientBusinessUnitId = BU.id and BU.[Disabled] = 1-- and BU.name = 'SMS Group'
where CF.ID not in (
select CustomFieldId from CustomValue with (NOLOCK) where LEN(Content) > 0 group by CustomFieldId) 
and CF.name not in ('BXNLErrorMsg')


group by CF.id
begin TRANSACTION
delete from CustomValue where CustomFieldId in (select ID from #TEMP)
delete from CustomField where Id in (select ID from #TEMP)
--select * from CustomValue where CustomFieldId in (select ID from #TEMP)
--select * from CustomField where Id in (select ID from #TEMP)

select * from #TEMP
COMMIT

Drop Table #Temp
/*
select Name from CustomField where id not in (
select CustomFieldId from CustomValue with (NOLOCK) where LEN(Content) > 0 group by CustomFieldId)
and name not in ('BXNLErrorMsg') group by name
*/