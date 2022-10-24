select count(distinct(id)) count,  name, entity from CustomField CF
inner join (select CustomFieldId from CustomValue where len(Content)=0) CV on CF.Id = CV.CustomFieldId

group by entity, name

--having count(distinct(id)) > 1

order by entity, count(distinct(id)) desc,  name 




select  BU.Name, CF.name+'|', entity from CustomField CF
inner join (select CustomFieldId from CustomValue where len(Content)=0) CV on CF.Id = CV.CustomFieldId
inner join BusinessUnit BU on CF.ClientBusinessUnitId = BU.Id

where BU.Name = 'DIVERSE KUNDEN NRW MIGRATION'

group by BU.Name, entity, CF.name
order by BU.Name, entity, CF.name


BEGIN TRANSACTION
select *  from CustomValue where CustomFieldId in (
select  CF.id from CustomField CF
inner join (select CustomFieldId from CustomValue where len(Content)=0) CV on CF.Id = CV.CustomFieldId
inner join BusinessUnit BU on CF.ClientBusinessUnitId = BU.Id
where BU.Name = 'DIVERSE KUNDEN NRW MIGRATION'
group by CF.ID
)
commit

BEGIN TRANSACTION
select * from Customfield where Id in (
select  CF.id from CustomField CF
inner join (select CustomFieldId from CustomValue where len(Content)=0) CV on CF.Id = CV.CustomFieldId
inner join BusinessUnit BU on CF.ClientBusinessUnitId = BU.Id
where BU.Name = 'DIVERSE KUNDEN NRW MIGRATION'
group by CF.ID
)
COMMIT







