select 


Packer.Name Packer,

Packer.REASON,


Client.Name Client



from BusinessUnitRelation BUR

inner join (
select 
BU.*, CV.Content as 'REASON'
from BusinessUnit BU
left join CustomValue CV on BU.id = CV.EntityId
left join CustomField CF on CV.CustomFieldId = CF.Id
where CF.Name = 'REASON' and CF.ClientBusinessUnitId = (Select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
and BU.[Disabled] = 0 and CV.Content = 'PRODUCTION'
) Client on BUR.BusinessUnitId = Client.id

inner join (
select 
BU.*, CV.Content as 'REASON'
from BusinessUnit BU
left join CustomValue CV on BU.id = CV.EntityId
left join CustomField CF on CV.CustomFieldId = CF.Id
where CF.Name = 'REASON' and CF.ClientBusinessUnitId = (Select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
AND BU.[Disabled] = 0 and CV.Content = 'PRODUCTION'
) Packer on BUR.RelatedBusinessUnitId = Packer.id

group by 
Packer.Name,
Packer.REASON,
Client.Name

order by Client.name