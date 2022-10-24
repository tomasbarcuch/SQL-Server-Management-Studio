select
HU.Code,
LP.Code,
CV.Content

from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siempelkamp Maschinen- und Anlagenbau GmbH')
left join LoosePart LP on HU.id = LP.ActualHandlingUnitId
inner join CustomValue CV on LP.id = CV.EntityId and CV.CustomFieldId = (select id from CustomField where name = 'UUP' and ClientBusinessUnitId = (select id from BusinessUnit where name = 'Siempelkamp Maschinen- und Anlagenbau GmbH') and entity = 15)


