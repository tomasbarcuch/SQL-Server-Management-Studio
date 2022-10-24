/*

begin TRANSACTION
update T set T.text = P.Name from Translation T
--select P.name, T.id, text,text as česky from Translation T
inner join Permission p on T.EntityId = P.id
where entity = 18 and language = 'de'
ROLLBACK

--where language = 'cs' and text in ('Import komentářů')
*/


/*
begin TRANSACTION
insert into dbo.Translation (id,Language,Entity,[Column],Text,CreatedById,UpdatedById,Created,Updated,EntityId) 
select newid(),'de','18','Name', name,'eba86d7e-e20e-40f0-8e6e-1831fe48e45a','eba86d7e-e20e-40f0-8e6e-1831fe48e45a',getdate(),getdate(), P.id from Permission P
left join Translation T on P.id = T.EntityId and T.[Language] = 'cz'
where t.EntityId is null
rollback
*/

begin TRANSACTION
insert into dbo.Translation (id,Language,Entity,[Column],Text,CreatedById,UpdatedById,Created,Updated,EntityId) 
select-- T.Text,
 newid(),'de','13','Code', 
HUT.Description as text,
(select id from [User] where login = 'tomas.barcuch'),(select id from [User] where login = 'tomas.barcuch'),getdate(),getdate(), HUT.id 

from HandlingUnitType HUT
inner join BusinessUnitPermission BUP on HUT.id = BUP.HandlingUnitTypeId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.Name = 'Siempelkamp Maschinen- und Anlagenbau GmbH'
left join Translation T on HUT.id = T.EntityId and T.[Language] = 'de' and T.[Column] = 'Code'
where HUT.Container = 1
and T.text is null
COMMIT
/*
begin TRANSACTION
--insert into dbo.Translation (id,Language,Entity,[Column],Text,CreatedById,UpdatedById,Created,Updated,EntityId) 
select newid(),'de','56','Name', 
case Tab.name
    when 'CustomFields' then 'Eigene Felder'

else '' end as text,
(select id from [User] where login = 'tomas.barcuch'),(select id from [User] where login = 'tomas.barcuch'),getdate(),getdate(), Tab.id 

from Tab 
left join Translation T on Tab.id = T.EntityId and T.[Language] = 'de'
where Tab.name in (
    'CustomFields'


    
    ) --and CF.Description in ('Construction Macro','Protection','PackingType') 
and T.text is null
ROLLBACK
*/


/*
begin TRANSACTION
update Translation set text = (case CF.name
   when 'Anlagen' then 'Anlagen'
when 'Container No.' then 'Container Nr.'
when 'Damage' then 'Beschädigung'
when 'Damage description' then 'Beschädigung Beschreibung'
when 'Dangerousgoods' then 'Gefährliche Ware'
when 'Doc-closing Datum' then 'Docu-schluss Datum'
when 'Doc-closing Zeit' then 'Docu-schluss Zeit'
when 'Dutiablegoods' then 'Zollpflichtige Ware'
when 'ETA' then 'ETA'
when 'Freistellung' then 'Freistellung'
when 'HuInbound Date' then 'Wareneingang Datum'
when 'HuInbound No' then 'Wareneingang Nummer'
when 'Invoiced' then 'Verrechnet'
when 'Ladeschluss Datum' then 'Ladeschluss Datum'
when 'Ladeschluss Zeit' then 'Ladeschluss Zeit'
when 'Leerdepot' then 'Leerdepot'
when 'Macros' then 'Vorschrifft'
when 'Makler' then 'Makler'
when 'PackingType' then 'Verpackungstyp'
when 'Protection' then 'Konservierung'
when 'Rücklieferung' then 'Rücklieferung'
when 'Seal No.' then 'Siegel Nummer'
when 'VGM' then 'Gewicht nach Verwiegung'
when 'VGM-closing Datum' then 'VGM-schluss Datum'
when 'VGM-closing Zeit' then 'VGM-schluss Zeit'
when 'V-Schein' then 'V-Schein'
when 'BXNLErrorMsg' then 'BoxCAD Fehlermeldung'

else '' end)
from CustomField CF 
left join Translation T on CF.id = T.EntityId and T.[Language] = 'de'
where CF.name in (
'Anlagen',
'Container No.',
'Damage',
'Damage description',
'Dangerousgoods',
'Doc-closing Datum',
'Doc-closing Zeit',
'Dutiablegoods',
'ETA',
'Freistellung',
'HuInbound Date',
'HuInbound No',
'Invoiced',
'Ladeschluss Datum',
'Ladeschluss Zeit',
'Leerdepot',
'Macros',
'Makler',
'PackingType',
'Protection',
'Rücklieferung',
'Seal No.',
'VGM',
'VGM-closing Datum',
'VGM-closing Zeit',
'V-Schein',
'BXNLErrorMsg'



    
    ) 
and Text <>
(case CF.name
    when 'Anlagen' then 'Anlagen'
when 'Container No.' then 'Container Nr.'
when 'Damage' then 'Beschädigung'
when 'Damage description' then 'Beschädigung Beschreibung'
when 'Dangerousgoods' then 'Gefährliche Ware'
when 'Doc-closing Datum' then 'Docu-schluss Datum'
when 'Doc-closing Zeit' then 'Docu-schluss Zeit'
when 'Dutiablegoods' then 'Zollpflichtige Ware'
when 'ETA' then 'ETA'
when 'Freistellung' then 'Freistellung'
when 'HuInbound Date' then 'Wareneingang Datum'
when 'HuInbound No' then 'Wareneingang Nummer'
when 'Invoiced' then 'Verrechnet'
when 'Ladeschluss Datum' then 'Ladeschluss Datum'
when 'Ladeschluss Zeit' then 'Ladeschluss Zeit'
when 'Leerdepot' then 'Leerdepot'
when 'Macros' then 'Vorschrifft'
when 'Makler' then 'Makler'
when 'PackingType' then 'Verpackungstyp'
when 'Protection' then 'Konservierung'
when 'Rücklieferung' then 'Rücklieferung'
when 'Seal No.' then 'Siegel Nummer'
when 'VGM' then 'Gewicht nach Verwiegung'
when 'VGM-closing Datum' then 'VGM-schluss Datum'
when 'VGM-closing Zeit' then 'VGM-schluss Zeit'
when 'V-Schein' then 'V-Schein'
when 'BXNLErrorMsg' then 'BoxCAD Fehlermeldung'

else '' end)
rollback
*/